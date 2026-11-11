import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/mw_back_button.dart';
import '../../../../core/widgets/mw_text_field.dart';
import '../../../../core/widgets/mw_primary_button.dart';
import '../../../../core/widgets/password_strength_indicator.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    return email.isNotEmpty &&
        EmailValidator.validate(email) &&
        password.length >= 8 &&
        password == confirmPassword;
  }

  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _emailError = null;
      } else if (!EmailValidator.validate(value)) {
        _emailError = AppStrings.emailInvalid;
      } else {
        _emailError = null;
      }
    });
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

  Future<void> _handleRegister() async {
    final provider = context.read<AuthProvider>();
    final success = await provider.register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (success && mounted) {
      Navigator.of(context).pushReplacementNamed(
        '/verify-email',
        arguments: _emailController.text.trim(),
      );
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.md),
                const MwBackButton(),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  AppStrings.createAccount,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  AppStrings.createAccountDesc,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                MwTextField(
                  controller: _emailController,
                  label: AppStrings.emailLabel,
                  hint: AppStrings.emailHint,
                  errorText: _emailError,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onChanged: _validateEmail,
                ),
                const SizedBox(height: AppSpacing.lg),
                MwTextField(
                  controller: _passwordController,
                  label: AppStrings.passwordLabel,
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
                  label: AppStrings.confirmPasswordLabel,
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
                  text: AppStrings.createAccountButton,
                  onPressed: _handleRegister,
                  isLoading: authProvider.isLoading,
                  enabled: _isFormValid,
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.alreadyHaveAccount,
                      style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
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
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
