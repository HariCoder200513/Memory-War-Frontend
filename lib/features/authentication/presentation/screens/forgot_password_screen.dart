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

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  String? _emailError;
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    final email = _emailController.text.trim();
    return email.isNotEmpty && EmailValidator.validate(email);
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

  Future<void> _handleSendReset() async {
    final provider = context.read<AuthProvider>();
    final success = await provider.forgotPassword(email: _emailController.text.trim());
    if (success && mounted) {
      setState(() => _sent = true);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.md),
                const MwBackButton(),
                const SizedBox(height: AppSpacing.xl),
                if (_sent) ...[
                  // Success state
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.check_circle_outline, color: AppColors.success, size: 32),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Check your email',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    "If an account exists with that email, we've sent a link to reset your password.",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),
                  MwPrimaryButton(
                    text: AppStrings.backToLogin,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ] else ...[
                  Text(
                    AppStrings.resetYourPassword,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    AppStrings.resetPasswordDesc,
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
                    textInputAction: TextInputAction.done,
                    onChanged: _validateEmail,
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
                  const Spacer(),
                  MwPrimaryButton(
                    text: AppStrings.sendResetLink,
                    onPressed: _handleSendReset,
                    isLoading: authProvider.isLoading,
                    enabled: _isFormValid,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${AppStrings.rememberedIt} ',
                        style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushReplacementNamed('/login'),
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
                      const SizedBox(width: AppSpacing.md),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushReplacementNamed('/register'),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
