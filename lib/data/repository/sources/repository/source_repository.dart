import 'package:news/api/apiModel/apiSources/source_response.dart';

abstract class SourceRepository {
  Future<SourceResponse> getSource(String categoryId);
}
