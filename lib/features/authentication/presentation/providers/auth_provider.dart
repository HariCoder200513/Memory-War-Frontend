import 'package:flutter/foundation.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../data/models/auth_models.dart';
import '../../data/repositories/auth_repository.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  AuthStatus _status = AuthStatus.initial;
  UserProfile? _user;
  String? _error;
  String? _registeredEmail;

  AuthProvider(this._repository);

  AuthStatus get status => _status;
  UserProfile? get user => _user;
  String? get error => _error;
  String? get registeredEmail => _registeredEmail;
  bool get isLoading => _status == AuthStatus.loading;

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<bool> checkSession() async {
    try {
      return await _repository.hasValidSession();
    } catch (_) {
      return false;
    }
  }

  Future<bool> register({required String email, required String password}) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    try {
      final response = await _repository.register(email: email, password: password);
      _user = response.user;
      _registeredEmail = email;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Something went wrong. Please try again.';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    try {
      final response = await _repository.login(email: email, password: password);
      _user = response.user;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Something went wrong. Please try again.';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    try {
      final response = await _repository.signInWithGoogle();
      _user = response.user;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Google sign-in failed. Please try again.';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> forgotPassword({required String email}) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    try {
      await _repository.forgotPassword(email: email);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Something went wrong. Please try again.';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetPassword({required String token, required String password}) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    try {
      await _repository.resetPassword(token: token, password: password);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Something went wrong. Please try again.';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> checkEmailVerification() async {
    try {
      return await _repository.checkEmailVerification();
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> resendVerificationEmail() async {
    try {
      await _repository.resendVerificationEmail();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
