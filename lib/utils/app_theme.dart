import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_styles.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    appBarTheme: AppBarThemeData(
      centerTitle: true,
      backgroundColor: AppColors.transparentColor,
    ),
    scaffoldBackgroundColor: AppColors.white,

    // iconTheme: IconThemeData(color: AppColors.mainColor),
    // bottomNavigationBarTheme: BottomNavigationBarThemeData(
    //   backgroundColor: AppColors.white,
    //   selectedItemColor: AppColors.mainLightColor,
    //   unselectedItemColor: AppColors.lightGrey,
    //   selectedLabelStyle: AppStyles.reg12mainLightColor,
    //   unselectedLabelStyle: AppStyles.reg12GreyColor,
    // ),
    // floatingActionButtonTheme: FloatingActionButtonThemeData(
    //   backgroundColor: AppColors.mainColor,
    //   shape: StadiumBorder(),
    //   foregroundColor: AppColors.white,
    // ),
    textTheme: TextTheme(headlineLarge: AppStyles.semi20black),
  );
  static final ThemeData darkTheme = ThemeData(
    appBarTheme: AppBarThemeData(
      centerTitle: true,
      backgroundColor: AppColors.transparentColor,
    ),
    scaffoldBackgroundColor: AppColors.black,

    // iconTheme: IconThemeData(color: AppColors.white),
    // bottomNavigationBarTheme: BottomNavigationBarThemeData(
    //   backgroundColor: AppColors.mainDarkColor,
    //   selectedItemColor: AppColors.mainLightColor,
    //   unselectedItemColor: AppColors.lightGrey,
    //   selectedLabelStyle: AppStyles.reg12mainDarkColor,
    //   unselectedLabelStyle: AppStyles.reg12GreyColor,
    // ),
    // floatingActionButtonTheme: FloatingActionButtonThemeData(
    //   backgroundColor: AppColors.mainLightColor,
    //   shape: StadiumBorder(),
    //   foregroundColor: AppColors.white,
    // ),
    textTheme: TextTheme(headlineLarge: AppStyles.semi20black),
  );
}
