import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class MwLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const MwLogo({
    super.key,
    this.size = 32,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _MemoryCardsIcon(size: size),
        if (showText) ...[
          const SizedBox(width: 10),
          Text(
            'MEMORY WARS',
            style: GoogleFonts.spaceGrotesk(
              fontSize: size * 0.45,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ],
    );
  }
}

class _MemoryCardsIcon extends StatelessWidget {
  final double size;

  const _MemoryCardsIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    final cardSize = size * 0.45;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: _MiniCard(size: cardSize, color: AppColors.primaryPurple),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: _MiniCard(size: cardSize, color: AppColors.secondaryPurple),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: _MiniCard(size: cardSize, color: AppColors.gold),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: _MiniCard(size: cardSize, color: AppColors.primaryPurple.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  final double size;
  final Color color;

  const _MiniCard({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size * 0.2),
      ),
      child: Center(
        child: Transform.rotate(
          angle: 0.785,
          child: Container(
            width: size * 0.3,
            height: size * 0.3,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}
