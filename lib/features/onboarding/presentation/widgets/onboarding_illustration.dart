import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

enum OnboardingIllustrationType { memoryCards, compete, progress }

class OnboardingIllustration extends StatefulWidget {
  final OnboardingIllustrationType type;

  const OnboardingIllustration({super.key, required this.type});

  @override
  State<OnboardingIllustration> createState() => _OnboardingIllustrationState();
}

class _OnboardingIllustrationState extends State<OnboardingIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case OnboardingIllustrationType.memoryCards:
        return _MemoryCardsIllustration(animation: _controller);
      case OnboardingIllustrationType.compete:
        return _CompeteIllustration(animation: _controller);
      case OnboardingIllustrationType.progress:
        return _ProgressIllustration(animation: _controller);
    }
  }
}

class _MemoryCardsIllustration extends StatelessWidget {
  final Animation<double> animation;

  const _MemoryCardsIllustration({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final float = math.sin(animation.value * math.pi) * 8;
        return Center(
          child: Transform.translate(
            offset: Offset(0, float),
            child: SizedBox(
              width: 240,
              height: 240,
              child: Stack(
                children: [
                  Positioned(left: 10, top: 20, child: _FloatingCard(color: AppColors.primaryPurple, size: 80, rotation: -0.1)),
                  Positioned(right: 20, top: 10, child: _FloatingCard(color: AppColors.gold, size: 90, rotation: 0.08)),
                  Positioned(left: 40, bottom: 20, child: _FloatingCard(color: AppColors.secondaryPurple, size: 85, rotation: 0.15)),
                  Positioned(right: 10, bottom: 30, child: _FloatingCard(color: AppColors.gold.withValues(alpha: 0.8), size: 75, rotation: -0.12)),
                  Positioned(
                    left: 80,
                    top: 80,
                    child: _FloatingCard(color: AppColors.primaryPurple.withValues(alpha: 0.7), size: 70, rotation: 0.05),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CompeteIllustration extends StatelessWidget {
  final Animation<double> animation;

  const _CompeteIllustration({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final float = math.sin(animation.value * math.pi) * 6;
        return Center(
          child: Transform.translate(
            offset: Offset(0, float),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _PlayerAvatar(color: AppColors.primaryPurple, score: '1,250', label: 'You'),
                const SizedBox(width: 32),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'VS',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryBackground,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 32),
                _PlayerAvatar(color: AppColors.error.withValues(alpha: 0.8), score: '1,180', label: 'Rival'),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProgressIllustration extends StatelessWidget {
  final Animation<double> animation;

  const _ProgressIllustration({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final float = math.sin(animation.value * math.pi) * 6;
        return Center(
          child: Transform.translate(
            offset: Offset(0, float),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Trophy
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.gold, AppColors.gold.withValues(alpha: 0.7)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.emoji_events_rounded, size: 44, color: AppColors.primaryBackground),
                ),
                const SizedBox(height: 32),
                // Progress bars
                SizedBox(
                  width: 200,
                  child: Column(
                    children: [
                      _ProgressBar(label: 'Memory', progress: 0.85, color: AppColors.primaryPurple),
                      const SizedBox(height: 12),
                      _ProgressBar(label: 'Speed', progress: 0.65, color: AppColors.gold),
                      const SizedBox(height: 12),
                      _ProgressBar(label: 'Streak', progress: 0.92, color: AppColors.success),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FloatingCard extends StatelessWidget {
  final Color color;
  final double size;
  final double rotation;

  const _FloatingCard({required this.color, required this.size, required this.rotation});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(size * 0.18),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Transform.rotate(
            angle: 0.785,
            child: Container(
              width: size * 0.25,
              height: size * 0.25,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayerAvatar extends StatelessWidget {
  final Color color;
  final String score;
  final String label;

  const _PlayerAvatar({required this.color, required this.score, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4)),
            ],
          ),
          child: const Icon(Icons.person_rounded, size: 32, color: Colors.white),
        ),
        const SizedBox(height: 12),
        Text(
          score,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final String label;
  final double progress;
  final Color color;

  const _ProgressBar({required this.label, required this.progress, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            Text('${(progress * 100).round()}%', style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
