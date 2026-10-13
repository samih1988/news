import 'package:news/api/apiModel/apiSources/source_response.dart';

abstract class SourceRemoteDataSource {
  Future<SourceResponse> getSource(String categoryId);
}
