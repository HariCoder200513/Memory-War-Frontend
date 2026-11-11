import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../onboarding_screen.dart';
import 'onboarding_illustration.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        children: [
          const Spacer(flex: 1),
          SizedBox(
            height: 280,
            child: OnboardingIllustration(type: data.illustrationType),
          ),
          const Spacer(flex: 1),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
