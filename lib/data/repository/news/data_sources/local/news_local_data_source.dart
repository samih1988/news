import 'package:news/api/apiModel/apiNews/News_response.dart';

abstract class NewsLocalDataSource {
  Future<NewsResponse?> getNewsBySourceId(String sourceId);

  void saveNewsLocal(NewsResponse newsResponse, String sourceId);
}
