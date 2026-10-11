import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:serena/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData get light {
    final base = ThemeData(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.softPurple,
        primary: AppColors.softPurple,
      ),
      textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.fraunces(
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        displayMedium: GoogleFonts.fraunces(
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        headlineLarge: GoogleFonts.fraunces(
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        headlineMedium: GoogleFonts.fraunces(
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        bodyLarge: GoogleFonts.dmSans(color: AppColors.bodyGray),
        bodyMedium: GoogleFonts.dmSans(color: AppColors.bodyGray),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
