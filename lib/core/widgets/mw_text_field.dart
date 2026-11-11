import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

class MwTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? errorText;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final bool enabled;
  final bool autofocus;

  const MwTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.errorText,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onEditingComplete,
    this.enabled = true,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          enabled: enabled,
          autofocus: autofocus,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
          ),
        ),
      ],
    );
  }
}
