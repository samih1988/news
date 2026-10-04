import 'package:flutter/material.dart';
import 'package:news/api/apiModel/apiNews/Articles.dart';
import 'package:news/dio/dio_interceptor.dart';
import 'package:news/dio/dio_manager.dart';

class NewsViewModel extends ChangeNotifier {
  List<Articles>? newsList;
  int totalResults = 0;
  String? errorMessage;
  bool isLoading = false;

  void getNews(String sourceIndex, {int page = 1, int pageSize = 10}) async {
    try {
      isLoading = true;
      notifyListeners();

      var response = await DioManager.getNewsBySourceId(
        sourceIndex,
        page: page,
        pageSize: pageSize,
      );

      if (response.status == 'error') {
        isLoading = false;
        errorMessage = response.message;
      } else {
        isLoading = false;
        newsList = response.articles;
        totalResults = response.totalResults?.toInt() ?? 0;
      }
    } catch (e) {
      isLoading = false;
      errorMessage = DioInterceptor.errorMessage.isNotEmpty
          ? DioInterceptor.errorMessage
          : e.toString();
    }
    notifyListeners();
  }
}
