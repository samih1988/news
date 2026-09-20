import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static late SharedPreferences _prefs;

  // دالة التهيئة (مرة واحدة في الـ main)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ================= 1. إعدادات الثيم =================
  static const String _themeKey = "APP_THEME_MODE";

  static Future<void> saveTheme(String themeMode) async {
    await _prefs.setString(_themeKey, themeMode);
  }

  static String getTheme() {
    return _prefs.getString(_themeKey) ?? "light";
  }

  // ================= 2. إعدادات اللغه =================
  static const String _langKey = "APP_lang_MODE";

  static Future<void> saveLang(String language) async {
    await _prefs.setString(_langKey, language);
  }

  static String getLang() {
    return _prefs.getString(_langKey) ?? "en";
  }
}
