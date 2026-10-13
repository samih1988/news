import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/cubit/theme/theme_state_cubit.dart';
import 'package:news/sharedPreference/preferences_helper.dart';

class ThemeViewModelCubit extends Cubit<ThemeStateCubit> {
  ThemeViewModelCubit()
    : super(
        ThemeInitialState(
          themeMode: PreferencesHelper.getTheme() == 'dark'
              ? ThemeMode.dark
              : ThemeMode.light,
        ),
      );

  ThemeMode get currentTheme => state.themeMode;

  bool get isDark => state.themeMode == ThemeMode.dark;

  void changeAppThemeMode(ThemeMode newThemeMode) {
    if (state.themeMode == newThemeMode) return;
    PreferencesHelper.saveTheme(newThemeMode.name);
    emit(ThemeChangeState(themeMode: newThemeMode));
  }
}
