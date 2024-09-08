import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class AppStyles {
  static TextStyle headerStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 35,
    // color: AppColors.darkGrey,
  );
  static TextStyle noteListHeaderStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    // color: AppColors.darkGrey,
  );

  // BORDERLESS TEXTFIELD THEMES

  static InputDecoration lightTextFieldThemeBorderless = const InputDecoration(
    filled: true,
    fillColor: Colors.transparent,
    contentPadding: EdgeInsets.all(20),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide.none,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide.none,
    ),
    border: UnderlineInputBorder(
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(
      color: AppColors.midGrey,
      fontWeight: FontWeight.w500,
    ),
  );

  static InputDecoration darkTextFieldThemeBorderless = const InputDecoration(
    filled: true,
    fillColor: Colors.transparent,
    contentPadding: EdgeInsets.all(20),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide.none,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide.none,
    ),
    border: UnderlineInputBorder(
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(
      color: AppColors.midGrey,
      fontWeight: FontWeight.w500,
    ),
  );

  // UNDERLINE TEXTFIELD THEMES

  static InputDecoration lightTextFieldTheme = const InputDecoration(
    filled: true,
    fillColor: Colors.transparent,
    contentPadding: EdgeInsets.all(20),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.midGrey,
        width: 1,
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.darkGrey, width: 1),
    ),
    border: UnderlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.midGrey,
        width: 1,
      ),
    ),
    hintStyle: TextStyle(
      color: AppColors.midGrey,
      fontWeight: FontWeight.w500,
    ),
  );

  static InputDecoration darkTextFieldTheme = const InputDecoration(
    filled: true,
    fillColor: Colors.transparent,
    contentPadding: const EdgeInsets.all(20),
    enabledBorder: UnderlineInputBorder(
      borderSide: const BorderSide(
        color: AppColors.midGrey,
        width: 1,
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: const BorderSide(color: AppColors.grey, width: 1),
    ),
    border: UnderlineInputBorder(
      borderSide: const BorderSide(
        color: AppColors.midGrey,
        width: 1,
      ),
    ),
    hintStyle: const TextStyle(
      color: AppColors.midGrey,
      fontWeight: FontWeight.w500,
    ),
  );


  // ROUNDED TEXTFIELD THEMES

  static InputDecoration lightTextFieldThemeRounded = InputDecoration(
    filled: true,
    fillColor: Colors.transparent,
    contentPadding: const EdgeInsets.all(20),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(
        color: AppColors.midGrey,
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.darkGrey, width: 1),
      borderRadius: BorderRadius.circular(30.0),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(
        color: AppColors.midGrey,
        width: 1,
      ),
    ),
    hintStyle: const TextStyle(
      color: AppColors.midGrey,
      fontWeight: FontWeight.w500,
    ),
  );

  static InputDecoration darkTextFieldThemeRounded = InputDecoration(
    filled: true,
    fillColor: Colors.transparent,
    contentPadding: const EdgeInsets.all(20),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(
        color: AppColors.midGrey,
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.grey, width: 1),
      borderRadius: BorderRadius.circular(30.0),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(
        color: AppColors.midGrey,
        width: 1,
      ),
    ),
    hintStyle: const TextStyle(
      color: AppColors.midGrey,
      fontWeight: FontWeight.w500,
    ),
  );
}

class AppGaps {
  static const v10 = SizedBox(height: 10);
  static const v20 = SizedBox(height: 20);
  static const v30 = SizedBox(height: 30);
  static const v40 = SizedBox(height: 40);
  static const v50 = SizedBox(height: 50);
}
