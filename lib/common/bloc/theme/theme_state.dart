import 'package:flutter/material.dart';

abstract class ThemeState {}

class ThemeStateInitial extends ThemeState{
  final ThemeMode themeMode;
  ThemeStateInitial({required this.themeMode});
}

class ThemeStateUpdate extends ThemeState {
  final ThemeMode themeMode;
  ThemeStateUpdate({required this.themeMode});
}

