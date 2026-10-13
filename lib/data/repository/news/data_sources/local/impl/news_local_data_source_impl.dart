import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:news/api/apiModel/apiNews/News_response.dart';
import 'package:news/data/repository/news/data_sources/local/news_local_data_source.dart';

@Injectable(as: NewsLocalDataSource)
class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  @override
  Future<NewsResponse?> getNewsBySourceId(String sourceId) async {
    var box = await Hive.openBox('news');
    var data = box.get(sourceId);
    return data;
  }

  @override
  void saveNewsLocal(NewsResponse newsResponse, String sourceId) async {
    var box = await Hive.openBox('news');
    await box.put(sourceId, newsResponse);
  }
}
