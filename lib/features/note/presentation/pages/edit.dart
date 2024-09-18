import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/common/bloc/settings/settings_cubit.dart';
import 'package:notepada/common/widgets/app_snack.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/config/theme/styles.dart';

import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/core/util/storage/storage_keys.dart';
import 'package:notepada/core/util/storage/storage_service.dart';
import 'package:notepada/features/note/data/models/note.dart';
import 'package:notepada/features/note/presentation/bloc/note_cubit.dart';
import 'package:notepada/features/note/presentation/bloc/note_state.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class EditNote extends StatefulWidget {
  final NoteModel? note;
  const EditNote({super.key, this.note});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _note = TextEditingController();

  bool _sendingData = false;

  @override
  void dispose() {
    _title.clear();
    _note.clear();

    _title.dispose();
    _note.dispose();

    _editorFocusNode.dispose();
    _editorScrollController.dispose();
    _quillController.dispose();
    super.dispose();
  }

  void _submit() {
    String bottomPadding = '\n';
    final noteText = jsonEncode(_quillController.document.toDelta().toJson());
    noteText.padRight(50, bottomPadding);
    if (widget.note == null) {
      context.read<NoteCubit>().newNote(
            title: _title.text.toString(),
            formattedText: noteText,
            plainText: _quillController.document.toPlainText(),
            color: '0x${_currentColor.toHexString()}',
          );
    } else {
      context.read<NoteCubit>().editNote(
            dateModified: DateTime.now().toIso8601String(),
            documentID: widget.note!.id,
            title: _title.text.toString(),
            plainText: _quillController.document.toPlainText(),
            formattedText: noteText,
            color: '0x${_currentColor.toHexString()}',
          );
    }
  }

  // StorageService
  final _storedDefaultColor = StorageService();

  // some color values
  Color _pickerColor = AppColors.darkGrey;
  late Color _currentColor;
  late Color _defaultColor;

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => _pickerColor = color);
  }

  final _quillController = QuillController.basic();
  final _editorFocusNode = FocusNode();
  final _editorScrollController = ScrollController();

  final _fontSizeValues = {
    'Smallest': '16',
    'Smaller': '24',
    'Small': '32',
    'Medium': '40',
    'Large': '48',
    'Larger': '56',
    'Largest': '64',
  };

  late bool _editing;

  @override
  void initState() {
    super.initState();

    _editing = false;

    _defaultColor = Color(
        int.tryParse(_storedDefaultColor.getValue(StorageKeys.defaultColor)!)!);

    _currentColor = widget.note == null
        ? _defaultColor
        : Color(int.tryParse(widget.note!.color!)!);

    if (widget.note != null) {
      _title.text = widget.note!.title;
      // _note.text = widget.note!.text!;
      _quillController.document =
          Document.fromJson(jsonDecode(widget.note!.formattedText!));
    }

    _speechToText = stt.SpeechToText();
  }

  bool _listening = false;
  late stt.SpeechToText _speechToText;
  String _text = 'Tap the mic icon and start speaking now';
  double _confidence = 1.0;

  void _captureVoice() async {
    if (!_listening) {
      bool listen = await _speechToText.initialize();

      if (listen) {
        setState(() => _listening = true);
        _speechToText.listen(
            onResult: (result) => setState(() {
                  _text = result.recognizedWords;
                  if (result.hasConfidenceRating && _confidence > 0) {
                    _confidence = result.confidence;
                  }
                }));
      } else {
        setState(() {
          _listening = false;
          _speechToText.stop();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: TextField(
          controller: _title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: (context.read<NoteViewFontCubit>().state.toDouble()),
          ),
          decoration: AppStyles.lightTextFieldThemeBorderless.copyWith(
            hintText: AppStrings.titleHintText,
            hintStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          minLines: 1,
          maxLines: 1,
        ),
        actions: [
          IconButton(
            onPressed: _captureVoice,
            icon:
                _listening ? const Icon(Icons.mic) : const Icon(Icons.mic_none),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => // raise the [showDialog] widget
                  showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(AppStrings.chooseNoteColor),
                  content: SingleChildScrollView(
                    child: BlockPicker(
                      pickerColor: _currentColor,
                      onColorChanged: changeColor,
                      // availableColors: [],
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text(AppStrings.confirm),
                      onPressed: () {
                        setState(() => _currentColor = _pickerColor);
                        Navigator.of(context).pop();
                        // print(_currentColor.toHexString());
                      },
                    ),
                  ],
                ),
              ),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: _currentColor,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    width: 2,
                    color: AppColors.darkGrey.withOpacity(.1),
                  ),
                ),
              ),
            ),
          ),
        ],
        leading: IconButton(
          padding: const EdgeInsets.only(left: 20, right: 0),
          onPressed: () => context.goNamed(RouteNames.home),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.darkGrey,
          ),
        ),
      ),
      body: BlocConsumer<NoteCubit, NoteState>(
        listener: (context, state) {
          if (state is NoteNewEditDeleteLoading) {
            setState(() {
              _sendingData = true;
            });
          } else if (state is NoteNewEditDeleteError) {
            setState(() {
              _sendingData = true;
            });
            appSnackBar(text: state.error, context: context);
          } else if (state is NoteNewEditDeleteSuccess) {
            setState(() {
              _sendingData = true;
            }); // Remove circular progress indicator
            // Show snackbar message
            var snackBar = const SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.darkGrey,
              showCloseIcon: true,
              closeIconColor: AppColors.bright,
              content: Text(
                AppStrings.noteSaved,
                style: TextStyle(color: Colors.white),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            context.goNamed(RouteNames.home);
          }
        },
        builder: (context, state) => Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            SingleChildScrollView(
              // reverse: true,
              padding: const EdgeInsets.only(
                left: 0,
                right: 0,
              ),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: QuillEditor.basic(
                      controller: _quillController,
                      focusNode: _editorFocusNode,
                      scrollController: _editorScrollController,
                      configurations: QuillEditorConfigurations(
                          customStyles:
                              const DefaultStyles(color: AppColors.primary),
                          magnifierConfiguration:
                              const TextMagnifierConfiguration(),
                          placeholder: AppStrings.noteHintText,
                          checkBoxReadOnly: true,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          scrollBottomInset: 20,
                          keyboardAppearance:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Brightness.dark
                                  : Brightness.light),
                    ),
                  ),
                  AppGaps.v10,
                ],
              ),
            ),
            QuillSimpleToolbar(
              controller: _quillController,
              configurations: QuillSimpleToolbarConfigurations(
                toolbarIconAlignment: WrapAlignment.start,
                multiRowsDisplay: false,
                showDividers: false,
                showSmallButton: true,
                showLineHeightButton: true,
                showAlignmentButtons: true,
                showDirection: true,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.backgroundDark
                      : AppColors.backgroundLight,
                ),
                fontSizesValues: _fontSizeValues,
                toolbarSize: 40,
                color: _currentColor,
                dialogTheme: QuillDialogTheme(
                  dialogBackgroundColor: _currentColor,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: FloatingActionButton(
          elevation: 0,
          onPressed: () {
            _submit();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: _sendingData
              ? const SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppColors.bright,
                  ),
                )
              : const Icon(Icons.save),
        ),
      ),
    );
  }
}
