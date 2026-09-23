import 'package:flutter/material.dart';
import 'package:news/l10n/app_localizations.dart';
import 'package:news/models/category_model.dart';
import 'package:news/widgets/custom_drawer.dart';

import '../category_details/category_details.dart';
import 'category_fragment.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CategoryModel? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedCategory == null
              ? (AppLocalizations
              .of(context)
              ?.home ?? "Home")
              : selectedCategory!.title,
        ),
      ),
      drawer: CustomDrawer(
        onGoToHomeClicked: onGoToHomeClicked,
      ),
      body: selectedCategory == null
          ? CategoryFragment(
        onCategoryClick: onCategoryClick,
      )
          : CategoryDetails(
        category: selectedCategory,
      ),
    );
  }

  void onCategoryClick(CategoryModel category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void onGoToHomeClicked() {
    setState(() {
      selectedCategory = null;
    });
  }
}
