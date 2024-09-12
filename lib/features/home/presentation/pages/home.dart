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

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final userID = StorageService().getValue('userID');

  @override
  void initState() {
    super.initState();
    context.read<NoteCubit>().getNotes(userID: userID);
    // Try refreshing state
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          AppStrings.notes,
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            padding: const EdgeInsets.only(right: 8),
            icon: const Icon(Icons.person),
          )
        ],
      ),
      body: BlocBuilder<NoteCubit, NoteState>(
        builder: (context, state) {
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
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  AppStrings.getNoteError,
                  style: TextStyle(
                    color: AppColors.midGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state is NoteFetchSuccess) {
            if (state.notes.isEmpty) {
              return const Center(
                child: Text(
                  AppStrings.noNotes,
                  style: TextStyle(
                    color: AppColors.midGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return ListView.separated(
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () => context.pushNamed(
                      RouteNames.viewNote,
                      extra: state.notes[index],
                    ),
                    child: Padding(
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
                        //   color: AppColors.primary,
                        // ),
                        confirmDismiss: (DismissDirection direction) async {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text(AppStrings.confirmDelete),
                              content: const Text(AppStrings.deleteDescription),
                              actions: [
                                TextButton(
                                  onPressed: () => context.pop(false),
                                  child: const Text(AppStrings.cancel),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.read<NoteCubit>().deleteNote(
                                        documentID: state.notes[index].id);
                                    context
                                        .read<NoteCubit>()
                                        .getNotes(userID: userID);
                                    context.pop(true);
                                  },
                                  child: const Text(AppStrings.continue_),
                                )
                              ],
                            ),
                          );
                        },
                        onDismissed: (DismissDirection direction) async {},
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
                              state.notes[index].text! != ''
                                  ? state.notes[index].text!.length >= 96
                                      ? Column(
                                          children: [
                                            AppGaps.v10,
                                            Text(
                                                '${state.notes[index].text!.substring(0, 95)}...'),
                                          ],
                                        )
                                      : Column(
                                          children: [
                                            AppGaps.v10,
                                            Text(state.notes[index].text!),
                                          ],
                                        )
                                  : const SizedBox(
                                      width: 0,
                                      height: 0,
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
                    ),
                  );
                },
                separatorBuilder: (context, index) => AppGaps.v10,
                itemCount: state.notes.length,
              );
            }
          }
          return const SizedBox();
        },
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
