import 'package:news/api/apiModel/apiNews/News_response.dart';

abstract class NewsRepository {
  Future<NewsResponse> getNews(
    String sourceIndex, {
    String? search,
    int page = 1,
    int pageSize = 10,
  });
}
