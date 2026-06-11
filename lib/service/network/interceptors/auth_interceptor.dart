import 'dart:developer';
import 'package:dio/dio.dart';
import '../../storage/local_storage/local_storage.dart';
import '../../storage/secure/storage.dart';

class AuthInterceptor extends Interceptor {
  final _storage = SecureStorageService();
  final _localService = LocalService();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final needsAuth = options.extra['auth'] == true;

    if (needsAuth) {
      final localToken = await _localService.getValue<String>(
        PreferenceKey.token,
      );
      final secureToken = await _storage.get(SecureStorageService.token);
      final token = localToken ?? secureToken;
      log("AuthInterceptor: token found? ${token != null}");

      if (token != null) {
        options.headers['Authorization'] = token.startsWith('Bearer ')
            ? token
            : 'Bearer $token';
      }
    }

    handler.next(options);
  }
}
