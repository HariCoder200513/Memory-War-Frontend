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
import '../providers/auth_provider.dart';
import '../widgets/google_sign_in_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    return email.isNotEmpty && EmailValidator.validate(email) && password.isNotEmpty;
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
      _passwordError = null;
    });
  }

  Future<void> _handleLogin() async {
    final provider = context.read<AuthProvider>();
    final success = await provider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (success && mounted) {
      final user = provider.user;
      if (user != null && !user.emailVerified) {
        Navigator.of(context).pushReplacementNamed(
          '/verify-email',
          arguments: _emailController.text.trim(),
        );
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
      }
    }
  }

  void _handleGoogleSignIn() async {
    final provider = context.read<AuthProvider>();
    final success = await provider.signInWithGoogle();
    if (success && mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
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
                  AppStrings.welcomeBack,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                GoogleSignInButton(onPressed: _handleGoogleSignIn),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.divider)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Text(
                        AppStrings.orLogInWithEmail,
                        style: GoogleFonts.inter(fontSize: 13, color: AppColors.textTertiary),
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.divider)),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.passwordLabel,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed('/forgot-password'),
                      child: Text(
                        AppStrings.forgotPassword,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onChanged: _validatePassword,
                  style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Your password',
                    errorText: _passwordError,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: AppColors.textTertiary,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
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
                  text: AppStrings.logInButton,
                  onPressed: _handleLogin,
                  isLoading: authProvider.isLoading,
                  enabled: _isFormValid,
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.newToMemoryWars,
                      style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pushReplacementNamed('/register'),
                      style: TextButton.styleFrom(padding: const EdgeInsets.only(left: 4)),
                      child: Text(
                        AppStrings.signUp,
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
