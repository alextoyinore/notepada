import 'package:flutter/material.dart';
import 'package:notepada/config/theme/colors.dart';

Widget appPinInput({
  required TextEditingController controller,
  required int length,
  required BuildContext context,
  double fontSize = 35,
  double stretch = 50,
}) {
  return TextField(
    controller: controller,
    autofocus: true,
    maxLength: length,
    keyboardType: TextInputType.number,
    cursorColor: Colors.transparent,
    style: TextStyle(
      fontSize: fontSize,
      letterSpacing: stretch,
    ),
    textAlign: TextAlign.center,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.zero,
      hintText: '0000',
      hintStyle: TextStyle(
        fontSize: fontSize,
        letterSpacing: stretch,
        color: AppColors.grey,
      ),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      counterText: '',
    ),
  );
}
