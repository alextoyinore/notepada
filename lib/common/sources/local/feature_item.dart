import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/config/theme/styles.dart';

Widget appItem({
  required BuildContext context,
  required String routeName,
  required String title,
  String? svg,
  String? description,
  Color? color,
  IconData? icon,
}) {
  return GestureDetector(
    onTap: () {
      context.pushNamed(routeName);
    },
    child: Container(
      width: 80,
      height: 80,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color!.withOpacity(.25),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          svg != null
              ? SvgPicture.asset(
                  svg,
                  width: 35,
                  height: 35,
                  colorFilter: const ColorFilter.mode(
                    AppColors.darkGrey,
                    BlendMode.srcIn,
                  ),
                )
              : Icon(
                  icon,
                  size: 35,
                ),
          AppGaps.v10,
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              // color: AppColors.midGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    ),
  );
}
