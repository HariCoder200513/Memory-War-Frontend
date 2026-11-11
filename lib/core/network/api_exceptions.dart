import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  factory ApiException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException('Connection timed out. Please try again.');
      case DioExceptionType.connectionError:
        return ApiException('No internet connection.');
      case DioExceptionType.badResponse:
        final data = e.response?.data;
        final message = data is Map ? (data['message'] ?? data['error'] ?? 'Something went wrong') : 'Something went wrong';
        return ApiException(message.toString(), statusCode: e.response?.statusCode);
      default:
        return ApiException('Something went wrong. Please try again.');
    }
  }

  @override
  String toString() => message;
}
