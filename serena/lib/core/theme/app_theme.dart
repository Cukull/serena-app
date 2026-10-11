import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:serena/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData get light {
    final base = ThemeData(useMaterial3: true);
    // Plus Jakarta Sans untuk seluruh aplikasi (permintaan: jakarta sans).
    final jakarta = GoogleFonts.plusJakartaSansTextTheme(base.textTheme);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.softPurple,
        primary: AppColors.softPurple,
      ),
      textTheme: jakarta.copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
          letterSpacing: -0.5,
        ),
        headlineLarge: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
          letterSpacing: -0.3,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
          letterSpacing: -0.2,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(color: AppColors.bodyGray),
        bodyMedium: GoogleFonts.plusJakartaSans(color: AppColors.bodyGray),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(44, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
