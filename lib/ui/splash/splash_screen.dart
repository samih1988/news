import 'dart:async';

import 'package:flutter/material.dart';
import 'package:news/ui/home/home_screen.dart';
import 'package:news/utils/app_assets.dart';
import 'package:news/utils/app_colors.dart';
import 'package:provider/provider.dart';

import '../../providers/app_theme_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // الانتقال بعد ثانيتين (2 seconds)
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // استخدام الامتدادات (Extensions) بحذر أو الاعتماد على MediaQuery مباشرة لضمان التجاوب
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var themeProvider = Provider.of<AppThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.isDark ? AppColors.black : AppColors.white,
      // يمكنك تغيير لون الخلفية بحسب الثيم
      body: SafeArea(
        child: Column(
          children: [
            // مساحة مرنة علوية لضبط موضع الشعار في المنتصف
            const Spacer(flex: 3),

            // الصورة التي في المنتصف (زيادة النسبة لتبدو أوضح)
            Center(
              child: Image.asset(
                !themeProvider.isDark
                    ? AppAssets.splashWhite
                    : AppAssets.splashDark,
                width: width * 0.65,
                // جعل الشعار يأخذ 65% من عرض الشاشة ليكون واضحاً
                fit: BoxFit.contain, // يضمن عدم تشوه الصورة
              ),
            ),

            // مساحة مرنة تدفع البراند لأسفل الشاشة بشكل متناسق
            const Spacer(flex: 3),

            // صورة البراند في الأسفل (تعديل النسبة لظهورها بشكل ممتاز)
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.04),
              child: Image.asset(
                !themeProvider.isDark
                    ? AppAssets.splashBrandWhite
                    : AppAssets.splashBrandDark,
                width: width * 0.35,
                // جعل البراند يأخذ 35% من العرض ليصبح مرئياً ومتجاوباً
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
