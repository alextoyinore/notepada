import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/common/bloc/settings/settings_cubit.dart';
import 'package:notepada/common/helpers/helpers.dart';
import 'package:notepada/common/widgets/app_alert.dart';
import 'package:notepada/common/widgets/app_snack.dart';
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

class SecretNotes extends StatefulWidget {
  const SecretNotes({super.key});

  @override
  State<SecretNotes> createState() => _SecretNotesState();
}

class _SecretNotesState extends State<SecretNotes> {
  final _storageService = StorageService();
  late double _listFontSize;
  late Color _defaultColor;
  late String userID;

  @override
  void initState() {
    super.initState();
    userID = _storageService.getValue(StorageKeys.userID);
    context.read<NoteCubit>().getNotes(userID: userID, isSecret: true);
    _listFontSize = context.read<NoteListFontCubit>().state.toDouble();

    // Default Color
    _defaultColor = Color(
        int.tryParse(_storageService.getValue(StorageKeys.defaultColor)!)!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
          ),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              child: TextField(
                decoration: Theme.of(context).brightness == Brightness.dark
                    ? AppStyles.darkTextFieldThemeBorderless.copyWith(
                        hintText: '${AppStrings.search} ${AppStrings.notes}',
                        hintStyle: const TextStyle(color: AppColors.midGrey),
                        suffixIcon: const Icon(
                          Icons.search,
                          color: AppColors.midGrey,
                        ))
                    : AppStyles.lightTextFieldThemeBorderless.copyWith(
                        hintText: '${AppStrings.search} ${AppStrings.notes}',
                        hintStyle: const TextStyle(color: AppColors.grey),
                        suffixIcon: const Icon(
                          Icons.search,
                          color: AppColors.grey,
                        )),
              ),
            ),
          ],
        ),
        // actions: [],
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
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                setState(() {
                  context
                      .read<NoteCubit>()
                      .getNotes(userID: userID, isSecret: true);
                });
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      TextButton(
                        onPressed: () {
                          context
                              .read<NoteCubit>()
                              .getNotes(userID: userID, isSecret: true);
                        },
                        child: const Text(AppStrings.refresh),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (state is NoteFetchSuccess) {
            if (state.notes.isEmpty) {
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  setState(() {
                    context
                        .read<NoteCubit>()
                        .getNotes(userID: userID, isSecret: true);
                  });
                },
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppImages.empty,
                        height: 150,
                      ),
                      AppGaps.v10,
                      const Text(
                        AppStrings.noSecretNotes,
                        style: TextStyle(),
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () {
                          context
                              .read<NoteCubit>()
                              .getNotes(userID: userID, isSecret: true);
                        },
                        child: const Text(AppStrings.refresh),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  setState(() {
                    context
                        .read<NoteCubit>()
                        .getNotes(userID: userID, isSecret: true);
                  });
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                            appAlert(
                                context: context,
                                title: AppStrings.delete,
                                message: AppStrings.deleteDescription,
                                continue_: () {
                                  context.read<NoteCubit>().deleteNote(
                                      documentID: state.notes[index].id);
                                  appSnackBar(
                                      message: AppStrings.deleted,
                                      context: context);
                                  setState(() {
                                    context.read<NoteCubit>().getNotes(
                                        userID: userID, isSecret: true);
                                  });
                                });
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
                            margin: const EdgeInsets.only(bottom: 15),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: state.notes[index].color != null
                                  ? Color(int.tryParse(
                                          state.notes[index].color!)!)
                                      .withOpacity(.1)
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
                                state.notes[index].plainText! != ''
                                    ? state.notes[index].plainText!.length >= 61
                                        ? Column(
                                            children: [
                                              AppGaps.v10,
                                              Text(
                                                '${state.notes[index].plainText!.substring(0, 60)}...',
                                                style: TextStyle(
                                                  fontSize: _listFontSize,
                                                  color: state.notes[index]
                                                              .color !=
                                                          null
                                                      ? darken(
                                                          Color(int.tryParse(
                                                              state.notes[index]
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
                                                state.notes[index].plainText!,
                                                style: TextStyle(
                                                  fontSize: _listFontSize,
                                                  color: state.notes[index]
                                                              .color !=
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
                                  toHumanReadableDate(
                                      state.notes[index].date.toString()),
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
                  itemCount: state.notes.length,
                ),
              );
            }
          }
          return const SizedBox();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.zero,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onPressed: () {
            context.pushNamed(RouteNames.editNote);
          },
          child: const Icon(
            Icons.mode_edit_outline_outlined,
          ),
        ),
      ),
    );
  }
}
