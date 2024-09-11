import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/config/theme/styles.dart';

import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/features/note/data/models/note.dart';
import 'package:notepada/features/note/presentation/bloc/note_cubit.dart';
import 'package:notepada/features/note/presentation/bloc/note_state.dart';

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
  void initState() {
    super.initState();
    if (widget.note != null) {
      _title.text = widget.note!.title;
      _note.text = widget.note!.text!;
    }
  }

  @override
  void dispose() {
    _title.clear();
    _note.clear();

    _title.dispose();
    _note.dispose();
    super.dispose();
  }

  void _submit() {
    if (widget.note == null) {
      context.read<NoteCubit>().newNote(
            title: _title.text.toString(),
            text: _note.text.toString(),
          );
    } else {
      context.read<NoteCubit>().editNote(
            documentID: widget.note!.id,
            title: _title.text.toString(),
            text: _note.text.toString(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Column(
          children: [
            AppGaps.v10,
            TextField(
              controller: _title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
              ),
              decoration: AppStyles.lightTextFieldThemeBorderless.copyWith(
                hintText: AppStrings.titleHintText,
                hintStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              minLines: 1,
              maxLines: 2,
            ),
          ],
        ),
      ),
      body: BlocConsumer<NoteCubit, NoteState>(
        listener: (context, state) {
          if (state is NoteNewEditDeleteLoading) {
            _sendingData = true;
          } else if (state is NoteNewEditDeleteError) {
            _sendingData = false;
            var snackBar = SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.darkGrey,
              showCloseIcon: true,
              closeIconColor: AppColors.bright,
              content: Text(
                state.error,
                style: const TextStyle(color: Colors.white),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (state is NoteNewEditDeleteSuccess) {
            _sendingData = false; // Remove circular progress indicator
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
            // Redirect to home
            // if (widget.note != null) {
            context.goNamed(RouteNames.home);
            // } else {
            //   context.goNamed(RouteNames.editNote, extra: widget.note);
            // }
          }
        },
        builder: (context, state) => SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 0,
            right: 0,
          ),
          child: Column(
            children: [
              TextField(
                controller: _note,
                decoration: AppStyles.lightTextFieldThemeBorderless.copyWith(
                  hintText: AppStrings.noteHintText,
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                minLines: 25,
                maxLines: 120,
              ),
              AppGaps.v40,
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _submit();
                        },
                        child: _sendingData
                            ? const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.bright,
                              )
                            : const Text(AppStrings.saveNote),
                      ),
                      AppGaps.v10,
                      TextButton(
                        onPressed: () {
                          if (_title.text != '') {
                            _submit();
                          } else {
                            context.goNamed(RouteNames.home);
                          }
                        },
                        child: Text(_title.text != ''
                            ? AppStrings.back
                            : AppStrings.cancel),
                      ),
                      AppGaps.v10,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
