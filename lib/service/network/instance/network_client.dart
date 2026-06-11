import 'package:dio/dio.dart';
import '../endpoints/endpoints.dart';
import '../interceptors/auth_interceptor.dart';
import '../interceptors/logging_interceptor.dart';

class NetworkClient {
  NetworkClient._();
  static final NetworkClient instance = NetworkClient._();

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: Urls.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
      validateStatus: (status) {
        return status! < 500;
      },
    ),
  )..interceptors.addAll([AuthInterceptor(), LoggingInterceptor()]);
}
