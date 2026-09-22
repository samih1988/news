import 'package:flutter/material.dart';
import 'package:news/utils/app_colors.dart';

class MainLoading extends StatelessWidget {
  const MainLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: AppColors.grey));
  }
}
