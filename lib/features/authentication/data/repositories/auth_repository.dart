import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/auth_models.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;
  final ApiClient _apiClient;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required AuthService authService,
    required ApiClient apiClient,
    GoogleSignIn? googleSignIn,
  })  : _authService = authService,
        _apiClient = apiClient,
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
              scopes: ['email'],
              serverClientId: AppConfig.googleClientId.isNotEmpty
                  ? AppConfig.googleClientId
                  : null,
            );

  Future<AuthResponse> register({required String email, required String password}) async {
    final response = await _authService.register(RegisterRequest(email: email, password: password));
    await _apiClient.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    return response;
  }

  Future<AuthResponse> login({required String email, required String password}) async {
    final response = await _authService.login(LoginRequest(email: email, password: password));
    await _apiClient.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    return response;
  }

  Future<AuthResponse> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw ApiException('Google sign-in was cancelled.');
    }
    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    if (idToken == null) {
      throw ApiException('Failed to get Google ID token.');
    }
    final response = await _authService.googleAuth(GoogleAuthRequest(idToken: idToken));
    await _apiClient.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    return response;
  }

  Future<void> forgotPassword({required String email}) async {
    await _authService.forgotPassword(ForgotPasswordRequest(email: email));
  }

  Future<void> resetPassword({required String token, required String password}) async {
    await _authService.resetPassword(ResetPasswordRequest(token: token, password: password));
  }

  Future<bool> checkEmailVerification() async {
    final response = await _authService.checkEmailVerification();
    return response.verified;
  }

  Future<void> resendVerificationEmail() async {
    await _authService.resendVerificationEmail();
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _authService.logout();
  }

  Future<bool> hasValidSession() => _apiClient.hasValidSession();
}
