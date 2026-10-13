import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:news/cubit/language/language_state_cubit.dart';
import 'package:news/cubit/language/language_view_model_cubit.dart';
import 'package:news/cubit/theme/theme_state_cubit.dart';
import 'package:news/cubit/theme/theme_view_model_cubit.dart';
import 'package:news/hiv/hive_registrar.g.dart';
import 'package:news/providers/search_provider.dart';
import 'package:news/sharedPreference/preferences_helper.dart';
import 'package:news/ui/home/home_screen.dart';
import 'package:news/ui/splash/splash_screen.dart';
import 'package:news/utils/app_routes.dart';
import 'package:news/utils/app_theme.dart';
import 'package:news/utils/my_bloc_observer.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'di_config/di_config.dart';
import 'l10n/app_localizations.dart';

void main() async {
  // خطوة إجبارية لضمان عمل SharedPreferences قبل تشغيل واجهات التطبيق
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  // إضافة اللغة العربية لحزمة timeago
  timeago.setLocaleMessages('ar', timeago.ArMessages());
  // تهيئة ملف الـ Helper وقراءة البيانات المخزنة فوراً في الذاكرة
  await PreferencesHelper.init();
  await Hive.initFlutter();
  Hive.registerAdapters();
  configureDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LanguageViewModelCubit()),
        BlocProvider(create: (context) => ThemeViewModelCubit()),
      ],
      child: ChangeNotifierProvider(
        create: (context) => SearchProvider(),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageViewModelCubit, LanguageStateCubit>(
      builder: (context, langState) {
        return BlocBuilder<ThemeViewModelCubit, ThemeStateCubit>(
          builder: (context, themeState) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: AppRoutes.splashRouteName,
              routes: {
                AppRoutes.homeRouteName: (context) => const HomeScreen(),
                AppRoutes.splashRouteName: (context) => const SplashScreen(),
              },
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: Locale(langState.languageCode),
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeState.themeMode,
            );
          },
        );
      },
    );
  }
}
