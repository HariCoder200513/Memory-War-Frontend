import 'package:flutter/material.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/authentication/presentation/screens/welcome_screen.dart';
import '../../features/authentication/presentation/screens/register_screen.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/verify_email_screen.dart';
import '../../features/authentication/presentation/screens/forgot_password_screen.dart';
import '../../features/authentication/presentation/screens/reset_password_screen.dart';
import '../../features/authentication/presentation/screens/home_placeholder_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _fadeRoute(const SplashScreen(), settings);
      case '/onboarding':
        return _fadeRoute(const OnboardingScreen(), settings);
      case '/welcome':
        return _fadeRoute(const WelcomeScreen(), settings);
      case '/register':
        return _slideRoute(const RegisterScreen(), settings);
      case '/login':
        return _slideRoute(const LoginScreen(), settings);
      case '/verify-email':
        final email = settings.arguments as String? ?? '';
        return _slideRoute(VerifyEmailScreen(email: email), settings);
      case '/forgot-password':
        return _slideRoute(const ForgotPasswordScreen(), settings);
      case '/reset-password':
        final token = settings.arguments as String? ?? '';
        return _slideRoute(ResetPasswordScreen(token: token), settings);
      case '/home':
        return _fadeRoute(const HomePlaceholderScreen(), settings);
      default:
        return _fadeRoute(const SplashScreen(), settings);
    }
  }

  static PageRouteBuilder _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static PageRouteBuilder _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
