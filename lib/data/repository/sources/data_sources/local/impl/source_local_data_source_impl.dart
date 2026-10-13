import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:news/api/apiModel/apiSources/source_response.dart';
import 'package:news/data/repository/sources/data_sources/local/source_local_data_source.dart';

@Injectable(as: SourceLocalDataSource)
class SourceLocalDataSourceImpl implements SourceLocalDataSource {
  @override
  Future<SourceResponse?> getSourceByCategoryId(String categoryId) async {
    var box = await Hive.openBox('sources');
    var data = box.get(categoryId);
    return data;
  }

  @override
  void saveDataLocal(SourceResponse sourceResponse, String catId) async {
    var box = await Hive.openBox('sources');
    await box.put(catId, sourceResponse);
  }
}
