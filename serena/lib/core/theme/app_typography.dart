import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:serena/core/theme/app_colors.dart';

/// Text styles used across the app; headings use Fraunces and UI text uses DM Sans.
class AppTypography {
  AppTypography._();

  static TextStyle get logo => GoogleFonts.fraunces(
        fontSize: 22,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.44,
        color: AppColors.textPrimary,
      );

  static TextStyle get logoSmall =>
      logo.copyWith(fontSize: 18, letterSpacing: -0.36);

  static TextStyle get logoAccent => logo.copyWith(
        fontStyle: FontStyle.italic,
        color: AppColors.primary,
      );

  static TextStyle get h1 => GoogleFonts.fraunces(
        fontSize: 26,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.52,
        height: 1.2,
        color: AppColors.textPrimary,
      );

  static TextStyle get h2 => h1.copyWith(
        fontSize: 24,
        letterSpacing: -0.48,
        height: 1.3,
      );

  static TextStyle get h3 => h1.copyWith(
        fontSize: 23,
        letterSpacing: -0.46,
        height: 1.25,
      );

  static TextStyle _dm(
    double size,
    FontWeight weight, {
    Color color = AppColors.textPrimary,
    double? letterSpacing,
    double? height,
  }) =>
      GoogleFonts.dmSans(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
      );

  static TextStyle get buttonLarge => _dm(16, FontWeight.w600,
      color: AppColors.textOnGradient, letterSpacing: -0.16);
  static TextStyle get button => _dm(15.5, FontWeight.w600,
      color: AppColors.textOnGradient, letterSpacing: -0.155);
  static TextStyle get buttonSecondary =>
      _dm(14, FontWeight.w500, color: AppColors.textStrong);

  static TextStyle get statValue =>
      _dm(15, FontWeight.w700, color: AppColors.primary);

  static TextStyle get input => _dm(14, FontWeight.w400);
  static TextStyle get inputHint =>
      _dm(14, FontWeight.w400, color: AppColors.textMuted);

  static TextStyle get body =>
      _dm(13, FontWeight.w400, color: AppColors.textMuted);
  static TextStyle get bodyLink =>
      _dm(13, FontWeight.w600, color: AppColors.primary);
  static TextStyle get label => _dm(13, FontWeight.w600);
  static TextStyle get subtitle =>
      _dm(12.5, FontWeight.w400, color: AppColors.textMuted);

  static TextStyle get optionTitle => _dm(12.5, FontWeight.w600);
  static TextStyle get optionLabel =>
      _dm(12.5, FontWeight.w500, color: AppColors.textStrong, height: 1.3);
  static TextStyle get optionCaption =>
      _dm(10.5, FontWeight.w400, color: AppColors.textMuted);

  static TextStyle get link =>
      _dm(12, FontWeight.w500, color: AppColors.primary);
  static TextStyle get step =>
      _dm(12, FontWeight.w500, color: AppColors.textMuted);
  static TextStyle get stepSmall =>
      _dm(11, FontWeight.w500, color: AppColors.textMuted, letterSpacing: 0.44);
  static TextStyle get divider =>
      _dm(12, FontWeight.w500, color: AppColors.textFaint);

  static TextStyle get caption =>
      _dm(11, FontWeight.w400, color: AppColors.textFaint);
  static TextStyle get captionLink =>
      _dm(11, FontWeight.w500, color: AppColors.primary, height: 1.6);
  static TextStyle get helper =>
      _dm(10.5, FontWeight.w500, color: AppColors.success);

  static TextStyle get tagline =>
      _dm(11, FontWeight.w500, color: AppColors.textMuted, letterSpacing: 0.66);

  static TextStyle get badgeLabel =>
      _dm(10, FontWeight.w500, color: AppColors.textMuted);
  static TextStyle get badgeChip =>
      _dm(10, FontWeight.w500, color: AppColors.primaryDark);
  static TextStyle get avatarInitial =>
      _dm(10, FontWeight.w600, color: AppColors.primaryDark);

  static TextStyle get statusBar => _dm(12, FontWeight.w600);

  static TextStyle get wordmark => GoogleFonts.fraunces(
        fontSize: 20,
        fontWeight: FontWeight.w300,
        letterSpacing: 8,
        color: AppColors.textPrimary,
      );

  static TextStyle get lead =>
      _dm(14, FontWeight.w400, color: AppColors.textMuted, height: 1.55);

  static TextStyle get tagChip => _dm(12, FontWeight.w500);
}
