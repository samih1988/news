import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/api/apiModel/apiSources/sources.dart';
import 'package:news/di/di.dart';
import 'package:news/di_config/di_config.dart';
import 'package:news/ui/news/cubit/news_state_cubit.dart';
import 'package:news/ui/news/cubit/news_view_model_cubit.dart';
import 'package:news/ui/news/news_item.dart';
import 'package:news/ui/news/news_moadl_dialog.dart';
import 'package:news/widgets/app_pagination.dart';
import 'package:news/widgets/main_error.dart';
import 'package:news/widgets/main_loading.dart';

class NewsDetailes extends StatefulWidget {
  final Source source;

  const NewsDetailes({super.key, required this.source});

  @override
  State<NewsDetailes> createState() => _NewsDetailesState();
}

class _NewsDetailesState extends State<NewsDetailes> {
  NewsViewModelCubit newsViewModelCubit = getIt<NewsViewModelCubit>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // newsViewModel.getNews(widget.source.id!, page: page, pageSize: pageSize);
    newsViewModelCubit.getNewsBySourceIndex(
        widget.source.id!, page: page, pageSize: pageSize);
  }

  int page = 1;
  static const int pageSize = 5;

  @override
  void didUpdateWidget(covariant NewsDetailes oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source.id != widget.source.id) {
      page = 1;
      newsViewModelCubit.getNewsBySourceIndex(
        widget.source.id!,
        page: page,
        pageSize: pageSize,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => newsViewModelCubit,
      child: BlocBuilder<NewsViewModelCubit, NewsStateCubit>(
        builder: (context, state) {
          if (state is NewsErrorState) {
            return MainError(
              erroMessage: state.errorMessage,
              opressed: () {
                newsViewModelCubit.getNewsBySourceIndex(
                  widget.source.id!,
                  page: page,
                  pageSize: pageSize,
                );
              },
            );
          } else if (state is NewsSuccessState) {
            var newsList = state.newsList;
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
                  totalItems: state.totalResults,
                  itemsPerPage: pageSize,
                  onPageChanged: (newPage) {
                    setState(() {
                      page = newPage;
                    });
                    newsViewModelCubit.getNewsBySourceIndex(
                      widget.source.id!,
                      page: newPage,
                      pageSize: pageSize,
                    );
                  },
                ),
              ],
            );
          } else {
            return MainLoading();
          }
        },
      ),
    );
  }
}
