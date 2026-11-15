import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/mw_primary_button.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';

class ApplyCreatorScreen extends StatefulWidget {
  const ApplyCreatorScreen({super.key});

  @override
  State<ApplyCreatorScreen> createState() => _ApplyCreatorScreenState();
}

class _ApplyCreatorScreenState extends State<ApplyCreatorScreen> {
  final _controller = TextEditingController();
  bool _isSubmitting = false;

  bool get _isValid => _controller.text.trim().length >= 10;

  Future<void> _submit() async {
    if (!_isValid) return;
    setState(() => _isSubmitting = true);

    final provider = context.read<AuthProvider>();
    final success = await provider.applyForCreator(_controller.text.trim());

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushReplacementNamed('/creator/status');
    } else {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Failed to submit application'),
          backgroundColor: AppColors.error,
        ),
      );
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
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.md),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: AppColors.textPrimary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          'Apply for Creator\naccess',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Creators keep everything a Player can do, and also get:',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _buildPerk('Create and edit custom games'),
                        const SizedBox(height: AppSpacing.md),
                        _buildPerk('Preview games before submitting'),
                        const SizedBox(height: AppSpacing.md),
                        _buildPerk('Manage your published games'),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          'What would you like to create?',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextField(
                          controller: _controller,
                          maxLines: 5,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: AppColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Tell the admin about the games you have in mind.',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 15,
                              color: AppColors.textTertiary,
                            ),
                            filled: true,
                            fillColor: AppColors.cardBackground,
                            contentPadding: const EdgeInsets.all(16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
                              borderSide: const BorderSide(color: AppColors.inputBorder),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
                              borderSide: const BorderSide(color: AppColors.inputBorder),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
                              borderSide: const BorderSide(color: AppColors.primaryPurple, width: 2),
                            ),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          "Applications are reviewed by an admin. You'll be notified of the decision.",
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.textTertiary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        MwPrimaryButton(
                          text: 'Submit application',
                          onPressed: _submit,
                          isLoading: _isSubmitting,
                          enabled: _isValid,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPerk(String text) {
    return Row(
      children: [
        const Icon(Icons.check, color: AppColors.gold, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
