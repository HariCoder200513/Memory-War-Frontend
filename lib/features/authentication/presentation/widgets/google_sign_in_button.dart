import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const GoogleSignInButton({super.key, this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSpacing.buttonHeight,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.googleButtonBg,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.googleButtonText),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _GoogleIcon(),
                  const SizedBox(width: 10),
                  Text(
                    'Continue with Google',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.googleButtonText,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Blue
    final bluePaint = Paint()..color = const Color(0xFF4285F4);
    canvas.drawArc(Rect.fromLTWH(0, 0, w, h), -0.5, 1.8, true, bluePaint);

    // Green
    final greenPaint = Paint()..color = const Color(0xFF34A853);
    canvas.drawArc(Rect.fromLTWH(0, 0, w, h), 1.3, 1.3, true, greenPaint);

    // Yellow
    final yellowPaint = Paint()..color = const Color(0xFFFBBC05);
    canvas.drawArc(Rect.fromLTWH(0, 0, w, h), 2.6, 1.0, true, yellowPaint);

    // Red
    final redPaint = Paint()..color = const Color(0xFFEA4335);
    canvas.drawArc(Rect.fromLTWH(0, 0, w, h), -1.5, 1.0, true, redPaint);

    // White center
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(w * 0.5, h * 0.5), w * 0.28, whitePaint);

    // Blue right bar
    canvas.drawRect(
      Rect.fromLTWH(w * 0.5, h * 0.38, w * 0.5, h * 0.24),
      bluePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
