import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/auth_models.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _apiClient.dio.post('/auth/register', data: request.toJson());
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _apiClient.dio.post('/auth/login', data: request.toJson());
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<AuthResponse> googleAuth(GoogleAuthRequest request) async {
    try {
      final response = await _apiClient.dio.post('/auth/google', data: request.toJson());
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> forgotPassword(ForgotPasswordRequest request) async {
    try {
      await _apiClient.dio.post('/auth/forgot-password', data: request.toJson());
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> resetPassword(ResetPasswordRequest request) async {
    try {
      await _apiClient.dio.post('/auth/reset-password', data: request.toJson());
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<VerifyEmailResponse> checkEmailVerification() async {
    try {
      final response = await _apiClient.dio.get('/auth/verify-email/status');
      return VerifyEmailResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> resendVerificationEmail() async {
    try {
      await _apiClient.dio.post('/auth/verify-email/resend');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.dio.post('/auth/logout');
    } on DioException catch (_) {
      // Ignore logout errors — clear tokens regardless
    } finally {
      await _apiClient.clearTokens();
    }
  }
}
