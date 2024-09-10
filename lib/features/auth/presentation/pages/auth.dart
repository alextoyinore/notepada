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
              color: AppColors.primary,
              height: 50,
            ),
            AppGaps.v40,
            Image.asset(
              AppImages.onboard3,
              fit: BoxFit.cover,
            ),
            AppGaps.v40,
            Text(
              AppStrings.introTitle,
              style: AppStyles.headerStyle,
            ),
            // AppGaps.v10,
            const Text(
              AppStrings.introDescription,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.midGrey,
              ),
              textAlign: TextAlign.center,
            ),
            AppGaps.v20,
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppGaps.v40,
                  ElevatedButton(
                    onPressed: () {
                      context.goNamed(RouteNames.register);
                    },
                    child: const Text(AppStrings.register),
                  ),
                  AppGaps.v20,
                  ElevatedButton(
                    onPressed: () {
                      context.goNamed(RouteNames.login);
                    },
                    child: const Text(AppStrings.login),
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

