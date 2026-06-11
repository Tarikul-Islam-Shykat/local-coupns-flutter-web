import 'dart:developer';
import 'package:dio/dio.dart';
import '../../storage/secure/storage.dart';

class AuthInterceptor extends Interceptor {
  final _storage = SecureStorageService();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final needsAuth = options.extra['auth'] == true;

    if (needsAuth) {
      final token = await _storage.get(SecureStorageService.token);
      log("AuthInterceptor: Sending Authorization: $token");

      if (token != null) {
        options.headers['Authorization'] = token;
      }
    }

    handler.next(options);
  }
}
