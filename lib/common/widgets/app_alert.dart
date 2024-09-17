import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/config/theme/styles.dart';

Future<dynamic> appAlert(
    {required BuildContext context,
    required String title,
    required String message,
    String? extraButtonText,
    VoidCallback? extraButtonCallback,
    String? yesText,
    required VoidCallback continue_}) async {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkGrey
          : AppColors.bright,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),

      // Title
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Content
      content: Text(
        message,
        style: const TextStyle(fontSize: 18),
      ),
      actions: [
        // Cancel
        TextButton(
          onPressed: () => context.pop(false),
          child: const Text(
            AppStrings.cancel,
            style: TextStyle(fontSize: 18),
          ),
        ),

        // Continue
        TextButton(
          onPressed: () {
            continue_();
            context.pop(true);
          },
          child: Text(
            yesText ?? AppStrings.continue_,
            style: const TextStyle(fontSize: 18),
          ),
        ),

        // Extra Button
        extraButtonText != null
            ? TextButton(
                onPressed: () {
                  extraButtonCallback!();
                  context.pop(true);
                },
                child: Text(
                  extraButtonText,
                  style: const TextStyle(fontSize: 18),
                ),
              )
            : AppGaps.h10,
      ],
    ),
  );
}
