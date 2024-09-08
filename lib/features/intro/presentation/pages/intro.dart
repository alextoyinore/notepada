import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/config/strings/strings.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Intro Page'),
            TextButton(
              onPressed: () {
                context.goNamed(RouteNames.auth);
              },
              child: const Text(AppStrings.continue_),
            ),
          ],
        ),
      ),
    );
  }
}
