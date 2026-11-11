import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class MemoryCardsIllustration extends StatefulWidget {
  const MemoryCardsIllustration({super.key});

  @override
  State<MemoryCardsIllustration> createState() => _MemoryCardsIllustrationState();
}

class _MemoryCardsIllustrationState extends State<MemoryCardsIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final float1 = math.sin(_controller.value * math.pi) * 6;
        final float2 = math.cos(_controller.value * math.pi) * 4;
        return SizedBox(
          width: double.infinity,
          height: 260,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background card grid
              Positioned(
                child: Container(
                  width: 240,
                  height: 220,
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.translate(
                              offset: Offset(0, float1),
                              child: _GameCard(color: AppColors.primaryPurple, size: 72),
                            ),
                            const SizedBox(width: 12),
                            Transform.translate(
                              offset: Offset(0, float2),
                              child: _GameCard(color: AppColors.gold, size: 72),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.translate(
                              offset: Offset(0, float2),
                              child: _GameCard(color: AppColors.secondaryPurple, size: 72),
                            ),
                            const SizedBox(width: 12),
                            Transform.translate(
                              offset: Offset(0, float1),
                              child: _GameCard(
                                color: AppColors.cardBackground,
                                size: 72,
                                isFlipped: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GameCard extends StatelessWidget {
  final Color color;
  final double size;
  final bool isFlipped;

  const _GameCard({
    required this.color,
    required this.size,
    this.isFlipped = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isFlipped ? AppColors.secondaryBackground : color,
        borderRadius: BorderRadius.circular(size * 0.16),
        border: isFlipped ? Border.all(color: AppColors.inputBorder, width: 1) : null,
        boxShadow: isFlipped
            ? null
            : [BoxShadow(color: color.withValues(alpha: 0.25), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Center(
        child: isFlipped
            ? Icon(Icons.question_mark_rounded, color: AppColors.textTertiary, size: size * 0.35)
            : Transform.rotate(
                angle: 0.785,
                child: Container(
                  width: size * 0.28,
                  height: size * 0.28,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
      ),
    );
  }
}
