import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/config/assets/vectors.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/core/routes/names.dart';

PreferredSizeWidget appBar({
  String? title,
  required BuildContext context,
  required TextEditingController searchController,
}) {
  return AppBar(
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
        SizedBox(
          height: 42,
          width: MediaQuery.of(context).size.width * .65,
          child: SearchBar(
            controller: searchController,
            elevation: const WidgetStatePropertyAll(0),
            backgroundColor: WidgetStatePropertyAll(
              Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkGrey.withOpacity(.5)
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
                color: AppColors.midGrey,
              ),
            ),
          ),
        ),
      ],
    ),
    actions: [
      IconButton(
        onPressed: () {
          context.pushNamed(RouteNames.editNote);
        },
        icon: const Icon(
          Icons.add,
          color: AppColors.primary,
        ),
      )
    ],
  );
}
