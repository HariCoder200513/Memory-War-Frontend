import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/mw_logo.dart';
import '../providers/auth_provider.dart';

class HomePlaceholderScreen extends StatelessWidget {
  const HomePlaceholderScreen({super.key});

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
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const MwLogo(size: 56),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  "You're in the arena",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Your profile is set. Time to\nput your memory to the test.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                  child: SizedBox(
                    width: double.infinity,
                    height: AppSpacing.buttonHeight,
                    child: ElevatedButton(
                      onPressed: () async {
                        final provider = context.read<AuthProvider>();
                        await provider.logout();
                        if (context.mounted) {
                          Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (_) => false);
                        }
                      },
                      child: Text(
                        'Sign out',
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
