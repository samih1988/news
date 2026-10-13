import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:news/api/apiModel/apiNews/News_response.dart';
import 'package:news/data/repository/news/data_sources/local/news_local_data_source.dart';
import 'package:news/data/repository/news/data_sources/remote/news_remote_data_source.dart';
import 'package:news/data/repository/news/repository/news_repository.dart';

@Injectable(as: NewsRepository)
class NewsRepositoryImpl implements NewsRepository {
  NewsRemoteDataSource newsRemoteDataSource;
  NewsLocalDataSource newsLocalDataSource;

  NewsRepositoryImpl({
    required this.newsRemoteDataSource,
    required this.newsLocalDataSource,
  });

  @override
  Future<NewsResponse> getNews(
    String sourceIndex, {
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity()
        .checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      // Mobile network available.
      var resp = await newsRemoteDataSource.getNews(
        sourceIndex,
        search: search,
        page: page,
        pageSize: pageSize,
      );
      newsLocalDataSource.saveNewsLocal(resp, sourceIndex);
      return resp;
    } else {
      var resp = await newsLocalDataSource.getNewsBySourceId(sourceIndex);
      if (resp != null) {
        return resp;
      } else {
        throw Exception("No internet connection and no cached news found.");
      }
    }
  }
}
