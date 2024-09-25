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

  TextEditingController _searchController = TextEditingController();

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
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: IconButton(
                onPressed: () {
                  context.pushNamed(RouteNames.profile);
                },
                padding: const EdgeInsets.only(right: 16),
                icon: Container(
                  padding: const EdgeInsets.all(12.5),
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
              ),
            ),
            // AppGaps.h10,
            SizedBox(
              height: 42,
              width: MediaQuery.of(context).size.width * .65,
              child: SearchBar(
                controller: _searchController,
                elevation: const WidgetStatePropertyAll(0),
                backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkGrey
                      : AppColors.grey.withOpacity(.1),
                ),
                shape: const WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                ),
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 10),
                ),
                hintText: '${AppStrings.search} ${AppStrings.appName}',
                hintStyle: const WidgetStatePropertyAll(
                  TextStyle(
                    color: AppColors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: AppColors.darkGrey,
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
                    return GestureDetector(
                      onTap: () => context.pushNamed(
                        RouteNames.viewNote,
                        extra: state.notes[index],
                      ),
                      child: NoteListItem(context, state, index),
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

  bool playing = false;
  int playingIndex = -1;

  Widget NoteListItem(
    BuildContext context,
    NoteFetchSuccess state,
    int index,
  ) {
    final note = state.notes[index];
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20,
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: note.color != null
            ? Color(int.tryParse(note.color!)!).withOpacity(.1)
            : AppColors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            toHumanReadableDate(note.date.toString()),
            style: TextStyle(
              color: note.color != null
                  ? Color(
                      int.tryParse(note.color!)!,
                    ).withOpacity(.5)
                  : AppColors.midGrey,
            ),
          ),
          AppGaps.v10,
          Text(
            note.title,
            style: AppStyles.noteListHeaderStyle.copyWith(
                fontSize: (_listFontSize * 1.25),
                color: note.color != null
                    ? darken(Color(int.tryParse(note.color!)!))
                    : AppColors.darkGrey),
          ),
          note.plainText! != ''
              ? note.plainText!.length >= 61
                  ? Column(
                      children: [
                        AppGaps.v10,
                        Text(
                          '${note.plainText!.substring(0, 60).replaceAll('\n', ' ')}...',
                          style: TextStyle(
                            fontSize: _listFontSize,
                            color: note.color != null
                                ? darken(
                                    Color(int.tryParse(note.color!)!),
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
                          note.plainText!,
                          style: TextStyle(
                            fontSize: _listFontSize,
                            color: note.color != null
                                ? darken(Color(
                                    int.tryParse(note.color!)!,
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
          Row(
            children: [
              // Add to favourites
              GestureDetector(
                onTap: () {
                  // context.read<NoteCubit>().toggleFavourite(note.id);
                },
                child: Row(
                  children: [
                    Icon(Icons.star_outline,
                        size: 18,
                        color:
                            Color(int.tryParse(note.color!)!).withOpacity(.8)),
                    AppGaps.h5,
                    Text(
                      AppStrings.star,
                      style: TextStyle(
                        color:
                            Color(int.tryParse(note.color!)!).withOpacity(.8),
                      ),
                    ),
                  ],
                ),
              ),
              AppGaps.h10,
              // Listen
              playing && playingIndex == index
                  ? GestureDetector(
                      onTap: () {
                        ttsStop();
                        setState(() {
                          playing = false;
                        });
                      },
                      child: Row(
                        children: [
                          Icon(Icons.stop,
                              size: 18,
                              color: Color(int.tryParse(note.color!)!)
                                  .withOpacity(.8)),
                          AppGaps.h5,
                          Text(
                            AppStrings.listen,
                            style: TextStyle(
                              color: Color(int.tryParse(note.color!)!)
                                  .withOpacity(.8),
                            ),
                          ),
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        ttsSpeak(text: note.plainText!, context: context);
                        setState(() {
                          playing = true;
                          playingIndex = index;
                        });
                      },
                      child: Row(
                        children: [
                          Icon(Icons.play_arrow_outlined,
                              size: 18,
                              color: Color(int.tryParse(note.color!)!)
                                  .withOpacity(.8)),
                          AppGaps.h5,
                          Text(
                            AppStrings.listen,
                            style: TextStyle(
                              color: Color(int.tryParse(note.color!)!)
                                  .withOpacity(.8),
                            ),
                          ),
                        ],
                      ),
                    ),
              AppGaps.h10,
              // Add to voice notes
              GestureDetector(
                onTap: () {
                  // context.read<NoteCubit>().toggleFavourite(note.id);
                },
                child: Row(
                  children: [
                    Icon(Icons.add,
                        size: 18,
                        color:
                            Color(int.tryParse(note.color!)!).withOpacity(.8)),
                    AppGaps.h5,
                    Text(
                      AppStrings.addToVN,
                      style: TextStyle(
                        color:
                            Color(int.tryParse(note.color!)!).withOpacity(.8),
                      ),
                    ),
                  ],
                ),
              ),
              AppGaps.h10,
              // Edit
              GestureDetector(
                onTap: () {
                  context.pushNamed(RouteNames.editNote,
                      extra: state.notes[index]);
                },
                child: Row(
                  children: [
                    Icon(Icons.edit,
                        size: 18,
                        color:
                            Color(int.tryParse(note.color!)!).withOpacity(.8)),
                    AppGaps.h5,
                    Text(
                      AppStrings.edit,
                      style: TextStyle(
                        color:
                            Color(int.tryParse(note.color!)!).withOpacity(.8),
                      ),
                    ),
                  ],
                ),
              ),
              AppGaps.h10,
              // Delete
              GestureDetector(
                onTap: () {
                  appAlert(
                      context: context,
                      title: AppStrings.delete,
                      message: AppStrings.deleteDescription,
                      continue_: () {
                        context
                            .read<NoteCubit>()
                            .deleteNote(documentID: state.notes[index].id);
                        appSnackBar(
                            message: AppStrings.deleted, context: context);
                        setState(() {
                          context.read<NoteCubit>().getNotes(userID: userID);
                        });
                      });
                },
                child: Row(
                  children: [
                    Icon(Icons.delete,
                        size: 18,
                        color:
                            Color(int.tryParse(note.color!)!).withOpacity(.8)),
                    AppGaps.h5,
                    Text(
                      AppStrings.delete,
                      style: TextStyle(
                        color:
                            Color(int.tryParse(note.color!)!).withOpacity(.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
