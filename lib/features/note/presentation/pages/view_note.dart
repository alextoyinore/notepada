import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/features/note/data/models/note.dart';
import 'package:notepada/features/note/presentation/bloc/note_cubit.dart';

class ViewNote extends StatelessWidget {
  final NoteModel note;
  const ViewNote({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor:
      //     Color.lerp(Color(int.tryParse(note.color!)!), Colors.white, .9),
      appBar: AppBar(
        // backgroundColor:
        //     Color.lerp(Color(int.tryParse(note.color!)!), Colors.white, .9),
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Text(
          note.title,
          style: TextStyle(
            fontSize: 13,
            color: Color(
              int.tryParse(note.color!)!,
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
              int.tryParse(note.color!)!,
            ).withOpacity(.4),
          ),
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 20),
            onPressed: () =>
                context.pushNamed(RouteNames.editNote, extra: note),
            icon: Icon(
              Icons.edit_outlined,
              color: Color(
                int.tryParse(note.color!)!,
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
                      context.read<NoteCubit>().deleteNote(documentID: note.id);

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
                int.tryParse(note.color!)!,
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
              context.pushNamed(RouteNames.editNote, extra: note),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
              ),
              AppGaps.v10,
              Text(
                note.text!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGrey,
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
