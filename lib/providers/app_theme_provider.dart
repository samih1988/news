import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../sharedPreference/preferences_helper.dart';

class AppThemeProvider extends ChangeNotifier {
  // نقرأ القيمة المخزنة فوراً من الذاكرة بشكل مباشر وسريع جداً
  ThemeMode appThemeMode = PreferencesHelper.getTheme() == 'dark'
      ? ThemeMode.dark
      : ThemeMode.light;

  Future<void> changeAppThemeMode(ThemeMode newAppThemeMode) async {
    if (appThemeMode == newAppThemeMode) {
      return;
    }
    appThemeMode = newAppThemeMode;

    notifyListeners();
    PreferencesHelper.saveTheme(newAppThemeMode.name);
  }

  bool get isDark => appThemeMode == ThemeMode.dark;
}
