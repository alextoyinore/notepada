import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/common/bloc/settings/settings_cubit.dart';
import 'package:notepada/config/assets/images.dart';
import 'package:notepada/config/assets/vectors.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/core/util/storage/storage_keys.dart';
import 'package:notepada/core/util/storage/storage_service.dart';
import 'package:notepada/features/note/data/models/note.dart';
import 'package:notepada/features/note/presentation/bloc/note_cubit.dart';
import 'package:notepada/features/note/presentation/bloc/note_state.dart';
import 'package:notepada/features/note/presentation/widgets/mini_note_list_item.dart';
import 'package:shimmer/shimmer.dart';

class FavouriteNotes extends StatefulWidget {
  const FavouriteNotes({super.key});

  @override
  State<FavouriteNotes> createState() => _FavouriteNotesState();
}

class _FavouriteNotesState extends State<FavouriteNotes> {
  late List<NoteModel> favouriteNotes;
  late double _listFontSize;
  final _storageService = StorageService();
  late String userID;
  bool playing = false;
  int playingIndex = -1;
  bool isFavourite = false;
  int favouriteIndex = -1;

  @override
  void initState() {
    super.initState();
    userID = _storageService.getValue(StorageKeys.userID);
    _listFontSize = context.read<NoteListFontCubit>().state.toDouble();
    context.read<NoteCubit>().getFavouriteNotes(
          isSecret: false,
          userID: userID,
          isFavourite: true,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteCubit, NoteState>(
      builder: (context, state) {
        if (state is NoteFetchLoading) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ListView.builder(
              itemBuilder: (_, __) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 30.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                ],
              ),
              itemCount: 5,
            ),
          );
        }

        if (state is NoteFetchError) {
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              setState(() {
                context.read<NoteCubit>().getFavouriteNotes(
                    userID: userID, isSecret: false, isFavourite: true);
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
                        context.read<NoteCubit>().getFavouriteNotes(
                            userID: userID, isSecret: false, isFavourite: true);
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
                  context.read<NoteCubit>().getFavouriteNotes(
                      userID: userID, isSecret: false, isFavourite: true);
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImages.empty,
                    height: 100,
                  ),
                  AppGaps.v10,
                  const Text(
                    AppStrings.noNotes,
                    style: TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<NoteCubit>().getFavouriteNotes(
                          userID: userID, isSecret: false, isFavourite: true);
                    },
                    child: const Text(AppStrings.refresh),
                  ),
                ],
              ),
            );
          } else {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                setState(() {
                  context.read<NoteCubit>().getFavouriteNotes(
                      userID: userID, isSecret: false, isFavourite: true);
                });
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  return MiniNoteListItem(
                    view: () => context.pushNamed(
                      RouteNames.viewNote,
                      extra: state.notes[index],
                    ),
                    context: context,
                    note: state.notes[index],
                    index: index,
                    listFontSize: _listFontSize,
                  );
                },
                itemCount: state.notes.length,
              ),
            );
          }
        }
        return const SizedBox();
      },
    );
  }
}
