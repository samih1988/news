import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/app_language_provider.dart';
import '../providers/app_theme_provider.dart';
import '../providers/search_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class CustomDrawer extends StatefulWidget {
  final VoidCallback? onGoToHomeClicked;

  const CustomDrawer({super.key, this.onGoToHomeClicked});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<AppThemeProvider>(context);
    var languageProvider = Provider.of<AppLanguageProvider>(context);
    var localizations = AppLocalizations.of(context)!;
    bool isDark = themeProvider.isDark;

    return Drawer(
      backgroundColor: isDark ? AppColors.black : AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Title Part (Header)
          Container(
            height: 160,
            color: isDark ? AppColors.white : AppColors.black,
            alignment: Alignment.center,
            child: Text(
              "News App",
              style: isDark ? AppStyles.medium24black : AppStyles.medium24white,
            ),
          ),
          const SizedBox(height: 16),

          // 2. Go to Home Part
          ListTile(
            leading: Icon(
              Icons.home_outlined,
              color: isDark ? AppColors.white : AppColors.black,
              size: 28,
            ),
            title: Text(
              localizations.home,
              style: isDark ? AppStyles.bold16white : AppStyles.bold16black,
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer
              if (widget.onGoToHomeClicked != null) {
                widget.onGoToHomeClicked!();
              }
            },
          ),
          Divider(
            color: AppColors.grey.withValues(alpha: 0.4),
            indent: 16,
            endIndent: 16,
          ),
          const SizedBox(height: 12),

          // 3. Theme Part
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.palette_outlined,
                      color: isDark ? AppColors.white : AppColors.black,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      localizations.theme,
                      style: isDark
                          ? AppStyles.bold16white
                          : AppStyles.bold16black,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.white : AppColors.black,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<ThemeMode>(
                      value: themeProvider.appThemeMode,
                      isExpanded: true,
                      dropdownColor: isDark ? AppColors.black : AppColors.white,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: isDark ? AppColors.white : AppColors.black,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: ThemeMode.light,
                          child: Text(
                            localizations.light,
                            style: isDark
                                ? AppStyles.medium14bwhite
                                : AppStyles.medium14black,
                          ),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.dark,
                          child: Text(
                            localizations.dark,
                            style: isDark
                                ? AppStyles.medium14bwhite
                                : AppStyles.medium14black,
                          ),
                        ),
                      ],
                      onChanged: (newThemeMode) {
                        if (newThemeMode != null) {
                          themeProvider.changeAppThemeMode(newThemeMode);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 4. Language Part
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.language_outlined,
                      color: isDark ? AppColors.white : AppColors.black,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      localizations.language,
                      style: isDark
                          ? AppStyles.bold16white
                          : AppStyles.bold16black,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.white : AppColors.black,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: languageProvider.appLanguage,
                      isExpanded: true,
                      dropdownColor: isDark ? AppColors.black : AppColors.white,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: isDark ? AppColors.white : AppColors.black,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'en',
                          child: Text(
                            localizations.english,
                            style: isDark
                                ? AppStyles.medium14bwhite
                                : AppStyles.medium14black,
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'ar',
                          child: Text(
                            localizations.arabic,
                            style: isDark
                                ? AppStyles.medium14bwhite
                                : AppStyles.medium14black,
                          ),
                        ),
                      ],
                      onChanged: (newLang) {
                        if (newLang != null) {
                          languageProvider.changeAppLanguage(newLang);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
