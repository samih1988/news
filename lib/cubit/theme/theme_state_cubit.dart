import 'package:flutter/material.dart';

abstract class ThemeStateCubit {
  ThemeMode themeMode;

  ThemeStateCubit({required this.themeMode});
}

class ThemeInitialState extends ThemeStateCubit {
  ThemeInitialState({required super.themeMode});
}

class ThemeChangeState extends ThemeStateCubit {
  ThemeChangeState({required super.themeMode});
}
