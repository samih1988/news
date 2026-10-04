import 'package:flutter/material.dart';
import 'package:news/l10n/app_localizations.dart';
import 'package:news/utils/app_utilz.dart';

import '../../models/category_model.dart';
import 'widgets/category_item_widget.dart';

class CategoryFragment extends StatelessWidget {
  final Function(CategoryModel) onCategoryClick;

  const CategoryFragment({super.key, required this.onCategoryClick});

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    var categories = CategoryModel.getCategories();
    var localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * .04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              localizations.good_morning,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(height: 1.3),
            ),
          ),
          SizedBox(height: height * .01),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return CategoryItemWidget(
                  category: categories[index],
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