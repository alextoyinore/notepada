import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/common/bloc/dash/dash_cubit.dart';
import 'package:notepada/common/bloc/settings/settings_cubit.dart';
import 'package:notepada/common/sources/local/lists.dart';
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
import 'package:avatar_glow/avatar_glow.dart';

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
    _editorScrollController.keepScrollOffset;
    _quillController.dispose();
    super.dispose();
  }

  void _submit() {
    final noteText = jsonEncode(_quillController.document.toDelta().toJson());
    if (widget.note == null) {
      context.read<NoteCubit>().newNote(
            title: _title.text.toString(),
            formattedText: noteText,
            isSecret: _isSecret,
            plainText: _quillController.document.toPlainText(),
            color: '0x${_currentColor.toHexString()}',
          );
    } else {
      context.read<NoteCubit>().editNote(
            dateModified: DateTime.now().toIso8601String(),
            documentID: widget.note!.id,
            title: _title.text.toString(),
            isSecret: _isSecret,
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

  bool _isSecret = false;

  @override
  void initState() {
    super.initState();

    _isSecret = widget.note?.isSecret ?? false;

    _defaultColor = Color(
        int.tryParse(_storedDefaultColor.getValue(StorageKeys.defaultColor)!)!);

    _currentColor = widget.note == null
        ? _defaultColor
        : Color(int.tryParse(widget.note!.color!)!);

    if (widget.note != null) {
      _title.text = widget.note!.title;
      _quillController.document =
          Document.fromJson(jsonDecode(widget.note!.formattedText!));
    }

    _speechToText = stt.SpeechToText();
  }

  bool _listening = false;
  late stt.SpeechToText _speechToText;
  String _text = AppStrings.speakDescription;
  double _confidence = 1.0;
  bool _talkBoard = false;

  /// Speech to Text
  void captureVoice() async {
    if (!_listening) {
      bool listen = await _speechToText.initialize();

      if (listen) {
        setState(() {
          _listening = true;
          _talkBoard = true;
        });
        _speechToText.listen(
            listenFor: const Duration(minutes: 1),
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

  void copyToEditor() {
    setState(() {
      var editorDoc = _quillController.document;

      if (editorDoc.length == 0) {
        _quillController.document.insert(0, '\n\n$_text\n\n\n');
      } else {
        // Append speech to text to editor
        _quillController.document
            .insert(_quillController.document.length - 1, '\n\n$_text\n\n\n');
      }

      _listening = false;
      _speechToText.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, value) => _submit,
      child: Scaffold(
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
              hintStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.midGrey
                    : AppColors.grey,
              ),
            ),
            minLines: 1,
            maxLines: 1,
          ),
          actions: [
            !_isSecret
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _isSecret = true;
                      });
                    },
                    icon: const Icon(
                      Icons.lock_open,
                      size: 20,
                    ))
                : IconButton(
                    onPressed: () {
                      setState(() {
                        _isSecret = false;
                      });
                    },
                    icon: const Icon(
                      Icons.lock,
                      size: 20,
                      color: AppColors.blue,
                    )),
            !_listening
                ? IconButton(
                    onPressed: captureVoice,
                    icon: const Icon(Icons.mic_none),
                  )
                : AvatarGlow(
                    animate: _listening,
                    glowColor: AppColors.primary,
                    startDelay: const Duration(milliseconds: 2000),
                    repeat: true,
                    glowCount: 3,
                    child: IconButton(
                      onPressed: () => setState(() {
                        _listening = false;
                        _speechToText.stop();
                      }),
                      icon: const Icon(
                        Icons.mic,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
            IconButton(
              padding: const EdgeInsets.only(right: 16),
              onPressed: _submit,
              icon: _sendingData
                  ? const Icon(
                      Icons.save,
                      size: 25,
                      color: AppColors.primary,
                    )
                  : const Icon(
                      Icons.save,
                      size: 25,
                    ),
            ),
          ],
          leading: IconButton(
            padding: const EdgeInsets.only(left: 20, right: 0),
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios,
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
                _sendingData = false;
              });
              appSnackBar(context: context, message: state.error);
            } else if (state is NoteNewEditDeleteSuccess) {
              setState(() {
                _sendingData = false;
              }); // Remove circular progress indicator
              appSnackBar(context: context, message: AppStrings.noteSaved);
              context.read<SelectedIndexCubit>().updateSelectedIndex(0);
              context.goNamed(RouteNames.dashboard,
                  extra: {'selectedApp': 'notes'});
            }
          },
          builder: (context, state) => Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Column(
                children: [
                  _talkBoard == true
                      ? Container(
                          height: MediaQuery.of(context).size.height / 5,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: SingleChildScrollView(
                            reverse: true,
                            child: Column(
                              children: [
                                Text(
                                  _text,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: _currentColor),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Confidence: ${(_confidence * 100).toStringAsFixed(1)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: copyToEditor,
                                        child: const Text(
                                          AppStrings.copyToEditor,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    TextButton(
                                        onPressed: (() => setState(() {
                                              _talkBoard = false;
                                              _listening = false;
                                              _speechToText.stop();
                                            })),
                                        child: const Text(AppStrings.close)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      : AppGaps.v0,
                  Expanded(
                    child: QuillEditor.basic(
                      controller: _quillController,
                      focusNode: _editorFocusNode,
                      scrollController: _editorScrollController,
                      configurations: QuillEditorConfigurations(
                          floatingCursorDisabled: true,
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
                  fontSizesValues: AppLists.fontSizeValues,
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
        // floatingActionButton: Padding(
        //   padding: const EdgeInsets.only(bottom: 50.0),
        //   child: FloatingActionButton(
        //     elevation: 0,
        //     onPressed: () {
        //       _submit();
        //     },
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(50),
        //     ),
        //     child: _sendingData
        //         ? const SizedBox(
        //             height: 25,
        //             width: 25,
        //             child: CircularProgressIndicator(
        //               strokeWidth: 3,
        //               color: AppColors.bright,
        //             ),
        //           )
        //         : const Icon(Icons.save),
        //   ),
        // ),
      ),
    );
  }
}
