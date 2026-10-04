import 'package:dio/dio.dart';

import '../api/api_constant.dart';

class DioInterceptor extends Interceptor {
  static String errorMessage = '';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: implement onRequest
    super.onRequest(options, handler);
    options.headers.addAll({"X-Api-Key": ApiConstant.apiKey});
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    // TODO: implement onResponse
    super.onResponse(response, handler);
  }

  // @override
  // void onError(DioException err, ErrorInterceptorHandler handler) {
  //   // 1. لو السيرفر رادد بـ Response (يعني السيرفر اشتغل ورجّع خطأ زي 400, 401, 404, 500)
  //   if (err.response != null) {
  //     dynamic data = err.response?.data;
  //
  //     // لو الـ API مجع JSON وفيه كلمة message أو statusMessage
  //     if (data is Map<String, dynamic>) {
  //       errorMessage = data['message'] ??
  //           data['statusMessage'] ??
  //           err.response?.statusMessage ??
  //           'Error ${err.response?.statusCode}';
  //     } else {
  //       // لو السيرفر مبعتش JSON، خذ نص الحالة الافتراضي بتاع الـ HTTP (زي Unauthorized أو Bad Request)
  //       errorMessage = err.response?.statusMessage ?? 'Error ${err.response?.statusCode}';
  //     }
  //   }
  //   // 2. لو المشكلة في الشبكة نفسها والطلب مأوصلش اصلاً للسيرفر
  //   else {
  //     errorMessage = err.message ?? 'Network connection error';
  //   }
  //
  //   super.onError(err, handler);
  // }
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final data = err.response?.data;

    if (data is Map) {
      // 1. لو السيرفر باعت JSON وفيه أي مفتاح للرسالة
      errorMessage =
          data['message'] ??
          data['statusMessage'] ??
          err.response?.statusMessage ??
          err.message ??
          'Unexpected error';
    } else {
      // 2. لو السيرفر مبعتش JSON (أو مفيش إنترنت)
      errorMessage =
          err.response?.statusMessage ?? err.message ?? 'Unexpected error';
    }
    super.onError(err, handler);
  }
}

// void onError(DioException err, ErrorInterceptorHandler handler) {
//   // 1. لو السيرفر رادد بحاجة وفيها رسالة (زي News API لما يرجع error)
//   if (err.response?.data != null && err.response?.data is Map<String, dynamic>) {
//     errorMessage = err.response?.data['message'] ?? 'حدث خطأ غير متوقع';
//   }
//   // 2. لو مفيش رد من السيرفر (مشكلة شبكة أو وقت)
//   else {
//     switch (err.type) {
//       case DioExceptionType.connectionTimeout:
//       case DioExceptionType.sendTimeout:
//       case DioExceptionType.receiveTimeout:
//         errorMessage = 'انتهت مهلة الاتصال، يرجى التأكد من شبكة الإنترنت.';
//         break;
//       case DioExceptionType.cancel:
//         errorMessage = 'تم إلغاء الطلب';
//         break;
//       default:
//         errorMessage = 'حدث خطأ في الاتصال بالسيرفر';
//     }
//   }
//
//   super.onError(err, handler);
// }
