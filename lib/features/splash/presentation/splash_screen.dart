import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/mw_logo.dart';
import '../../authentication/presentation/providers/auth_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _slideUp;
  late Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.4, curve: Curves.easeOut)),
    );

    _slideUp = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.4, curve: Curves.easeOut)),
    );

    _taglineFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 0.7, curve: Curves.easeOut)),
    );

    _controller.forward();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();
    final hasSession = await authProvider.checkSession();

    if (!mounted) return;

    if (hasSession) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      final prefs = await SharedPreferences.getInstance();
      final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
      if (!mounted) return;
      if (onboardingCompleted) {
        Navigator.of(context).pushReplacementNamed('/welcome');
      } else {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryBackground, Color(0xFF0F0D1A)],
          ),
        ),
        child: Stack(
          children: [
            // Purple glow
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: MediaQuery.of(context).size.width * 0.5 - 125,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primaryPurple.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Opacity(
                        opacity: _fadeIn.value,
                        child: Transform.translate(
                          offset: Offset(0, _slideUp.value),
                          child: const MwLogo(size: 72, showText: false),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Opacity(
                        opacity: _fadeIn.value,
                        child: Transform.translate(
                          offset: Offset(0, _slideUp.value),
                          child: Text(
                            AppStrings.appName.toUpperCase(),
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              letterSpacing: 3,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Opacity(
                        opacity: _taglineFade.value,
                        child: Text(
                          AppStrings.tagline,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
