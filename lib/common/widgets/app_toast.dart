import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notepada/config/theme/colors.dart';

FToast fToast = FToast();

Widget appToast({required String message, required BuildContext context}) {
  fToast.init(context);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    decoration: BoxDecoration(
      color: AppColors.darkGrey.withOpacity(.8),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      message,
      style: const TextStyle(color: AppColors.bright),
      textAlign: TextAlign.center,
    ),
  );
}
