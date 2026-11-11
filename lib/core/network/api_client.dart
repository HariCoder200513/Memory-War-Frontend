import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';

class ApiClient {
  late final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  ApiClient({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage() {
    final baseUrl = (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS)
        ? AppConfig.apiBaseUrlIos
        : AppConfig.apiBaseUrl;

    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: AppConfig.connectionTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(_AuthInterceptor(this));
  }

  Dio get dio => _dio;

  Future<String?> getAccessToken() => _secureStorage.read(key: _accessTokenKey);
  Future<String?> getRefreshToken() => _secureStorage.read(key: _refreshTokenKey);

  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    await _secureStorage.write(key: _accessTokenKey, value: accessToken);
    await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<void> clearTokens() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
  }

  Future<bool> hasValidSession() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}

class _AuthInterceptor extends Interceptor {
  final ApiClient _client;

  _AuthInterceptor(this._client);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _client.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await _client.getRefreshToken();
      if (refreshToken != null) {
        try {
          final response = await _client.dio.post(
            '/auth/refresh',
            data: {'refresh_token': refreshToken},
          );
          final newAccessToken = response.data['access_token'] as String;
          final newRefreshToken = response.data['refresh_token'] as String;
          await _client.saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
          );
          final retryOptions = err.requestOptions;
          retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';
          final retryResponse = await _client.dio.fetch(retryOptions);
          handler.resolve(retryResponse);
          return;
        } catch (_) {
          await _client.clearTokens();
        }
      }
    }
    handler.next(err);
  }
}
