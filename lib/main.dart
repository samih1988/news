import 'package:flutter/material.dart';
import 'package:news/providers/app_language_provider.dart';
import 'package:news/providers/app_theme_provider.dart';
import 'package:news/sharedPreference/preferences_helper.dart';
import 'package:news/ui/home/home_screen.dart';
import 'package:news/ui/splash/splash_screen.dart';
import 'package:news/utils/app_routes.dart';
import 'package:news/utils/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'l10n/app_localizations.dart';

void main() async {
  // خطوة إجبارية لضمان عمل SharedPreferences قبل تشغيل واجهات التطبيق
  // خطوة إجبارية لضمان عمل الـ SharedPreferences قبل تشغيل الواجهات
  WidgetsFlutterBinding.ensureInitialized();
  // إضافة اللغة العربية لحزمة timeago
  timeago.setLocaleMessages('ar', timeago.ArMessages());
  // تهيئة ملف الـ Helper وقراءة البيانات المخزنة فوراً في الذاكرة
  await PreferencesHelper.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppLanguageProvider()),
        ChangeNotifierProvider(create: (context) => AppThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<AppLanguageProvider>(context);
    var themeProvider = Provider.of<AppThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splashRouteName,
      routes: {
        AppRoutes.homeRouteName: (context) => HomeScreen(),
        AppRoutes.splashRouteName: (context) => SplashScreen(),
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(languageProvider.appLanguage),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.appThemeMode,
    );
  }
}
