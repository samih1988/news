import 'package:injectable/injectable.dart';
import 'package:news/api/apiModel/apiSources/source_response.dart';
import 'package:news/data/repository/sources/data_sources/remote/source_remote_data_source.dart';
import 'package:news/dio/dio_manager.dart';

@Injectable(as: SourceRemoteDataSource)
class SourceRemoteDataSourceImpl implements SourceRemoteDataSource {
  DioManager dioManager;

  SourceRemoteDataSourceImpl({required this.dioManager});

  @override
  Future<SourceResponse> getSource(String categoryId) {
    // TODO: implement getSources
    return dioManager.getSource(categoryId);
  }
}
