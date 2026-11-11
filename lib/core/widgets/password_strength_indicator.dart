import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final strength = _calculateStrength(password);
    if (password.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: List.generate(4, (index) {
            return Expanded(
              child: Container(
                height: 3,
                margin: EdgeInsets.only(right: index < 3 ? 4 : 0),
                decoration: BoxDecoration(
                  color: index < strength.level
                      ? strength.color
                      : AppColors.inputBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Text(
          strength.label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: strength.color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  _PasswordStrength _calculateStrength(String password) {
    if (password.isEmpty) return _PasswordStrength(0, '', AppColors.textTertiary);

    int score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(password) && RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    if (score <= 1) return _PasswordStrength(1, 'Weak', AppColors.error);
    if (score <= 2) return _PasswordStrength(2, 'Fair', AppColors.gold);
    if (score <= 3) return _PasswordStrength(3, 'Good', AppColors.secondaryPurple);
    return _PasswordStrength(4, 'Strong', AppColors.success);
  }
}

class _PasswordStrength {
  final int level;
  final String label;
  final Color color;

  _PasswordStrength(this.level, this.label, this.color);
}
