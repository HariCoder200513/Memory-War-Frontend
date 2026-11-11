import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/mw_back_button.dart';
import '../../../../core/widgets/mw_text_field.dart';
import '../../../../core/widgets/mw_primary_button.dart';
import '../../../../core/widgets/password_strength_indicator.dart';
import '../providers/auth_provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String token;

  const ResetPasswordScreen({super.key, required this.token});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _passwordError;
  String? _confirmPasswordError;
  bool _success = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    return password.length >= 8 && password == confirmPassword;
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordError = null;
      } else if (value.length < 8) {
        _passwordError = AppStrings.passwordTooShort;
      } else {
        _passwordError = null;
      }
      if (_confirmPasswordController.text.isNotEmpty) {
        _confirmPasswordError = value != _confirmPasswordController.text
            ? AppStrings.passwordsDoNotMatch
            : null;
      }
    });
  }

  void _validateConfirmPassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _confirmPasswordError = null;
      } else if (value != _passwordController.text) {
        _confirmPasswordError = AppStrings.passwordsDoNotMatch;
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  Future<void> _handleReset() async {
    final provider = context.read<AuthProvider>();
    final success = await provider.resetPassword(
      token: widget.token,
      password: _passwordController.text,
    );
    if (success && mounted) {
      setState(() => _success = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

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
            child: _success ? _buildSuccessState() : _buildForm(authProvider),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        const Spacer(flex: 2),
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 44),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: Text(
            AppStrings.passwordResetSuccess,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Center(
          child: Text(
            AppStrings.passwordResetSuccessDesc,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
        const Spacer(flex: 3),
        MwPrimaryButton(
          text: AppStrings.backToLogin,
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _buildForm(AuthProvider authProvider) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),
          const MwBackButton(),
          const SizedBox(height: AppSpacing.xl),
          Text(
            AppStrings.setNewPassword,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppStrings.setNewPasswordDesc,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          MwTextField(
            controller: _passwordController,
            label: AppStrings.newPassword,
            hint: AppStrings.passwordHint,
            errorText: _passwordError,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
            onChanged: _validatePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppColors.textTertiary,
                size: 20,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          PasswordStrengthIndicator(password: _passwordController.text),
          const SizedBox(height: AppSpacing.lg),
          MwTextField(
            controller: _confirmPasswordController,
            label: AppStrings.confirmNewPassword,
            hint: AppStrings.confirmPasswordHint,
            errorText: _confirmPasswordError,
            obscureText: _obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            onChanged: _validateConfirmPassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppColors.textTertiary,
                size: 20,
              ),
              onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),
          ),
          if (authProvider.error != null) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.borderRadiusSm),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusXs),
                border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: AppColors.error, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      authProvider.error!,
                      style: GoogleFonts.inter(fontSize: 13, color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          MwPrimaryButton(
            text: AppStrings.resetPasswordButton,
            onPressed: _handleReset,
            isLoading: authProvider.isLoading,
            enabled: _isFormValid,
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
