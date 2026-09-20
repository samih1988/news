import 'package:flutter/material.dart';

import '../sharedPreference/preferences_helper.dart';

class AppLanguageProvider extends ChangeNotifier {
  String appLanguage = PreferencesHelper.getLang();

  void changeAppLanguage(String newAppLanguage) {
    if (appLanguage == newAppLanguage) {
      return;
    }
    appLanguage = newAppLanguage;
    notifyListeners();
    PreferencesHelper.saveLang(newAppLanguage);
  }
}
