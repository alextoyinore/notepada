import 'package:flutter/material.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/features/note/data/models/note.dart';

Widget MiniNoteListItem({
  required BuildContext context,
  required NoteModel note,
  required int index,
  required double listFontSize,
  required VoidCallback view,
  Icon? icon,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(
      vertical: 10,
      // horizontal: 10,
    ),
    // margin: const EdgeInsets.symmetric(vertical: 8),
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: .5,
          color: AppColors.primary.withOpacity(.1),
        ),
      ),
    ),
    child: GestureDetector(
      onTap: view,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          icon ??
              const Icon(
                Icons.star_outline,
                color: AppColors.primary,
                size: 15,
              ),
          AppGaps.h10,
          Text(
            note.title,
            style: AppStyles.noteListHeaderStyle.copyWith(
              fontSize: (listFontSize * 1.1),
              fontWeight: FontWeight.w400,
            ),
            softWrap: true,
          ),
        ],
      ),
    ),
  );
}
