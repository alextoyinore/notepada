import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/core/util/storage/storage_service.dart';
import 'package:notepada/features/note/presentation/bloc/note_cubit.dart';
import 'package:notepada/features/note/presentation/bloc/note_state.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final userID = StorageService().getValue('userID');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.notes,
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        actions: [
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: AppColors.midGrey,
                width: 1,
              ),
            ),
            child: const Icon(Icons.person),
          )
        ],
      ),
      body: BlocProvider(
        create: (_) => NoteCubit()..getNotes(userID: userID),
        child: BlocBuilder<NoteCubit, NoteState>(builder: (context, state) {
          if (state is NoteFetchLoading) {
            return const Center(
              child: Text(
                AppStrings.gettingNotes,
                style: TextStyle(
                  color: AppColors.midGrey,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (state is NoteFetchError) {
            return const Center(
              child: Text(
                AppStrings.getNoteError,
                style: TextStyle(
                  color: AppColors.midGrey,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (state is NoteFetchSuccess) {
            return ListView.separated(
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Dismissible(
                    key: UniqueKey(),
                    background: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                    // secondaryBackground: const Icon(
                    //   Icons.delete,
                    //   color: AppColors.bright,
                    // ),
                    confirmDismiss: (DismissDirection direction) async {
                      // Your confirmation logic goes here
                      // Return true to allow dismissal, false to prevent it
                      return true;
                    },
                    onDismissed: (DismissDirection direction) {},
                    onResize: () {},
                    direction: DismissDirection.endToStart,
                    dragStartBehavior: DragStartBehavior.start,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: AppColors.grey.withOpacity(.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.notes[index].title,
                            style: AppStyles.noteListHeaderStyle,
                          ),
                          AppGaps.v10,
                          Text(
                            '${state.notes[index].text!.substring(0, 95)}...',
                          ),
                          AppGaps.v10,
                          Text(
                            state.notes[index].date.toString(),
                            style: const TextStyle(
                              color: AppColors.midGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => AppGaps.v10,
              itemCount: state.notes.length,
            );
          }
          return SizedBox();
        }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(RouteNames.editNote);
        },
        child: const Icon(
          Icons.mode_edit_outline_outlined,
        ),
      ),
    );
  }
}
