import 'package:flutter/material.dart';
import 'package:news/api/apiModel/apiSources/sources.dart';
import 'package:news/l10n/app_localizations.dart';
import 'package:news/ui/news/news_item.dart';
import 'package:news/ui/news/news_moadl_dialog.dart';
import 'package:news/viewModels/news_view_model.dart';
import 'package:news/widgets/app_pagination.dart';
import 'package:news/widgets/main_error.dart';
import 'package:news/widgets/main_loading.dart';
import 'package:provider/provider.dart';

class NewsDetailes extends StatefulWidget {
  final Source source;


  const NewsDetailes({super.key, required this.source});

  @override
  State<NewsDetailes> createState() => _NewsDetailesState();

}

class _NewsDetailesState extends State<NewsDetailes> {
  NewsViewModel newsViewModel = NewsViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newsViewModel.getNews(widget.source.id!, page: page, pageSize: pageSize);
  }
  int page = 1;
  static const int pageSize = 5;

  @override
  void didUpdateWidget(covariant NewsDetailes oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source.id != widget.source.id) {
      page = 1;
      newsViewModel.getNews(widget.source.id!, page: page, pageSize: pageSize);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: newsViewModel,
      child: Consumer<NewsViewModel>(
        builder: (context, newsModel, child) {
          if (newsModel.isLoading) {
            return MainLoading();
          } else if (newsModel.errorMessage != null) {
            return MainError(
              erroMessage: newsModel.errorMessage!,
              opressed: () {
                newsModel.getNews(
                    widget.source.id!, page: page, pageSize: pageSize);
              },
            );
          } else if (newsModel.newsList == null) {
            return MainLoading();
          } else if (newsModel.newsList!.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.no_data,
                style: Theme
                    .of(context)
                    .textTheme
                    .headlineMedium,
              ),
            );
          } else {
            var newsList = newsModel.newsList ?? [];
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: newsList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          NewsMoadlDialog.showFixedTextModal(
                            context,
                            news: newsList[index],
                          );
                        },
                        child: NewsCardWidget(news: newsList[index]),
                      );
                    },
                  ),
                ),
                AppPagination(
                  currentPage: page,
                  totalItems: newsModel.totalResults,
                  itemsPerPage: pageSize,
                  onPageChanged: (newPage) {
                    setState(() {
                      page = newPage;
                    });
                    newsViewModel.getNews(
                      widget.source.id!,
                      page: newPage,
                      pageSize: pageSize,
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

