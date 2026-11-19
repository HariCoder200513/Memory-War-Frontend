import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/mw_logo.dart';
import '../../../profile_setup/data/avatar_data.dart';
import '../../../profile_setup/presentation/widgets/avatar_painter.dart';
import '../providers/auth_provider.dart';

class HomePlaceholderScreen extends StatefulWidget {
  const HomePlaceholderScreen({super.key});

  @override
  State<HomePlaceholderScreen> createState() => _HomePlaceholderScreenState();
}

class _HomePlaceholderScreenState extends State<HomePlaceholderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().refreshProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final avatar = avatarOptions.firstWhere(
      (a) => a.id == user?.avatar,
      orElse: () => avatarOptions.first,
    );
    final role = user?.role ?? 'player';
    final isReviewer = role == 'reviewer' || role == 'admin';
    final isCreator = role == 'creator' || role == 'admin';

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
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.construction_rounded,
                            color: AppColors.textTertiary, size: 48),
                        const SizedBox(height: AppSpacing.md),
                        const Text('Game arena coming soon',
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary)),
                        const SizedBox(height: 32),
                        if (isCreator) ...[
                          SizedBox(
                            width: double.infinity,
                            height: AppSpacing.buttonHeight,
                            child: ElevatedButton.icon(
                              onPressed: () => Navigator.of(context)
                                  .pushNamed('/creator/studio'),
                              icon:
                                  const Icon(Icons.brush_outlined, size: 20),
                              label: Text('Creator Studio',
                                  style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.gold,
                                foregroundColor: AppColors.primaryBackground,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppSpacing.borderRadiusSm)),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
                        if (isReviewer) ...[
                          SizedBox(height: isCreator ? 12 : 0),
                          SizedBox(
                            width: double.infinity,
                            height: AppSpacing.buttonHeight,
                            child: ElevatedButton.icon(
                              onPressed: () => Navigator.of(context)
                                  .pushNamed('/reviewer/dashboard'),
                              icon: const Icon(Icons.rate_review_outlined,
                                  size: 20),
                              label: Text('Review Dashboard',
                                  style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.success,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppSpacing.borderRadiusSm)),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
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
