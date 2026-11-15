import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/mw_logo.dart';
import '../../../profile_setup/data/avatar_data.dart';
import '../../../profile_setup/presentation/widgets/avatar_painter.dart';
import '../providers/auth_provider.dart';

class HomePlaceholderScreen extends StatelessWidget {
  const HomePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final avatar = avatarOptions.firstWhere(
      (a) => a.id == user?.avatar,
      orElse: () => avatarOptions.first,
    );

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
          child: Column(
            children: [
              // Top bar with profile avatar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: AppSpacing.md,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const MwLogo(size: 32),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed('/profile'),
                      child: AvatarWidget(avatar: avatar, size: 36),
                    ),
                  ],
                ),
              ),
              // Main content
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.construction_rounded,
                        color: AppColors.textTertiary,
                        size: 48,
                      ),
                      SizedBox(height: AppSpacing.md),
                      Text(
                        'Game arena coming soon',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
