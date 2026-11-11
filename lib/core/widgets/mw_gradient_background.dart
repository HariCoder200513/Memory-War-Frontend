import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class MwGradientBackground extends StatelessWidget {
  final Widget child;
  final bool showPurpleGlow;

  const MwGradientBackground({
    super.key,
    required this.child,
    this.showPurpleGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryBackground,
            Color(0xFF0F0D1A),
          ],
        ),
      ),
      child: showPurpleGlow
          ? Stack(
              children: [
                Positioned(
                  top: -80,
                  right: -80,
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.primaryPurple.withValues(alpha: 0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                child,
              ],
            )
          : child,
    );
  }
}
