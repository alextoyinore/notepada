import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/config/assets/vectors.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/config/assets/images.dart';
import 'package:notepada/common/bloc/theme/theme_cubit.dart';

class Intro extends StatelessWidget {
  Intro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  AppImages.lady,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.black.withOpacity(.2),
          ),
          Positioned(
            top: 10,
            left: MediaQuery.of(context).size.width / 2.5,
            child: Container(
              width: MediaQuery.of(context).size.width * .2,
              height: MediaQuery.of(context).size.height * .2,
              child: SvgPicture.asset(
                AppVectors.icon,
                color: AppColors.bright,
                height: 50,
              ),
            ),
          ),
          Positioned(
            bottom: -500,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.themeSelectionTitle,
                    style: AppStyles.headerStyle.copyWith(
                      color: AppColors.bright,
                    ),
                  ),
                  // AppGaps.v10,
                  const Text(
                    AppStrings.themeSelectionDescription,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  AppGaps.v50,
                  _themeRow(context),
                  AppGaps.v20,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: ElevatedButton(
                      onPressed: () {
                        context.goNamed(RouteNames.auth);
                      },
                      child: const Text(AppStrings.continue_),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _themeRow(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 7.5,
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bright.withOpacity(.8),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _themeChooser(
              icon: Icons.sunny,
              label: AppStrings.light,
              isSelected: context.read<ThemeCubit>().state == ThemeMode.light
                  ? true
                  : false,
              onTap: () {
                context.read<ThemeCubit>().updateTheme(ThemeMode.light);
              }),
          _themeChooser(
              icon: Icons.nightlight,
              label: AppStrings.dark,
              isSelected: context.read<ThemeCubit>().state == ThemeMode.dark
                  ? true
                  : false,
              onTap: () {
                context.read<ThemeCubit>().updateTheme(ThemeMode.dark);
              }),
          _themeChooser(
            icon: Icons.computer,
            label: AppStrings.system,
            isSelected: context.read<ThemeCubit>().state == ThemeMode.system
                ? true
                : false,
            onTap: () {
              context.read<ThemeCubit>().updateTheme(ThemeMode.system);
            },
          ),
        ],
      ),
    );
  }

  Widget _themeChooser({
    Color color = AppColors.primary,
    required IconData icon,
    required String label,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected ? color : color.withOpacity(.02),
          border: Border.all(color: color),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.bright : color,
              size: 35,
            ),
            AppGaps.v10,
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.bright : color,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
