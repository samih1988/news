import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:news/api/apiModel/apiSources/source_response.dart';
import 'package:news/data/repository/sources/data_sources/local/source_local_data_source.dart';
import 'package:news/data/repository/sources/data_sources/remote/source_remote_data_source.dart';
import 'package:news/data/repository/sources/repository/source_repository.dart';

@Injectable(as: SourceRepository)
class SourceRepositoryImpl implements SourceRepository {
  SourceRemoteDataSource sourceRemoteDataSource;
  SourceLocalDataSource sourceLocalDataSource;

  SourceRepositoryImpl({
    required this.sourceRemoteDataSource,
    required this.sourceLocalDataSource,
  });

  @override
  Future<SourceResponse> getSource(String categoryId) async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity()
        .checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      // Mobile network available.
      var resp = await sourceRemoteDataSource.getSource(categoryId);
      sourceLocalDataSource.saveDataLocal(resp, categoryId);
      return resp;
    } else {
      var resp = await sourceLocalDataSource.getSourceByCategoryId(categoryId);
      if (resp != null) {
        return resp;
      } else {
        throw Exception("No internet connection and no cached sources found.");
      }
    }
  }
}
