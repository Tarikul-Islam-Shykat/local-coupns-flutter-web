import 'package:dio/dio.dart';

class NetworkErrorHandler {
  static String getMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      case DioExceptionType.badResponse:
        return _fromResponse(e.response);
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  static String _fromResponse(Response? response) {
    if (response == null) return 'Server error';
    final code = response.statusCode ?? 0;
    final data = response.data;

    if (data is Map && data['message'] != null) return data['message'];
    if (code >= 500) return 'Server error. Try again later.';
    if (code == 401) return 'Unauthorized. Please login again.';
    if (code == 404) return 'Resource not found.';
    return 'Request failed. Try again.';
  }

  static void show(DioException e) {
    // AppSnackBar.error(getMessage(e));
  }
}
