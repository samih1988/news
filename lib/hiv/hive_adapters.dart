import 'package:hive_ce/hive_ce.dart';
import 'package:news/api/apiModel/apiNews/Articles.dart';
import 'package:news/api/apiModel/apiSources/source_response.dart';
import 'package:news/api/apiModel/apiSources/sources.dart';

import '../api/apiModel/apiNews/News_response.dart';

@GenerateAdapters([
  AdapterSpec<SourceResponse>(),
  AdapterSpec<Source>(),
  AdapterSpec<NewsResponse>(),
  AdapterSpec<Articles>(),
])
part 'hive_adapters.g.dart';
