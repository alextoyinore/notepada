import 'package:flutter/material.dart';
import 'package:notepada/common/helpers/helpers.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/features/note/data/models/note.dart';

Widget NoteListItem({
  required BuildContext context,
  required NoteModel note,
  required int index,
  required double listFontSize,
  required bool isFavourite,
  required int isFavouriteIndex,
  required bool playing,
  required int playingIndex,
  required VoidCallback play,
  required VoidCallback stop,
  required VoidCallback favourite,
  required VoidCallback addToVN,
  required VoidCallback edit,
  required VoidCallback delete,
  required VoidCallback view,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(
      vertical: 20,
      horizontal: 10,
    ),
    margin: const EdgeInsets.symmetric(vertical: 8),
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: .5,
          color: AppColors.primary.withOpacity(.3),
        ),
      ),
    ),
    child: GestureDetector(
      onTap: view,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            toHumanReadableDate(note.date.toString()),
            style: const TextStyle(
              color: AppColors.midGrey,
            ),
          ),
          AppGaps.v10,
          Text(
            note.title,
            style: AppStyles.noteListHeaderStyle.copyWith(
              fontSize: (listFontSize * 1.1),
            ),
          ),
          note.plainText! != ''
              ? note.plainText!.length >= 61
                  ? Column(
                      children: [
                        AppGaps.v10,
                        Text(
                          '${note.plainText!.substring(0, 60).replaceAll('\n', ' ')}...',
                          style: TextStyle(
                            fontSize: listFontSize,
                            color: AppColors.midGrey,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        AppGaps.v10,
                        Text(
                          note.plainText!.replaceAll('\n', ' '),
                          style: TextStyle(
                            fontSize: listFontSize,
                            color: AppColors.midGrey,
                          ),
                        ),
                      ],
                    )
              : const SizedBox(
                  width: 0,
                  height: 0,
                ),
          AppGaps.v20,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Add to favourites
              note.isFavourite!
                  ? GestureDetector(
                      onTap: favourite,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.star_outline,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          AppGaps.h5,
                          Text(
                            AppStrings.star,
                            style: TextStyle(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: favourite,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.star_outline,
                            size: 18,
                            color: AppColors.midGrey,
                          ),
                          AppGaps.h5,
                          Text(
                            AppStrings.star,
                            style: TextStyle(
                              color: AppColors.midGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
              AppGaps.h10,
              // Listen
              playing && playingIndex == index
                  ? GestureDetector(
                      onTap: stop,
                      child: const Row(
                        children: [
                          Icon(Icons.stop, size: 18, color: AppColors.primary),
                          AppGaps.h5,
                          Text(
                            AppStrings.listen,
                            style: TextStyle(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: play,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.play_arrow_outlined,
                            size: 18,
                            color: AppColors.midGrey,
                          ),
                          AppGaps.h5,
                          Text(
                            AppStrings.listen,
                            style: TextStyle(
                              color: AppColors.midGrey,
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
                child: const Row(
                  children: [
                    Icon(Icons.add, size: 18, color: AppColors.midGrey),
                    AppGaps.h5,
                    Text(
                      AppStrings.addToVN,
                      style: TextStyle(
                        color: AppColors.midGrey,
                      ),
                    ),
                  ],
                ),
              ),
              AppGaps.h10,
              // Edit
              GestureDetector(
                onTap: edit,
                child: const Row(
                  children: [
                    Icon(Icons.edit_outlined,
                        size: 18, color: AppColors.midGrey),
                    AppGaps.h5,
                    Text(
                      AppStrings.edit,
                      style: TextStyle(
                        color: AppColors.midGrey,
                      ),
                    ),
                  ],
                ),
              ),
              AppGaps.h10,
              // Delete
              GestureDetector(
                onTap: delete,
                child: const Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: AppColors.midGrey,
                    ),
                    AppGaps.h5,
                    Text(
                      AppStrings.delete,
                      style: TextStyle(
                        color: AppColors.midGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
