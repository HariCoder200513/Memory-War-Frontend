import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/mw_logo.dart';
import '../providers/auth_provider.dart';
import '../widgets/google_sign_in_button.dart';
import '../widgets/memory_cards_illustration.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.lg),
                const MwLogo(size: 36),
                const Spacer(flex: 1),
                const MemoryCardsIllustration(),
                const Spacer(flex: 1),
                Text(
                  AppStrings.welcomeTitle,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  AppStrings.welcomeDesc,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                GoogleSignInButton(
                  onPressed: () => _handleGoogleSignIn(context),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  height: AppSpacing.buttonHeight,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).pushNamed('/register'),
                    icon: const Icon(Icons.email_outlined, size: 20),
                    label: Text(
                      AppStrings.continueWithEmail,
                      style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Already have account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.alreadyHaveAccount,
                      style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pushNamed('/login'),
                      style: TextButton.styleFrom(padding: const EdgeInsets.only(left: 4)),
                      child: Text(
                        AppStrings.logIn,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryPurple,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primaryPurple,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                // Terms
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        AppStrings.termsText,
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textTertiary),
                      ),
                      const SizedBox(width: 3),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          AppStrings.termsOfService,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.primaryPurple,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primaryPurple,
                          ),
                        ),
                      ),
                      Text(
                        ' and ',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textTertiary),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          AppStrings.privacyPolicy,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.primaryPurple,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primaryPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleGoogleSignIn(BuildContext context) async {
    final provider = context.read<AuthProvider>();
    final success = await provider.signInWithGoogle();
    if (success && context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
    }
  }
}
