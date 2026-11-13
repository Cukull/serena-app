import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:serena/core/theme/app_colors.dart';

/// Skala teks Serena: Plus Jakarta Sans untuk UI, DM Serif Display untuk
/// judul halaman turunan. Sumber: `design.md`.
class AppTypography {
  AppTypography._();

  static TextStyle _jakarta(
    double size,
    FontWeight weight, {
    Color color = AppColors.textPrimary,
    double? letterSpacing,
    double? height,
  }) =>
      GoogleFonts.plusJakartaSans(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
      );

  static TextStyle get logo => _jakarta(
        22,
        FontWeight.w800,
        letterSpacing: -0.44,
      );

  static TextStyle get logoSmall =>
      logo.copyWith(fontSize: 18, letterSpacing: -0.36);

  static TextStyle get logoAccent => logo.copyWith(
        fontStyle: FontStyle.italic,
        color: AppColors.primary,
      );

  static TextStyle get h1 => _jakarta(
        26,
        FontWeight.w800,
        letterSpacing: -0.52,
        height: 1.2,
      );

  static TextStyle get h2 => h1.copyWith(fontSize: 24, letterSpacing: -0.48);

  static TextStyle get h3 => h1.copyWith(fontSize: 23, letterSpacing: -0.46);

  /// Judul halaman turunan (Info Pribadi, Keamanan & Privasi).
  static TextStyle get pageTitle => GoogleFonts.dmSerifDisplay(
        fontSize: 27,
        fontWeight: FontWeight.w400,
        height: 1.1,
        color: AppColors.textPrimary,
      );

  static TextStyle get buttonLarge =>
      _jakarta(16, FontWeight.w600, color: AppColors.textOnGradient);
  static TextStyle get button =>
      _jakarta(15, FontWeight.w800, color: AppColors.textOnGradient);
  static TextStyle get buttonSecondary =>
      _jakarta(14, FontWeight.w700, color: AppColors.textStrong);

  static TextStyle get statValue =>
      _jakarta(15, FontWeight.w700, color: AppColors.primary);

  /// Angka besar pada kartu statistik.
  static TextStyle get statBig => _jakarta(20, FontWeight.w800);

  static TextStyle get input => _jakarta(15, FontWeight.w600);
  static TextStyle get inputHint =>
      _jakarta(15, FontWeight.w400, color: AppColors.textMuted);

  static TextStyle get body =>
      _jakarta(13, FontWeight.w400, color: AppColors.textMuted);
  static TextStyle get bodyLink =>
      _jakarta(13, FontWeight.w700, color: AppColors.primary);
  static TextStyle get label => _jakarta(13, FontWeight.w700);
  static TextStyle get cardTitle => _jakarta(16, FontWeight.w700);
  static TextStyle get subtitle =>
      _jakarta(13, FontWeight.w400, color: AppColors.textMuted);

  /// Label bagian huruf kapital: "INFO DASAR", "KEAMANAN AKUN".
  static TextStyle get sectionLabel => _jakarta(
        12,
        FontWeight.w700,
        color: AppColors.textFaint,
        letterSpacing: 0.96,
      );

  /// Tautan aksi dalam kartu, mis. "Ubah", "+ Tambah", "Ganti foto".
  static TextStyle get actionLink =>
      _jakarta(13, FontWeight.w700, color: AppColors.primary);

  static TextStyle get fieldLabel =>
      _jakarta(12, FontWeight.w400, color: AppColors.textMuted);
  static TextStyle get fieldValue => _jakarta(15, FontWeight.w700);
  static TextStyle get chipLabel => _jakarta(13, FontWeight.w600);
  static TextStyle get toast =>
      _jakarta(14, FontWeight.w600, color: Colors.white);

  static TextStyle get optionTitle => _jakarta(12.5, FontWeight.w600);
  static TextStyle get optionLabel => _jakarta(
        12.5,
        FontWeight.w500,
        color: AppColors.textStrong,
        height: 1.3,
      );
  static TextStyle get optionCaption =>
      _jakarta(10.5, FontWeight.w400, color: AppColors.textMuted);

  static TextStyle get link =>
      _jakarta(12, FontWeight.w700, color: AppColors.primary);
  static TextStyle get step =>
      _jakarta(12, FontWeight.w500, color: AppColors.textMuted);
  static TextStyle get stepSmall => _jakarta(
        11,
        FontWeight.w500,
        color: AppColors.textMuted,
        letterSpacing: 0.44,
      );
  static TextStyle get divider =>
      _jakarta(12, FontWeight.w500, color: AppColors.textFaint);

  static TextStyle get caption =>
      _jakarta(11, FontWeight.w400, color: AppColors.textFaint);
  static TextStyle get captionLink => _jakarta(
        11,
        FontWeight.w500,
        color: AppColors.primary,
        height: 1.6,
      );
  static TextStyle get helper =>
      _jakarta(10.5, FontWeight.w500, color: AppColors.success);

  static TextStyle get tagline => _jakarta(
        11,
        FontWeight.w500,
        color: AppColors.textMuted,
        letterSpacing: 0.66,
      );

  static TextStyle get badgeLabel =>
      _jakarta(10, FontWeight.w500, color: AppColors.textMuted);
  static TextStyle get badgeChip =>
      _jakarta(10, FontWeight.w500, color: AppColors.primaryDark);
  static TextStyle get avatarInitial =>
      _jakarta(10, FontWeight.w600, color: AppColors.primaryDark);

  static TextStyle get statusBar => _jakarta(12, FontWeight.w600);

  static TextStyle get wordmark => _jakarta(
        20,
        FontWeight.w800,
        letterSpacing: 8,
      );

  static TextStyle get lead => _jakarta(
        14,
        FontWeight.w400,
        color: AppColors.textMuted,
        height: 1.55,
      );

  static TextStyle get tagChip => _jakarta(12, FontWeight.w500);
}
