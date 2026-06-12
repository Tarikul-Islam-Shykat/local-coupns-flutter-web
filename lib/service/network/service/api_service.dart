import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../global/issue_log_service.dart';
import '../error/network_error_handler.dart';
import '../instance/network_client.dart';

class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  final _dio = NetworkClient.instance.dio;

  Future<dynamic> get(
    String path, {
    bool auth = false,
    bool sendBearerToken = true,
    Map<String, dynamic>? queryParameters,
  }) => _request(
    () => _dio.get(
      path,
      queryParameters: queryParameters,
      options: Options(
        extra: {"auth": auth, "sendBearerToken": sendBearerToken},
      ),
    ),
  );

  Future<dynamic> post(
    String path,
    dynamic body, {
    bool auth = false,
    bool sendBearerToken = true,
  }) => _request(
    () => _dio.post(
      path,
      data: body,
      options: Options(
        extra: {"auth": auth, "sendBearerToken": sendBearerToken},
      ),
    ),
  );

  Future<dynamic> put(
    String path,
    dynamic body, {
    bool auth = false,
    bool sendBearerToken = true,
  }) => _request(
    () => _dio.put(
      path,
      data: body,
      options: Options(
        extra: {"auth": auth, "sendBearerToken": sendBearerToken},
      ),
    ),
  );

  Future<dynamic> patch(
    String path,
    dynamic body, {
    bool auth = false,
    bool sendBearerToken = true,
  }) => _request(
    () => _dio.patch(
      path,
      data: body,
      options: Options(
        extra: {"auth": auth, "sendBearerToken": sendBearerToken},
      ),
    ),
  );

  Future<dynamic> delete(
    String path, {
    bool auth = false,
    bool sendBearerToken = true,
  }) => _request(
    () => _dio.delete(
      path,
      options: Options(
        extra: {"auth": auth, "sendBearerToken": sendBearerToken},
      ),
    ),
  );

  Future<dynamic> upload(
    String path, {
    required Map<String, dynamic> fields,
    List<File> files = const [],
    String fileField = 'image',
    String method = 'POST',
    bool auth = false,
    bool sendBearerToken = true,
  }) async {
    final formData = FormData.fromMap({
      ...fields,
      if (files.isNotEmpty)
        fileField: await Future.wait(
          files.map(
            (f) => MultipartFile.fromFile(
              f.path,
              filename: f.path.split('/').last,
            ),
          ),
        ),
    });
    return _request(
      () => _dio.request(
        path,
        data: formData,
        options: Options(
          method: method,
          extra: {"auth": auth, "sendBearerToken": sendBearerToken},
        ),
      ),
    );
  }

  Future<dynamic> uploadWithMap(
    String path, {
    required Map<String, dynamic> fields,
    Map<String, File> fileMap = const {},
    String method = 'POST',
    bool auth = false,
    bool sendBearerToken = true,
  }) async {
    final Map<String, MultipartFile> multipartFiles = {};
    for (final entry in fileMap.entries) {
      multipartFiles[entry.key] = await MultipartFile.fromFile(
        entry.value.path,
        filename: entry.value.path.split('/').last,
      );
    }

    // ✅ Boolean fix: convert bool → "true"/"false" string
    final Map<String, dynamic> sanitizedFields = {};
    fields.forEach((key, value) {
      if (value == true || value == false) {
        sanitizedFields[key] = value.toString(); // "true" or "false"
      } else {
        sanitizedFields[key] = value;
      }
    });

    log('Sanitized fields: $sanitizedFields');

    final formData = FormData.fromMap({...sanitizedFields, ...multipartFiles});

    return _request(
      () => _dio.request(
        path,
        data: formData,
        options: Options(
          method: method,
          extra: {"auth": auth, "sendBearerToken": sendBearerToken},
        ),
      ),
    );
  }

  // ── Single error handling point ────────────────
  Future<dynamic> _request(Future<Response> Function() call) async {
    try {
      final response = await call();
      await IssueLogService.instance.add(
        'API request completed',
        details: _buildSuccessDetails(response),
      );
      return response.data;
    } on DioException catch (e) {
      log('API ERROR: ${e.requestOptions.method} ${e.requestOptions.uri}');
      log('API ERROR MESSAGE: ${e.message ?? "unknown"}');
      log('API ERROR STATUS: ${e.response?.statusCode}');
      log('API ERROR DATA: ${e.response?.data}');
      await IssueLogService.instance.add(
        'API request failed',
        level: 'error',
        details: _buildErrorDetails(e),
      );
      NetworkErrorHandler.show(e);
      return null;
    }
  }

  String _buildSuccessDetails(Response response) {
    final request = response.requestOptions;
    return [
      '${request.method} ${request.uri}',
      'Status: ${response.statusCode}',
      'Auth mode: ${_authMode(request)}',
      'Token: ${_maskedAuthorization(request.headers['Authorization'])}',
      'Query: ${_stringifyValue(request.queryParameters)}',
      'Request body: ${_stringifyValue(request.data)}',
      'Response body: ${_stringifyValue(response.data)}',
    ].join('\n');
  }

  String _buildErrorDetails(DioException error) {
    final request = error.requestOptions;
    return [
      '${request.method} ${request.uri}',
      'Message: ${error.message ?? "unknown"}',
      'Status: ${error.response?.statusCode}',
      'Auth mode: ${_authMode(request)}',
      'Token: ${_maskedAuthorization(request.headers['Authorization'])}',
      'Query: ${_stringifyValue(request.queryParameters)}',
      'Request body: ${_stringifyValue(request.data)}',
      'Response body: ${_stringifyValue(error.response?.data)}',
    ].join('\n');
  }

  String _authMode(RequestOptions request) {
    final needsAuth = request.extra['auth'] == true;
    if (!needsAuth) {
      return 'No auth';
    }
    return request.extra['sendBearerToken'] == false
        ? 'Cookie auth'
        : 'Bearer auth';
  }

  String _maskedAuthorization(dynamic headerValue) {
    final value = headerValue?.toString().trim();
    if (value == null || value.isEmpty) {
      return 'Not sent';
    }

    const bearerPrefix = 'Bearer ';
    final token = value.startsWith(bearerPrefix)
        ? value.substring(bearerPrefix.length)
        : value;

    if (token.length <= 10) {
      return token;
    }

    return '${token.substring(0, 6)}...${token.substring(token.length - 4)}';
  }

  String _stringifyValue(dynamic value) {
    if (value == null) {
      return 'null';
    }
    if (value is FormData) {
      return 'FormData(fields: ${value.fields.length}, files: ${value.files.length})';
    }
    final text = value.toString();
    if (text.isEmpty) {
      return '(empty)';
    }
    return text;
  }
}
