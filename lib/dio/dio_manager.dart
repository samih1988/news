import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:news/api/apiModel/apiNews/News_response.dart';
import 'package:news/api/apiModel/apiSources/source_response.dart';
import 'package:news/api/api_constant.dart';
import 'package:news/api/api_end_point.dart';
import 'package:news/dio/dio_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@singleton
class DioManager {
  final dio =
      Dio(
          BaseOptions(
            baseUrl: 'https://' + ApiConstant.baseUrl,

            // queryParameters: {
            //   "apiKey": ApiConstant.apiKey
            // },
          ),
        )
        ..interceptors.add(DioInterceptor())
        ..interceptors.add(
          PrettyDioLogger(
            requestBody: true,
            requestHeader: true,
            responseBody: true,
            responseHeader: true,
          ),
        );

  Future<SourceResponse> getSource(String categoryId) async {
    try {
      var response = await dio.get(
        ApiEndPoint.source,
        queryParameters: {"category": categoryId},
      );
      return SourceResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<NewsResponse> getNewsBySourceId(
    String sourceIndex, {
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };

      if (sourceIndex.isNotEmpty) {
        queryParameters['sources'] = sourceIndex;
      }

      if (search != null && search.trim().isNotEmpty) {
        queryParameters['q'] = search.trim();
      }

      var response = await dio.get(
        ApiEndPoint.newsApi,
        queryParameters: queryParameters,
      );

      return NewsResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
