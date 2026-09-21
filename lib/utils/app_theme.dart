import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_styles.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.white,
    splashColor: AppColors.black,
    appBarTheme: AppBarThemeData(
      centerTitle: true,
      backgroundColor: AppColors.black,
    ),
    scaffoldBackgroundColor: AppColors.white,
    textTheme: TextTheme(
        labelLarge: AppStyles.bold16black,
        labelMedium: AppStyles.medium14black,
        labelSmall: AppStyles.medium12gray,
        headlineMedium: AppStyles.medium24black,
        headlineLarge: AppStyles.medium20black

    ),
  );
  static final ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.black,
    splashColor: AppColors.white,
    appBarTheme: AppBarThemeData(
      centerTitle: true,
      backgroundColor: AppColors.white,
    ),
    scaffoldBackgroundColor: AppColors.black,
    textTheme: TextTheme(
        labelLarge: AppStyles.bold16white,
        labelMedium: AppStyles.medium14bwhite,
        labelSmall: AppStyles.medium12gray,
        headlineMedium: AppStyles.medium24white,
        headlineLarge: AppStyles.medium20bwhite

    ),
  );
}
