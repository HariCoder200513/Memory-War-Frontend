import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class MwBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const MwBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.of(context).pop(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.chevron_left,
          color: AppColors.textPrimary,
          size: 24,
        ),
      ),
    );
  }
}
