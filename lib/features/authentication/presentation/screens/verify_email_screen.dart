import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/mw_back_button.dart';
import '../../../../core/widgets/mw_primary_button.dart';
import '../providers/auth_provider.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({super.key, required this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _isChecking = false;
  bool _isResending = false;
  String? _error;

  String get _maskedEmail {
    final parts = widget.email.split('@');
    if (parts.length != 2 || parts[0].length < 2) return widget.email;
    final name = parts[0];
    final masked = '${name[0]}${'*' * (name.length - 2)}${name[name.length - 1]}';
    return '$masked@${parts[1]}';
  }

  Future<void> _checkVerification() async {
    setState(() {
      _isChecking = true;
      _error = null;
    });

    final provider = context.read<AuthProvider>();
    final verified = await provider.checkEmailVerification();

    if (!mounted) return;

    if (verified) {
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
    } else {
      setState(() {
        _isChecking = false;
        _error = 'Email not verified yet. Please check your inbox and click the verification link.';
      });
    }
  }

  Future<void> _resendEmail() async {
    setState(() {
      _isResending = true;
      _error = null;
    });

    final provider = context.read<AuthProvider>();
    await provider.resendVerificationEmail();

    if (mounted) {
      setState(() => _isResending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Verification email sent!',
            style: GoogleFonts.inter(color: AppColors.textPrimary),
          ),
          backgroundColor: AppColors.cardBackground,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.md),
                const MwBackButton(),
                const Spacer(flex: 2),
                // Email icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.email_outlined,
                    color: AppColors.gold,
                    size: 32,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  AppStrings.checkYourEmail,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(text: '${AppStrings.verifyEmailDesc}\n'),
                      TextSpan(
                        text: _maskedEmail,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.borderRadiusSm),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusXs),
                      border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      _error!,
                      style: GoogleFonts.inter(fontSize: 13, color: AppColors.error),
                    ),
                  ),
                ],
                const Spacer(flex: 3),
                MwPrimaryButton(
                  text: AppStrings.iVerifiedMyEmail,
                  onPressed: _checkVerification,
                  isLoading: _isChecking,
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  height: AppSpacing.buttonHeight,
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      AppStrings.openEmailApp,
                      style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _isResending ? null : _resendEmail,
                      child: Text(
                        AppStrings.resendEmail,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: _isResending ? AppColors.textTertiary : AppColors.primaryPurple,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushReplacementNamed('/register'),
                      child: Text(
                        AppStrings.wrongAddress,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
