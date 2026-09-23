import 'package:flutter/material.dart';
import 'package:news/providers/app_theme_provider.dart';
import 'package:news/utils/app_utilz.dart';
import 'package:provider/provider.dart';

import '../../models/category_model.dart';
import '../../utils/app_styles.dart';
import 'widgets/category_item_widget.dart';

class CategoryFragment extends StatelessWidget {
  final Function(CategoryModel) onCategoryClick;

  const CategoryFragment({super.key, required this.onCategoryClick});

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    var categories = CategoryModel.getCategories();
    var themeProvider = Provider.of<AppThemeProvider>(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * .04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Good Morning Here is some news for you",
            style: themeProvider.isDark
                ? AppStyles.medium24white
                : AppStyles.medium24black,
          ),
          SizedBox(height: height * .02),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return CategoryItemWidget(
                  index: index,
                  onCategoryClick: onCategoryClick,
                );
              },
              separatorBuilder: (context, index) =>
                  SizedBox(height: height * .02),
            ),
          ),
        ],
      ),
    );
  }
}
