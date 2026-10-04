import 'package:dio/dio.dart';
import 'package:news/api/apiModel/apiNews/News_response.dart';
import 'package:news/api/apiModel/apiSources/source_response.dart';
import 'package:news/api/api_constant.dart';
import 'package:news/api/api_end_point.dart';
import 'package:news/dio/dio_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioManager {
  static final dio =
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

  static Future<SourceResponse> getSource(String categoryId) async {
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

  static Future<NewsResponse> getNewsBySourceId(
    String sourceIndex, {
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      var response = await dio.get(
        ApiEndPoint.newsApi,
        queryParameters: {
          'page': page.toString(),
          'pageSize': pageSize.toString(),
          'sources': sourceIndex,
        },
      );

      return NewsResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
