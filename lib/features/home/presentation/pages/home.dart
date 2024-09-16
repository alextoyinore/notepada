import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/common/bloc/settings/settings_cubit.dart';
import 'package:notepada/common/helpers/extensions.dart';
import 'package:notepada/config/assets/images.dart';
import 'package:notepada/config/assets/vectors.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/core/util/storage/storage_keys.dart';
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
  final StorageService _storageService = StorageService();
  late double _listFontSize;

  @override
  void initState() {
    super.initState();
    context.read<NoteCubit>().getNotes(userID: userID);
    _listFontSize = context.read<NoteListFontCubit>().state.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: Theme.of(context).brightness == Brightness.dark
              ? const EdgeInsets.only(left: 16.0)
              : EdgeInsets.zero,
          child: Text(
            AppStrings.notes,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.bright
                  : AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.goNamed(RouteNames.profile);
            },
            padding: const EdgeInsets.only(right: 16),
            icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(.1),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                AppVectors.profile,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcATop,
                ),
                height: 16,
              ),
            ),
          )
        ],
      ),
      body: BlocBuilder<NoteCubit, NoteState>(
        builder: (context, state) {
          if (state is NoteFetchLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImages.gettingNotes,
                    height: 150,
                  ),
                  AppGaps.v10,
                  const Text(
                    AppStrings.gettingNotes,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (state is NoteFetchError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppVectors.warning,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcATop,
                      ),
                      height: 100,
                    ),
                    AppGaps.v20,
                    const Text(
                      AppStrings.getNoteError,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is NoteFetchSuccess) {
            if (state.notes.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    Image.asset(
                      AppImages.empty,
                      height: 200,
                    ),
                    AppGaps.v10,
                    const Text(
                      AppStrings.noNotes,
                      style: TextStyle(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else {
              return ListView.separated(
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () => context.goNamed(
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
                          return null;
                        },
                        onDismissed: (DismissDirection direction) async {},
                        onResize: () {},
                        direction: DismissDirection.endToStart,
                        dragStartBehavior: DragStartBehavior.start,

                        // Note List Container Widget
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: state.notes[index].color != null
                                ? Color(int.tryParse(
                                        state.notes[index].color!)!)
                                    .withOpacity(.07)
                                : AppColors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.notes[index].title,
                                style: AppStyles.noteListHeaderStyle.copyWith(
                                    fontSize: (_listFontSize * 1.25),
                                    color: state.notes[index].color != null
                                        ? darken(Color(int.tryParse(
                                            state.notes[index].color!)!))
                                        : AppColors.darkGrey),
                              ),
                              state.notes[index].text! != ''
                                  ? state.notes[index].text!.length >= 96
                                      ? Column(
                                          children: [
                                            AppGaps.v10,
                                            Text(
                                              '${state.notes[index].text!.substring(0, 95)}...',
                                              style: TextStyle(
                                                fontSize: _listFontSize,
                                                color: state.notes[index]
                                                            .color !=
                                                        null
                                                    ? darken(
                                                        Color(int.tryParse(state
                                                            .notes[index]
                                                            .color!)!),
                                                      )
                                                    : AppColors.darkGrey,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Column(
                                          children: [
                                            AppGaps.v10,
                                            Text(
                                              state.notes[index].text!,
                                              style: TextStyle(
                                                color:
                                                    state.notes[index].color !=
                                                            null
                                                        ? darken(Color(
                                                            int.tryParse(state
                                                                .notes[index]
                                                                .color!)!,
                                                          ))
                                                        : AppColors.darkGrey,
                                              ),
                                            ),
                                          ],
                                        )
                                  : const SizedBox(
                                      width: 0,
                                      height: 0,
                                    ),
                              AppGaps.v10,
                              Text(
                                state.notes[index].date.toString(),
                                style: TextStyle(
                                  color: state.notes[index].color != null
                                      ? Color(
                                          int.tryParse(
                                              state.notes[index].color!)!,
                                        ).withOpacity(.5)
                                      : AppColors.midGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => AppGaps.v15,
                itemCount: state.notes.length,
              );
            }
          }
          return const SizedBox();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
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
