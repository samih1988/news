import 'dart:convert';
import 'package:http/http.dart' as http;
import 'apiModel/apiSources/source_response.dart';
import 'api_constant.dart';
import 'api_end_point.dart';

class ApiManager {
  static Future<SourceResponse> getSource(String categoryId) async {
    try {
      Uri url = Uri.https(ApiConstant.baseUrl, ApiEndPoint.source, {
        "apiKey": ApiConstant.apiKey,
        "category": categoryId,
      });
      var response = await http.get(url);
      return SourceResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }
}
