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

    // Text to Speech Settings
    pitch = context.read<VoicePitchCubit>().state / 100;
    rate = context.read<VoiceRateCubit>().state / 100;
    volume = context.read<VoiceVolumeCubit>().state / 100;
  }

  @override
  void dispose() {
    _editorFocusNode.dispose();
    _editorScrollController.keepScrollOffset;
    _quillController.dispose();
    super.dispose();
  }

  final _quillController = QuillController.basic();
  final _editorFocusNode = AlwaysDisabledFocusNode();
  final _editorScrollController = ScrollController();

  /// Text to Speech
  late double volume;
  late double pitch;
  late double rate;

  String? _voiceText;
  bool _playing = false;
  bool _paused = false;

  final FlutterTts flutterTts = FlutterTts();

  Future<void> _speak() async {
    await ttsSpeak(
        text: _quillController.document
            .getPlainText(0, _quillController.document.length - 1),
        context: context);
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
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.primary,
          ),
          softWrap: true,
        ),
        leading: IconButton(
          padding: const EdgeInsets.only(left: 20),
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.primary.withOpacity(.7),
          ),
        ),
        actions: [
          !_playing
              ? IconButton(
                  onPressed: _speak,
                  icon: const Icon(
                    Icons.volume_up,
                    size: 25,
                  ),
                )
              : IconButton(
                  onPressed: _stop,
                  icon: const Icon(
                    Icons.volume_up,
                    color: AppColors.primary,
                    size: 25,
                  ),
                ),
          IconButton(
            // padding: const EdgeInsets.only(right: 20),
            onPressed: () =>
                context.pushNamed(RouteNames.editNote, extra: widget.note),
            icon: const Icon(
              Icons.edit_outlined,
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
            icon: const Icon(
              Icons.delete_outline,
              size: 20,
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => appSnackBar(
            message: AppStrings.doubleTapDescription, context: context),
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
                      ? AppColors.primary
                      : AppColors.darkGrey,
                ),
              ),
              AppGaps.v10,
              SizedBox(
                width: MediaQuery.of(context).size.width,
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
