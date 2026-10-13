import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:news/data/repository/news/data_sources/remote/impl/news_remote_data_source_impl.dart';
import 'package:news/data/repository/news/data_sources/remote/news_remote_data_source.dart';
import 'package:news/data/repository/news/repository/impl/news_repository_impl.dart';
import 'package:news/data/repository/news/repository/news_repository.dart';
import 'package:news/dio/dio_manager.dart';
import 'package:news/ui/news/cubit/news_state_cubit.dart';

@injectable
class NewsViewModelCubit extends Cubit<NewsStateCubit> {
  NewsRepository newsRepository;

  NewsViewModelCubit({required this.newsRepository})
    : super(NewsLoadingState());
  int totalResults = 0;

  void getNewsBySourceIndex(
    String sourceIndex, {
    int page = 1,
    int pageSize = 5,
    String? search,
  }) async {
    try {
      emit(NewsLoadingState());
      var response = await newsRepository.getNews(
        sourceIndex,
        page: page,
        pageSize: pageSize,
        search: search,
      );
      if (response.status == 'error') {
        emit(NewsErrorState(errorMessage: response.message!));
      } else {
        totalResults = response.totalResults?.toInt() ?? 0;
        emit(
          NewsSuccessState(
            newsList: response.articles ?? [],
            totalResults: totalResults,
          ),
        );
      }
    } catch (e) {
      emit(NewsErrorState(errorMessage: e.toString()));
    }
  }

  void searchNews(String query, {int page = 1, int pageSize = 10}) async {
    if (query.trim().isEmpty) return;
    try {
      emit(NewsLoadingState());
      var response = await newsRepository.getNews(
        '',
        search: query,
        page: page,
        pageSize: pageSize,
      );
      if (response.status == 'error') {
        emit(NewsErrorState(errorMessage: response.message ?? 'Unknown error'));
      } else {
        totalResults = response.totalResults?.toInt() ?? 0;
        emit(
          NewsSuccessState(
            newsList: response.articles ?? [],
            totalResults: totalResults,
          ),
        );
      }
    } catch (e) {
      emit(NewsErrorState(errorMessage: e.toString()));
    }
  }
}
