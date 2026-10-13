import 'package:news/api/apiModel/apiNews/Articles.dart';

abstract class NewsStateCubit {}

class NewsInitialState extends NewsStateCubit {}

class NewsLoadingState extends NewsStateCubit {}

class NewsErrorState extends NewsStateCubit {
  String errorMessage;

  NewsErrorState({required this.errorMessage});
}

class NewsSuccessState extends NewsStateCubit {
  List<Articles> newsList;
  int totalResults;

  NewsSuccessState({required this.newsList, required this.totalResults});
}
