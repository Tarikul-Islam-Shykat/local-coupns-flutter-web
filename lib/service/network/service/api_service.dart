import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import '../error/network_error_handler.dart';
import '../instance/network_client.dart';

class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  final _dio = NetworkClient.instance.dio;

  Future<dynamic> get(
    String path, {
    bool auth = false,
    Map<String, dynamic>? queryParameters,
  }) => _request(
    () => _dio.get(
      path,
      queryParameters: queryParameters,
      options: Options(extra: {"auth": auth}),
    ),
  );

  Future<dynamic> post(String path, dynamic body, {bool auth = false}) =>
      _request(
        () => _dio.post(
          path,
          data: body,
          options: Options(extra: {"auth": auth}),
        ),
      );

  Future<dynamic> put(String path, dynamic body, {bool auth = false}) =>
      _request(
        () => _dio.put(
          path,
          data: body,
          options: Options(extra: {"auth": auth}),
        ),
      );

  Future<dynamic> patch(String path, dynamic body, {bool auth = false}) =>
      _request(
        () => _dio.patch(
          path,
          data: body,
          options: Options(extra: {"auth": auth}),
        ),
      );

  Future<dynamic> delete(String path, {bool auth = false}) => _request(
    () => _dio.delete(path, options: Options(extra: {"auth": auth})),
  );

  Future<dynamic> upload(
    String path, {
    required Map<String, dynamic> fields,
    List<File> files = const [],
    String fileField = 'image',
    String method = 'POST',
    bool auth = false,
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
        options: Options(method: method, extra: {"auth": auth}),
      ),
    );
  }

  Future<dynamic> uploadWithMap(
    String path, {
    required Map<String, dynamic> fields,
    Map<String, File> fileMap = const {},
    String method = 'POST',
    bool auth = false,
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
        options: Options(method: method, extra: {"auth": auth}),
      ),
    );
  }

  // ── Single error handling point ────────────────
  Future<dynamic> _request(Future<Response> Function() call) async {
    try {
      final response = await call();
      return response.data;
    } on DioException catch (e) {
      log('API ERROR: ${e.requestOptions.method} ${e.requestOptions.uri}');
      log('API ERROR MESSAGE: ${e.message ?? "unknown"}');
      log('API ERROR STATUS: ${e.response?.statusCode}');
      log('API ERROR DATA: ${e.response?.data}');
      NetworkErrorHandler.show(e);
      return null;
    }
  }
}
