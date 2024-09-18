import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/config/assets/images.dart';
import 'package:notepada/config/assets/vectors.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/config/theme/colors.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            AppGaps.v40,
            SvgPicture.asset(
              AppVectors.icon,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcATop,
              ),
              height: 50,
            ),
            AppGaps.v40,
            Text(
              AppStrings.introTitle,
              style: AppStyles.headerStyle,
            ),
            // AppGaps.v10,
            Text(
              AppStrings.introDescription,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.midGrey
                    : AppColors.darkGrey,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            AppGaps.v40,
            Image.asset(
              AppImages.tree,
              height: 250,
              fit: BoxFit.cover,
            ),
            AppGaps.v20,
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppGaps.v30,
                  ElevatedButton(
                    onPressed: () {
                      context.pushNamed(RouteNames.register);
                    },
                    child: const Text(AppStrings.register),
                  ),
                  AppGaps.v10,
                  TextButton(
                    onPressed: () {
                      context.pushNamed(RouteNames.login);
                    },
                    child: const Text(
                      AppStrings.login,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
