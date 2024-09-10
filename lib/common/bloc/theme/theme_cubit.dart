import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:notepada/common/bloc/theme/theme_state.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void updateTheme(ThemeMode themeMode) => emit(themeMode);

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    return ThemeMode.values[json['theme'] as int];
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return {'theme': state.index};
  }
}


class ThemeCubit2 extends Cubit<ThemeState> {
  ThemeCubit2() : super(ThemeStateInitial(themeMode: ThemeMode.system));

  void updateTheme(ThemeMode themeMode) => emit(ThemeStateUpdate(themeMode: themeMode));
}

