import 'package:flutter/material.dart';
import 'package:notepada/config/theme/colors.dart';

void appSnackBar({required String message, required BuildContext context}) {
  var snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: AppColors.darkGrey,
    showCloseIcon: true,
    closeIconColor: AppColors.bright,
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
