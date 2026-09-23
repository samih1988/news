import 'package:flutter/material.dart';

import '../../../models/category_model.dart';

class CategoryItemWidget extends StatelessWidget {
  final int index;

  final Function(CategoryModel) onCategoryClick;

  const CategoryItemWidget({
    super.key,
    required this.index,
    required this.onCategoryClick,
  });

  @override
  Widget build(BuildContext context) {
    var categories = CategoryModel.getCategories();
    return InkWell(
      onTap: () => onCategoryClick(categories[index]),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(categories[index].image, fit: BoxFit.cover),
      ),
    );
  }
}
