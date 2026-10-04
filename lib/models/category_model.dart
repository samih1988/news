import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/app_assets.dart';

class CategoryModel {
  final String id;
  final String title;
  final String imageLight;
  final String imageDark;
  final bool isImageLeft;

  CategoryModel({
    required this.id,
    required this.title,
    required this.imageLight,
    required this.imageDark,
    required this.isImageLeft,
  });

  String getTitle(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    if (l10n == null) return title;
    switch (id) {
      case 'general':
        return l10n.general;
      case 'business':
        return l10n.business;
      case 'sports':
        return l10n.sports;
      case 'health':
        return l10n.health;
      case 'entertainment':
        return l10n.entertainment;
      case 'technology':
        return l10n.technology;
      case 'science':
        return l10n.science;
      default:
        return title;
    }
  }

  String getImage(bool isDark) => isDark ? imageDark : imageLight;

  static List<CategoryModel> getCategories() {
    return [
      CategoryModel(
        id: 'general',
        title: 'General',
        imageLight: AppAssets.generalLight,
        imageDark: AppAssets.generalDark,
        isImageLeft: true,
      ),
      CategoryModel(
        id: 'business',
        title: 'Business',
        imageLight: AppAssets.businessLight,
        imageDark: AppAssets.businessDark,
        isImageLeft: false,
      ),
      CategoryModel(
        id: 'sports',
        title: 'Sports',
        imageLight: AppAssets.sportLight,
        imageDark: AppAssets.sportDark,
        isImageLeft: true,
      ),
      CategoryModel(
        id: 'technology',
        title: 'Technology',
        imageLight: AppAssets.technologyLight,
        imageDark: AppAssets.technologyDark,
        isImageLeft: false,
      ),
      CategoryModel(
        id: 'entertainment',
        title: 'Entertainment',
        imageLight: AppAssets.entertainmentLight,
        imageDark: AppAssets.entertainmentDark,
        isImageLeft: true,
      ),
      CategoryModel(
        id: 'health',
        title: 'Health',
        imageLight: AppAssets.healthLight,
        imageDark: AppAssets.healthDark,
        isImageLeft: false,
      ),
      CategoryModel(
        id: 'science',
        title: 'Science',
        imageLight: AppAssets.scienceLight,
        imageDark: AppAssets.scienceDark,
        isImageLeft: true,
      ),
    ];
  }
}