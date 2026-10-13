import 'package:news/api/apiModel/apiSources/source_response.dart';

abstract class SourceLocalDataSource {
  Future<SourceResponse?> getSourceByCategoryId(String categoryId);

  void saveDataLocal(SourceResponse sourceResponse, String catId);
}
