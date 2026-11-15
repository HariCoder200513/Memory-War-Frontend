import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/mw_primary_button.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../data/avatar_data.dart';
import '../widgets/avatar_painter.dart';
import '../widgets/step_progress_bar.dart';

class PickAvatarScreen extends StatefulWidget {
  const PickAvatarScreen({super.key});

  @override
  State<PickAvatarScreen> createState() => _PickAvatarScreenState();
}

class _PickAvatarScreenState extends State<PickAvatarScreen> {
  int _selectedIndex = 0;
  bool _isSaving = false;

  AvatarOption get _selected => avatarOptions[_selectedIndex];

  Future<void> _continue() async {
    setState(() => _isSaving = true);
    final provider = context.read<AuthProvider>();
    final success = await provider.setAvatar(_selected.id);

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushNamed('/profile-setup/complete');
    } else {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Failed to set avatar'),
          backgroundColor: AppColors.error,
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
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      'Step 2 of 3',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.gold,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xl),
                    const Expanded(
                      child: StepProgressBar(currentStep: 2, totalSteps: 3),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Pick your\navatar',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'You can change it any time from your profile.',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: Column(
                    children: [
                      AvatarWidget(
                        avatar: _selected,
                        size: 120,
                        selected: false,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _selected.name,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemCount: avatarOptions.length,
                    itemBuilder: (context, index) {
                      final avatar = avatarOptions[index];
                      final isSelected = index == _selectedIndex;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: isSelected
                                ? Border.all(color: AppColors.gold, width: 2.5)
                                : null,
                          ),
                          padding: isSelected ? const EdgeInsets.all(2) : EdgeInsets.zero,
                          child: AvatarWidget(
                            avatar: avatar,
                            size: double.infinity,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                MwPrimaryButton(
                  text: 'Continue',
                  onPressed: _continue,
                  isLoading: _isSaving,
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
