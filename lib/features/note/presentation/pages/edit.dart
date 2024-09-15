import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/config/theme/styles.dart';

import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/core/util/storage/storage_keys.dart';
import 'package:notepada/core/util/storage/storage_service.dart';
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
            color: '0x${_currentColor.toHexString()}',
          );
    } else {
      context.read<NoteCubit>().editNote(
            dateModified: DateTime.now().toIso8601String(),
            documentID: widget.note!.id,
            title: _title.text.toString(),
            text: _note.text.toString(),
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

  @override
  void initState() {
    super.initState();

    _defaultColor = Color(
        int.tryParse(_storedDefaultColor.getValue(StorageKeys.defaultColor)!)!);

    _currentColor = widget.note == null
        ? _defaultColor
        : Color(int.tryParse(widget.note!.color!)!);

    if (widget.note != null) {
      _title.text = widget.note!.title;
      _note.text = widget.note!.text!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
                // color: _currentColor,
              ),
              decoration: AppStyles.lightTextFieldThemeBorderless.copyWith(
                hintText: AppStrings.titleHintText,
                hintStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  // color: _currentColor,
                ),
              ),
              minLines: 1,
              maxLines: 1,
            ),
          ],
        ),

        actions: [
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
                width: 25,
                height: 25,
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
        // leading: IconButton(
        //   padding: const EdgeInsets.only(left: 20, right: 0),
        //   onPressed: () => context.pop(),
        //   icon: const Icon(
        //     Icons.arrow_back_ios,
        //     color: AppColors.darkGrey,
        //   ),
        // ),
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
            // Back to previous page
            // if (widget.note != null) {
            //   context.goNamed(
            //     RouteNames.viewNote,
            //     extra: widget.note,
            //   );
            // } else {
            context.goNamed(RouteNames.home);
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
                  // hintStyle: TextStyle(
                  //   color: _currentColor,
                  // ),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                // style: TextStyle(color: _currentColor),
                minLines: 26,
                maxLines: 1000,
              ),
              AppGaps.v30,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _submit();
                      },
                      child: _sendingData
                          ? const CircularProgressIndicator(
                              strokeWidth: 3,
                              color: AppColors.bright,
                            )
                          : const Text(AppStrings.saveNote),
                    ),
                    AppGaps.v10,
                    TextButton(
                      onPressed: () {
                        if (widget.note == null) {
                          // _submit();
                          context.goNamed(RouteNames.home);
                        } else {
                          context.goNamed(
                            RouteNames.viewNote,
                            extra: widget.note,
                          );
                        }
                      },
                      child: const Text(AppStrings.cancel),
                    ),
                    AppGaps.v10,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
