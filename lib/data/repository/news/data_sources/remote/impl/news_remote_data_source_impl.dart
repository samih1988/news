import 'package:injectable/injectable.dart';
import 'package:news/api/apiModel/apiNews/News_response.dart';
import 'package:news/data/repository/news/data_sources/remote/news_remote_data_source.dart';
import 'package:news/dio/dio_manager.dart';

@Injectable(as: NewsRemoteDataSource)
class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  DioManager dioManager;

  NewsRemoteDataSourceImpl({required this.dioManager});

  @override
  Future<NewsResponse> getNews(
    String sourceIndex, {
    String? search,
    int page = 1,
    int pageSize = 10,
  }) {
    return dioManager.getNewsBySourceId(
      sourceIndex,
      search: search,
      page: page,
      pageSize: pageSize,
    );
  }
}
