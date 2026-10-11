import 'package:flutter/material.dart';

/// Palet warna Serena — "Balance Your Mind, Study & Life."
/// Sumber: brand board Serena (Soft Blue, Soft Purple, Warm White, Light Blue).
/// Pakai konstanta ini di semua widget, jangan hardcode hex.
class AppColors {
  // Brand utama
  static const softBlue = Color(0xFF63C7F7);
  static const softPurple = Color(0xFF6B7CF8);
  static const warmWhite = Color(0xFFFAF7F2);
  static const lightBlue = Color(0xFFEAF6FC);

  static const background = Color(0xFFF4F8FF);
  static const white = Color(0xFFFFFFFF);

  static const ink = Color(0xFF1B2A5B);
  static const bodyGray = Color(0xFF5B6478);
  static const mutedGray = Color(0xFF9AA3B5);

  static const skyBlue = softBlue;
  static const deepBlue = Color(0xFF3B82F6);

  static const mint = Color(0xFFE6F9ED);
  static const mintText = Color(0xFF22A55B);
  static const peach = Color(0xFFFFF3E4);
  static const lavender = Color(0xFFF1ECFF);
  static const babyBlue = lightBlue;

  static const cardShadow = Color(0x1A3B82F6);

  static const gradientPrimary = LinearGradient(
    colors: [Color(0xFF63C7F7), Color(0xFF6B7CF8)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const gradientBackground = LinearGradient(
    colors: [Color(0xFFEAF6FC), Color(0xFFFAF7F2), Color(0xFFFFFFFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
