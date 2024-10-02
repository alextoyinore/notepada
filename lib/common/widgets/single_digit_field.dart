import 'package:flutter/material.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/config/theme/styles.dart';

Widget singleDigitTextField(
    {required TextEditingController controller,
    required FocusNode focusNode,
    double? width,
    double? height,
    double? fontSize,
    VoidCallback? onChange,
    required BuildContext context}) {
  return Container(
    padding: const EdgeInsets.all(5),
    width: width ?? 80,
    height: height ?? 80,
    child: TextField(
      textInputAction: TextInputAction.next,
      controller: controller,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: fontSize ?? 25,
        fontWeight: FontWeight.w300,
      ),
      onChanged: (value) => onChange,
      decoration: AppStyles.lightTextFieldTheme.copyWith(
        counter: AppGaps.v0,
        contentPadding: const EdgeInsets.all(10),
        hintText: '',
        hintStyle: TextStyle(
          color: AppColors.grey,
          fontSize: fontSize ?? 25,
          fontWeight: FontWeight.w300,
        ),
        border: InputBorder.none,
      ),
      maxLength: 1,
      obscureText: true,
      textAlignVertical: TextAlignVertical.center,
    ),
  );
}
