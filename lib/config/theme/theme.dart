import 'package:notepada/config/theme/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    brightness: Brightness.light,
    fontFamily: 'Satoshi',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          enableFeedback: false,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.all(30),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColors.darkGrey, width: .4),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColors.darkGrey, width: .4),
      ),
      hintStyle: const TextStyle(
        color: AppColors.darkGrey,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  static final darkTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    brightness: Brightness.dark,
    fontFamily: 'Satoshi',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          enableFeedback: false,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.all(30),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColors.grey, width: .4),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColors.grey, width: .4),
      ),
      hintStyle: const TextStyle(
        color: AppColors.grey,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
