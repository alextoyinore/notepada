import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/common/bloc/settings/settings_cubit.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/core/util/storage/storage_keys.dart';
import 'package:notepada/core/util/storage/storage_service.dart';
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
  }

  // final StorageService _storageService = StorageService();

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
          onPressed: () => context.goNamed(RouteNames.home),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(
              int.tryParse(widget.note.color!)!,
            ).withOpacity(.7),
          ),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    context.read<NoteViewFontCubit>().decrement();
                  });
                },
                icon: const Icon(Icons.remove),
              ),
              Text(
                context.read<NoteViewFontCubit>().state.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    context.read<NoteViewFontCubit>().increment();
                  });
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          IconButton(
            padding: const EdgeInsets.only(right: 20),
            onPressed: () =>
                context.pushNamed(RouteNames.editNote, extra: widget.note),
            icon: Icon(
              Icons.edit_outlined,
              color: Color(
                int.tryParse(widget.note.color!)!,
              ),
              size: 16,
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

                      context.goNamed(RouteNames.home);
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
              size: 16,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: GestureDetector(
          onDoubleTap: () =>
              context.pushNamed(RouteNames.editNote, extra: widget.note),
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
              Text(
                widget.note.text!,
                style: TextStyle(
                  fontSize: context.read<NoteViewFontCubit>().state.toDouble(),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Color(int.tryParse(widget.note.color!)!)
                      : AppColors.darkGrey,
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
