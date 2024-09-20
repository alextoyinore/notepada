import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/config/assets/images.dart';
import 'package:notepada/common/bloc/theme/theme_cubit.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // AppGaps.v50,
          // SvgPicture.asset(
          //   AppVectors.icon,
          //   colorFilter: const ColorFilter.mode(
          //     AppColors.primary,
          //     BlendMode.srcATop,
          //   ),
          //   height: 50,
          // ),
          // AppGaps.v20,
          Image.asset(
            AppImages.box,
            height: 200,
            fit: BoxFit.cover,
          ),
          AppGaps.v50,
          Text(
            AppStrings.welcome,
            style: AppStyles.headerStyle.copyWith(
                // color: AppColors.darkGrey,
                ),
          ),
          AppGaps.v10,
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              AppStrings.welcomeDescription,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.midGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          AppGaps.v20,
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
    );
  }

  Widget _themeRow(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 7.5,
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        // color: AppColors.bright.withOpacity(.9),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _themeChooser(
              icon: Icons.wb_sunny,
              label: AppStrings.light,
              isSelected: context.read<ThemeCubit>().state == ThemeMode.light
                  ? true
                  : false,
              onTap: () {
                setState(() {
                  context.read<ThemeCubit>().updateTheme(ThemeMode.light);
                });
              }),
          _themeChooser(
              icon: Icons.nightlight,
              label: AppStrings.dark,
              isSelected: context.read<ThemeCubit>().state == ThemeMode.dark
                  ? true
                  : false,
              onTap: () {
                setState(() {
                  context.read<ThemeCubit>().updateTheme(ThemeMode.dark);
                });
              }),
          _themeChooser(
            icon: Icons.brightness_6,
            label: AppStrings.system,
            isSelected: context.read<ThemeCubit>().state == ThemeMode.system
                ? true
                : false,
            onTap: () {
              setState(() {
                context.read<ThemeCubit>().updateTheme(ThemeMode.system);
              });
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
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(20),
          color: isSelected ? color : color.withOpacity(.02),
          border: Border.all(color: color),
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.bright : color,
              size: 25,
            ),
            // AppGaps.v10,
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
