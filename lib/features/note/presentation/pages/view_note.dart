import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/common/bloc/settings/settings_cubit.dart';
import 'package:notepada/common/helpers/helpers.dart';
import 'package:notepada/common/widgets/app_snack.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/features/note/data/models/note.dart';
import 'package:notepada/features/note/presentation/bloc/note_cubit.dart';

class ViewNote extends StatefulWidget {
  final NoteModel note;
  const ViewNote({super.key, required this.note});

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  @override
  void initState() {
    super.initState();
    _quillController.document =
        Document.fromJson(jsonDecode(widget.note.formattedText!));
    // _quillController.readOnly = true;
    // _quillController.skipRequestKeyboard = true;
  }

  @override
  void dispose() {
    _editorFocusNode.dispose();
    _editorScrollController.dispose();
    _quillController.dispose();
    super.dispose();
  }

  final _quillController = QuillController.basic();
  final _editorFocusNode = AlwaysDisabledFocusNode();
  final _editorScrollController = ScrollController();

  // final StorageService _storageService = StorageService();

  /// Text to Speech
  double volume = 1.0;
  double pitch = 1.0;
  double rate = 0.5;

  String? _voiceText;
  bool _playing = false;
  bool _paused = false;

  final FlutterTts flutterTts = FlutterTts();

  Future<void> _speak() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);
    _voiceText =
        '${widget.note.title}\n${_quillController.document.getPlainText(0, _quillController.document.length)}';
    await flutterTts.speak(_voiceText!);
    setState(() {
      _playing = true;
      _paused = false;
    });
  }

  Future<void> _pause() async {
    await flutterTts.pause();
    setState(() {
      _paused = true;
      _playing = false;
    });
  }

  Future<void> _stop() async {
    await flutterTts.stop();
    setState(() {
      _playing = false;
      _paused = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Text(
          widget.note.title,
          style: TextStyle(
            fontSize: 13,
            color: Color(
              int.tryParse(widget.note.color!)!,
            ),
          ),
          softWrap: true,
        ),
        leading: IconButton(
          padding: const EdgeInsets.only(left: 20),
          onPressed: () => context.pushNamed(RouteNames.home),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(
              int.tryParse(widget.note.color!)!,
            ).withOpacity(.7),
          ),
        ),
        actions: [
          !_playing
              ? IconButton(
                  onPressed: _speak,
                  icon: Icon(
                    Icons.play_circle_outline,
                    size: 25,
                    color: Color(
                      int.tryParse(widget.note.color!)!,
                    ),
                  ),
                )
              : IconButton(
                  onPressed: _stop,
                  icon: Icon(
                    Icons.stop_circle,
                    color: Color(
                      int.tryParse(widget.note.color!)!,
                    ),
                    size: 30,
                  ),
                ),
          // Row(
          //   children: [
          //     IconButton(
          //       onPressed: () {
          //         setState(() {
          //           context.read<NoteViewFontCubit>().decrement();
          //         });
          //       },
          //       icon: Icon(
          //         Icons.remove,
          //         color: Color(
          //           int.tryParse(widget.note.color!)!,
          //         ),
          //       ),
          //     ),
          //     Text(
          //       context.read<NoteViewFontCubit>().state.toString(),
          //       style: TextStyle(
          //         fontWeight: FontWeight.bold,
          //         color: Color(
          //           int.tryParse(widget.note.color!)!,
          //         ),
          //       ),
          //     ),
          //     IconButton(
          //       onPressed: () {
          //         setState(() {
          //           context.read<NoteViewFontCubit>().increment();
          //         });
          //       },
          //       icon: Icon(
          //         Icons.add,
          //         color: Color(
          //           int.tryParse(widget.note.color!)!,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          IconButton(
            padding: const EdgeInsets.only(right: 20),
            onPressed: () =>
                context.pushNamed(RouteNames.editNote, extra: widget.note),
            icon: Icon(
              Icons.edit_outlined,
              color: Color(
                int.tryParse(widget.note.color!)!,
              ),
              size: 20,
            ),
          ),
          IconButton(
            padding: const EdgeInsets.only(right: 20),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: const Text(
                  AppStrings.confirmDelete,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: const Text(AppStrings.deleteDescription),
                actions: [
                  TextButton(
                    onPressed: () => context.pop(false),
                    child: const Text(AppStrings.cancel),
                  ),
                  TextButton(
                    onPressed: () {
                      context
                          .read<NoteCubit>()
                          .deleteNote(documentID: widget.note.id);

                      context.pushNamed(RouteNames.home);
                    },
                    child: const Text(AppStrings.continue_),
                  )
                ],
              ),
            ),
            icon: Icon(
              Icons.delete,
              color: Color(
                int.tryParse(widget.note.color!)!,
              ),
              size: 20,
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => appSnackBar(
            text: AppStrings.doubleTapDescription, context: context),
        onDoubleTap: () =>
            context.pushNamed(RouteNames.editNote, extra: widget.note),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.note.title,
                style: TextStyle(
                  fontSize:
                      (context.read<NoteViewFontCubit>().state.toDouble() * 2),
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Color(int.tryParse(widget.note.color!)!)
                      : AppColors.darkGrey,
                ),
              ),
              AppGaps.v10,
              SizedBox(
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height * .70,
                child: QuillEditor.basic(
                  controller: _quillController,
                  focusNode: _editorFocusNode,
                  scrollController: _editorScrollController,
                  configurations: QuillEditorConfigurations(
                    checkBoxReadOnly: false,
                    keyboardAppearance:
                        Theme.of(context).brightness == Brightness.dark
                            ? Brightness.dark
                            : Brightness.light,
                  ),
                ),
              ),
              AppGaps.v20,
            ],
          ),
        ),
      ),
    );
  }
}
