import 'package:flutter/material.dart';
import 'package:news/l10n/app_localizations.dart';
import 'package:news/models/category_model.dart';
import 'package:news/providers/app_theme_provider.dart';
import 'package:news/utils/app_styles.dart';
import 'package:provider/provider.dart';

class CategoryItemWidget extends StatelessWidget {
  final CategoryModel category;
  final Function(CategoryModel) onCategoryClick;

  const CategoryItemWidget({
    super.key,
    required this.category,
    required this.onCategoryClick,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var themeProvider = Provider.of<AppThemeProvider>(context);
    bool isDark = themeProvider.isDark;
    var localizations = AppLocalizations.of(context)!;

    // استخدام AppTheme بالكامل من خلال Theme.of(context)
    Color cardBgColor = theme.primaryColor;
    Color circleBgColor = theme.splashColor;
    Color arrowIconColor = theme.primaryColor;
    Color pillBgColor = isDark
        ? const Color(0xFF383838)
        : const Color(0xFF6E6E73);

    return InkWell(
      onTap: () => onCategoryClick(category),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 200,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.08),
            width: 1,
          ),
          boxShadow: isDark
              ? null
              : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // خلفية الكارت (صورة القسم بحسب الثيم)
            Positioned.fill(
              child: Image.asset(
                category.getImage(isDark),
                fit: BoxFit.cover,
              ),
            ),

            // محتوى النص والزر:
            // عند ثبات مكان الرسمة (الصورة)، يوضع النص والزر بالتبادل (يمين / شمال) طبقاً للصورة Frame 1
            Directionality(
              textDirection: TextDirection.ltr,
              child: Align(
                alignment: category.isImageLeft
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.53,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 20.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.getTitle(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _buildViewAllButton(
                          title: localizations.view_all,
                          isContentOnRight: category.isImageLeft,
                          pillColor: pillBgColor,
                          circleColor: circleBgColor,
                          iconColor: arrowIconColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewAllButton({
    required String title,
    required bool isContentOnRight,
    required Color pillColor,
    required Color circleColor,
    required Color iconColor,
  }) {
    // الزر الكبسولة كما في Frame 1:
    // إذا كان المحتوى على اليمين: يكون السهم دائري على اليمين والكلمة على اليسار
    // إذا كان المحتوى على اليسار: يكون السهم دائري على اليسار والكلمة على اليمين
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: pillColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isContentOnRight) ...[
            const SizedBox(width: 14),
            Text(
              title,
              style: AppStyles.medium14bwhite.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: iconColor,
                size: 15,
              ),
            ),
          ] else
            ...[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: iconColor,
                  size: 15,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: AppStyles.medium14bwhite.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 14),
            ],
        ],
      ),
    );
  }
}