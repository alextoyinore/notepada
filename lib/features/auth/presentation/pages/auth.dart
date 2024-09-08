import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/core/routes/routes.dart';


class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(AppStrings.auth),
              AppGaps.v20,
              ElevatedButton(
                onPressed: () {
                  context.goNamed(RouteNames.register);
                },
                child: const Text(AppStrings.register),
              ),
              AppGaps.v10,
              ElevatedButton(
                onPressed: () {
                  context.goNamed(RouteNames.login);
                },
                child: const Text(AppStrings.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
