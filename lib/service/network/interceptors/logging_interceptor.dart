import 'dart:developer';
import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('┌────── Request ──────');
    log('│ [${options.method}] ${options.uri}');
    log('│ Headers: ${options.headers}');
    if (options.data != null) log('│ Body: ${options.data}');
    log('└─────────────────────');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('┌────── Response ──────');
    log('│ [${response.statusCode}] ${response.requestOptions.uri}');
    log('│ Data: ${response.data}');
    log('└──────────────────────');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('┌────── Error ──────');
    log('│ [${err.response?.statusCode}] ${err.requestOptions.uri}');
    log('│ Message: ${err.message}');
    log('│ Error Data: ${err.response?.data}');
    log('└───────────────────');
    handler.next(err);
  }
}
