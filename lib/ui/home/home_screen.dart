import 'package:flutter/material.dart';
import 'package:news/api/api_manager.dart';
import 'package:news/l10n/app_localizations.dart';
import 'package:news/models/category_model.dart';
import 'package:news/providers/search_provider.dart';
import 'package:news/ui/news/news_item.dart';
import 'package:news/widgets/custom_drawer.dart';
import 'package:news/widgets/custom_text_form_field.dart';
import 'package:news/widgets/main_error.dart';
import 'package:news/widgets/main_loading.dart';
import 'package:provider/provider.dart';

import '../category_details/category_details.dart';
import 'category_fragment.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CategoryModel? selectedCategory;
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var searchProvider = Provider.of<SearchProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomTextFormField(
            controller: searchController,
            borderColor: Theme
                .of(context)
                .splashColor,
            style: Theme
                .of(context)
                .textTheme
                .titleMedium,
            prefixIcon: Icon(
              Icons.search,
              size: 30,
              color: Theme
                  .of(context)
                  .splashColor,
            ),
            hinttext: AppLocalizations.of(context)!.search,
            hintstyle: Theme
                .of(context)
                .textTheme
                .titleMedium,
            onChanged: (val) {
              searchProvider.setSearchQuery(val);
            },
            sufixIcon: IconButton(
              onPressed: () {
                searchProvider.clearSearch();
                searchController.clear();
                setState(() {
                  isSearching = false;
                });
              },
              icon: Icon(
                Icons.close,
                color: Theme
                    .of(context)
                    .splashColor,
                size: 30,
              ),
            ),
          ),
        )
            : Text(
          selectedCategory == null
              ? (AppLocalizations
              .of(context)
              ?.home ?? "Home")
              : selectedCategory!.title,
        ),
        actions: isSearching
            ? null
            : [
          IconButton(
            onPressed: () {
              setState(() {
                isSearching = true;
              });
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      drawer: isSearching
          ? null
          : CustomDrawer(
        onGoToHomeClicked: onGoToHomeClicked,
      ),
      body: _buildBody(searchProvider.searchQuery),
    );
  }

  Widget _buildBody(String searchQuery) {
    if (selectedCategory != null) {
      return CategoryDetails(
        category: selectedCategory,
      );
    } else if (searchQuery
        .trim()
        .isNotEmpty) {
      return FutureBuilder(
        future: ApiManager.searchNews(searchQuery),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MainLoading();
          } else if (snapshot.hasError) {
            return MainError(
              erroMessage: snapshot.error.toString(),
              opressed: () {
                setState(() {});
              },
            );
          } else if (snapshot.data?.status != 'ok') {
            return MainError(
              erroMessage: snapshot.data?.message ?? "Error loading news",
              opressed: () {
                setState(() {});
              },
            );
          }
          var newsList = snapshot.data?.articles ?? [];
          return newsList.isEmpty
              ? Center(
            child: Text(
              "No News Found",
              style: Theme
                  .of(context)
                  .textTheme
                  .labelMedium,
            ),
          )
              : ListView.builder(
            itemBuilder: (context, index) {
              return NewsCardWidget(news: newsList[index]);
            },
            itemCount: newsList.length,
          );
        },
      );
    } else {
      return CategoryFragment(
        onCategoryClick: onCategoryClick,
      );
    }
  }

  void onCategoryClick(CategoryModel category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void onGoToHomeClicked() {
    var searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchProvider.clearSearch();
    searchController.clear();
    setState(() {
      selectedCategory = null;
      isSearching = false;
    });
  }
}

