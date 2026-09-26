import 'package:flutter/material.dart';
import 'package:news/api/apiModel/apiNews/News_response.dart';
import 'package:news/api/apiModel/apiSources/sources.dart';
import 'package:news/api/api_manager.dart';
import 'package:news/providers/search_provider.dart';
import 'package:news/ui/news/news_item.dart';
import 'package:news/ui/news/news_moadl_dialog.dart';
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
  int page = 1;
  static const int pageSize = 5;

  @override
  void didUpdateWidget(covariant NewsDetailes oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source.id != widget.source.id) {
      page = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    var searchProvider = Provider.of<SearchProvider>(context);

    return FutureBuilder<NewsResponse?>(
      future: ApiManager.getNewsBySourceId(
        widget.source.id ?? '',
        search: searchProvider.searchQuery,
        page: page,
        pageSize: pageSize,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MainLoading();
        } else if (snapshot.hasError) {
          return MainError(
            erroMessage: snapshot.error.toString(),
            opressed: () {
              setState(() {});
            },
          );
        } else {
          var newsList = snapshot.data?.articles ?? [];

          if (newsList.isEmpty) {
            return Center(
              child: Text(
                "No News Found",
                style: Theme.of(context).textTheme.labelMedium,
              ),
            );
          }

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
                totalItems: snapshot.data?.totalResults ?? 0,
                itemsPerPage: pageSize,
                onPageChanged: (newPage) {
                  setState(() {
                    page = newPage;
                  });
                },
              ),
            ],
          );
        }
      },
    );
  }
}

