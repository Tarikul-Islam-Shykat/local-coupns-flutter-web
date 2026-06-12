import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../global/issue_log_service.dart';
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
    final sendBearerToken = options.extra['sendBearerToken'] != false;

    if (needsAuth && sendBearerToken) {
      final localToken = await _localService.getValue<String>(
        PreferenceKey.token,
      );
      final secureToken = await _storage.get(SecureStorageService.token);
      final token = localToken ?? secureToken;
      final tokenSource = localToken != null
          ? 'Local storage'
          : secureToken != null
          ? 'Secure storage'
          : 'Missing';
      log("AuthInterceptor: token found? ${token != null}");

      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      await IssueLogService.instance.add(
        'Auth header prepared',
        details:
            '${options.method} ${options.uri}\n'
            'Token source: $tokenSource\n'
            'Token: ${_maskToken(token)}',
      );
    } else if (needsAuth) {
      log('AuthInterceptor: using cookie-based auth for ${options.uri}');
      await IssueLogService.instance.add(
        'Cookie auth request prepared',
        details:
            '${options.method} ${options.uri}\n'
            'Bearer token: not sent\n'
            'Reason: sendBearerToken=false',
      );
    }

    handler.next(options);
  }

  String _maskToken(String? token) {
    if (token == null || token.trim().isEmpty) {
      return 'Missing';
    }

    if (token.length <= 10) {
      return token;
    }

    return '${token.substring(0, 6)}...${token.substring(token.length - 4)}';
  }
}
