import 'package:flutter/material.dart';

/// Palet warna Florea — diambil dari contoh screen Figma.
/// Pakai konstanta ini di semua widget, jangan hardcode hex.
class AppColors {
  static const warmWhite = Color(0xFFFAF7F2);
  static const background = Color(0xFFF4F8FF);
  static const white = Color(0xFFFFFFFF);

  static const ink = Color(0xFF1E1B2E);
  static const bodyGray = Color(0xFF6B7280);
  static const mutedGray = Color(0xFF9CA3AF);

  static const softPurple = Color(0xFF8B7CF8);
  static const skyBlue = Color(0xFF5AB8FF);
  static const deepBlue = Color(0xFF3B82F6);

  static const mint = Color(0xFFE6F9ED);
  static const mintText = Color(0xFF22C55E);
  static const peach = Color(0xFFFFF3E4);
  static const lavender = Color(0xFFF1ECFF);
  static const babyBlue = Color(0xFFE8F4FF);

  static const cardShadow = Color(0x1A3B82F6);

  static const gradientPrimary = LinearGradient(
    colors: [Color(0xFF5AB8FF), Color(0xFF8B7CF8)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const gradientBackground = LinearGradient(
    colors: [Color(0xFFEAF4FF), Color(0xFFF8FAFF), Color(0xFFFFFFFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
