import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

class MwPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;

  const MwPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.buttonHeight,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (enabled && !isLoading) ? onPressed : null,
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.primaryBackground,
                ),
              )
            : Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

class MwOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;

  const MwOutlinedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.buttonHeight,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.textPrimary,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Text(text),
                ],
              ),
      ),
    );
  }
}
