import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/common/bloc/dash/dash_cubit.dart';
import 'package:notepada/common/bloc/settings/settings_cubit.dart';
import 'package:notepada/common/helpers/helpers.dart';
import 'package:notepada/common/widgets/app_alert.dart';
import 'package:notepada/common/widgets/app_snack.dart';
import 'package:notepada/common/widgets/appbar.dart';
import 'package:notepada/config/assets/images.dart';
import 'package:notepada/config/assets/vectors.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/core/util/storage/storage_keys.dart';
import 'package:notepada/core/util/storage/storage_service.dart';
import 'package:notepada/features/note/presentation/widgets/note_list_item.dart';
import 'package:notepada/features/note/presentation/bloc/note_cubit.dart';
import 'package:notepada/features/note/presentation/bloc/note_state.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final _storageService = StorageService();
  late double _listFontSize;
  late Color _defaultColor;
  late String userID;

  @override
  void initState() {
    super.initState();
    userID = _storageService.getValue(StorageKeys.userID);
    context.read<NoteCubit>().getNotes(userID: userID, isSecret: false);
    _listFontSize = context.read<NoteListFontCubit>().state.toDouble();

    // Default Color
    _defaultColor = Color(
        int.tryParse(_storageService.getValue(StorageKeys.defaultColor)!)!);
  }

  bool playing = false;
  int playingIndex = -1;

  bool isFavourite = false;
  int favouriteIndex = -1;

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, searchController: _searchController),
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
                      .getNotes(userID: userID, isSecret: false);
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
                              .getNotes(userID: userID, isSecret: false);
                        },
                        child: const Text(AppStrings.tryAgain),
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
                        .getNotes(userID: userID, isSecret: false);
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
                        AppStrings.noNotes,
                        style: TextStyle(),
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () {
                          context
                              .read<NoteCubit>()
                              .getNotes(userID: userID, isSecret: false);
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
                        .getNotes(userID: userID, isSecret: false);
                  });
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    return NoteListItem(
                      view: () => context.pushNamed(
                        RouteNames.viewNote,
                        extra: state.notes[index],
                      ),
                      context: context,
                      note: state.notes[index],
                      index: index,
                      listFontSize: _listFontSize,
                      playing: playing,
                      playingIndex: playingIndex,
                      play: () {
                        ttsSpeak(
                            text: state.notes[index].plainText!,
                            context: context);
                        setState(() {
                          playing = true;
                          playingIndex = index;
                        });
                      },
                      stop: () {
                        ttsStop();
                        setState(() {
                          playing = false;
                          playingIndex = -1;
                        });
                      },
                      isFavourite: !isFavourite,
                      isFavouriteIndex: favouriteIndex,
                      favourite: () {
                        context.read<NoteCubit>().editNote(
                            documentID: state.notes[index].id,
                            title: state.notes[index].title,
                            formattedText: state.notes[index].formattedText,
                            plainText: state.notes[index].plainText,
                            color: state.notes[index].color,
                            isSecret: state.notes[index].isSecret,
                            isFavourite:
                                state.notes[index].isFavourite == null ||
                                        state.notes[index].isFavourite == false
                                    ? true
                                    : false,
                            dateModified: DateTime.now().toString());
                        context.read<DashBoardCubit>().updateSelectedIndex(0);
                        context.pushNamed(RouteNames.dashboard);
                      },
                      addToVN: () {},
                      edit: () {
                        context.pushNamed(
                          RouteNames.editNote,
                          extra: state.notes[index],
                        );
                      },
                      delete: () {
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
                                context
                                    .read<NoteCubit>()
                                    .getNotes(userID: userID);
                              });
                            });
                      },
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
    );
  }
}
