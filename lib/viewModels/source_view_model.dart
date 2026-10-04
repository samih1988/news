import 'package:flutter/material.dart';
import 'package:news/api/apiModel/apiSources/sources.dart';
import 'package:news/dio/dio_interceptor.dart';
import 'package:news/dio/dio_manager.dart';

class SourceViewModel extends ChangeNotifier {
  List<Source>? sourceList;
  String? errorMessage;
  bool isLoading = false;

  void getSource(String categoryId) async {
    sourceList = null;
    errorMessage = null;
    isLoading = false;
    notifyListeners();
    try {
      isLoading = true;
      var response = await DioManager.getSource(categoryId);
      if (response.status == 'error') {
        isLoading = false;
        errorMessage = response.message;
      } else {
        isLoading = false;
        sourceList = response.sources;
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
