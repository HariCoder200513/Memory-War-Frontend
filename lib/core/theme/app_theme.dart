import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.primaryBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryPurple,
        secondary: AppColors.secondaryPurple,
        surface: AppColors.secondaryBackground,
        error: AppColors.error,
        onPrimary: AppColors.textPrimary,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textPrimary,
      ),
      textTheme: _textTheme,
      inputDecorationTheme: _inputDecorationTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
    );
  }

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: GoogleFonts.spaceGrotesk(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.15,
      ),
      displayMedium: GoogleFonts.spaceGrotesk(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.2,
      ),
      headlineLarge: GoogleFonts.spaceGrotesk(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.2,
      ),
      headlineMedium: GoogleFonts.spaceGrotesk(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.25,
      ),
      headlineSmall: GoogleFonts.spaceGrotesk(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
      ),
      titleLarge: GoogleFonts.spaceGrotesk(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textTertiary,
        height: 1.4,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textTertiary,
      ),
    );
  }

  static InputDecorationTheme get _inputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBackground,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
        borderSide: const BorderSide(color: AppColors.inputBorderFocused, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 14,
        color: AppColors.textTertiary,
      ),
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        color: AppColors.textSecondary,
      ),
      errorStyle: GoogleFonts.inter(
        fontSize: 12,
        color: AppColors.error,
      ),
    );
  }

  static ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.primaryBackground,
        disabledBackgroundColor: AppColors.gold.withValues(alpha: 0.4),
        disabledForegroundColor: AppColors.primaryBackground.withValues(alpha: 0.6),
        minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        elevation: 0,
      ),
    );
  }

  static OutlinedButtonThemeData get _outlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
        ),
        side: const BorderSide(color: AppColors.inputBorder),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        elevation: 0,
      ),
    );
  }

  static TextButtonThemeData get _textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryPurple,
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
