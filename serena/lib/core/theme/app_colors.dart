import 'package:flutter/material.dart';

/// Palette bersama untuk theme dan komponen UI.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF63C7F7);
  static const Color secondary = Color(0xFF8B7CF8);
  static const Color success = Color(0xFF7ED957);
  static const Color accent = Color(0xFFFF9F68);

  // Warna gelap dipakai untuk teks atau ikon di atas tint yang sesuai.
  static const Color primaryDark = Color(0xFF1A8FC2);
  static const Color secondaryDark = Color(0xFF6B5ED8);
  static const Color successDark = Color(0xFF3A8C1A);
  static const Color accentDark = Color(0xFFC45A1A);

  // Tint solid untuk permukaan berwarna lembut.
  static const Color primaryTint = Color(0xFFEAF7FC);
  static const Color secondaryTint = Color(0xFFF0EDFF);
  static const Color successTint = Color(0xFFEDFFF4);
  static const Color accentTint = Color(0xFFFFF3EE);

  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textStrong = Color(0xFF374151);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textFaint = Color(0xFFB0B8C8);
  static const Color textOnGradient = Colors.white;

  static const Color bgCream = Color(0xFFFAF7F2);
  static const Color bgSky = Color(0xFFEDF8FD);
  static const Color bgLavender = Color(0xFFF0EDFF);
  static const Color bgLavenderSoft = Color(0xFFF5F3FF);

  // Permukaan semi-transparan untuk komponen glassmorphism.
  static const Color glassCard = Color(0x99FFFFFF);
  static const Color glassInput = Color(0xB8FFFFFF);
  static const Color glassBadge = Color(0xBFFFFFFF);
  static const Color glassOption = Color(0xA6FFFFFF);
  static const Color glassBorder = Color(0xE6FFFFFF);
  static const Color glassBorderCard = Color(0xE0FFFFFF);
  static const Color glassStat = Color(0xD7FFFFFF);
  static const Color glassStatBorder = Color(0xC8FFFFFF);

  static const Color divider = Color(0x14000000);
  static const Color progressTrack = Color(0x14000000);
  static const Color progressDot = Color(0x1A000000);
  static const Color iconOverlayOnButton = Color(0x40FFFFFF);

  static const Color strengthStrong = success;
  static const Color strengthGood = primary;
  static const Color inputSuccessBorder = Color(0x667ED957);
  static const Color inputSuccessGlow = Color(0x147ED957);

  static const Color optionBorderPrimary = Color(0x8063C7F7);
  static const Color optionBorderSecondary = Color(0x808B7CF8);
  static const Color optionFillPrimary = Color(0x1F63C7F7);

  // Kartu statistik (streak, mood).
  static const Color statLabel = Color(0xFF9AA1B2);
  static const Color statTitle = Color(0xFF6F7689);
  static const Color statPurple = Color(0xFF8B7CF0);
  static const Color statSky = Color(0xFF5AB8F2);
  static const Color statGreen = Color(0xFF6CCB5F);
  static const Color statIconGreenTint = Color(0xFFDDF5E0);
  static const Color statIconSkyTint = Color(0xFFDDEEFC);

  static const Color illusSkin = Color(0xFFFFD0A8);
  static const Color illusSkinFade = Color(0x00FFD0A8);
  static const Color illusHair = Color(0xFFA79BEA);
  static const Color illusFace = Color(0xFF8A6A58);
  static const Color illusBody = Color(0xFF7CC4F4);
  static const Color illusBodyLight = Color(0xFFA6D8F8);
  static const Color illusTorso = Color(0xFF8CCBF5);
  static const Color illusSleeve = Color(0xFFB9D6EE);
  static const Color illusRope = Color(0xFF9ED3F5);
  static const Color illusSoftOval = Color(0xFFD3ECFA);
  static const Color illusGroundShadow = Color(0xFFBFE3F5);
  static const Color illusTreeTrunk = Color(0xFF86C47A);
  static const Color illusTreeLeaf = Color(0xFFC5E8B8);
  static const Color illusTreeLeafDeep = Color(0xFFB4DFA6);
  static const Color illusBook = Color(0xFF6C8DF5);
  static const Color illusBookLight = Color(0xFF93AEFB);
  static const Color illusBookLine = Color(0xDCFFFFFF);
  static const Color illusSparkle = Color(0xFFFFD66B);
  static const Color illusMint = Color(0xFF9BE3B0);
  static const Color illusMoon = Color(0xFFC9B8F7);
  static const Color illusDotLavender = Color(0xFFB9A8F5);
  static const Color illusDotBlue = Color(0xFF6FB6FF);
  static const Color illusRing = Color(0xFFC3CCF5);
  static const Color illusBlush = Color(0xFFF5A8B0);
  static const Color illusDesk = Color(0xFFBFDDF7);
  static const Color illusDeskLeg = Color(0xFFC9E3F8);
  static const Color illusHeadphone = Color(0xFF5AB4F2);
  static const Color illusHeadphoneCup = Color(0xFF4FA3F7);
  static const Color illusScreen = Color(0xFFF8FBFF);
  static const Color illusScreenBorder = Color(0xFFD3E5F5);
  static const Color illusChartPanel = Color(0xFFEAF0FA);
  static const Color illusLaptopBase = Color(0xFFD3E2F0);
  static const Color illusLineViolet = Color(0xFFA79BEA);
  static const Color illusLineBlue = Color(0xFF8CB4F5);
  static const Color illusLineGreen = Color(0xFF8ED58C);
  static const Color illusLineFaint = Color(0xFFC9D4F5);
  static const Color illusBarBlue = Color(0xFF4FA3F7);
  static const Color illusBarGreen = Color(0xFF5CCB6B);
  static const Color illusMug = Color(0xFFFBBF9A);
  static const Color illusIconTile = Color(0xFFE3E7EE);
  static const Color illusRed = Color(0xFFE25C6B);

  static const Color chipBorderPrimary = Color(0x4063C7F7);
  static const Color chipBorderSecondary = Color(0x408B7CF8);
  static const Color chipBorderSuccess = Color(0x407ED957);
  static const Color chipBorderAccent = Color(0x40FF9F68);

  static const Color logoRing = Color(0x3363C7F7);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [success, primary],
  );

  static const LinearGradient buttonShine = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x2EFFFFFF), Color(0x00FFFFFF)],
    stops: [0.0, 0.6],
  );

  static const LinearGradient bgLogin = LinearGradient(
    begin: Alignment(-0.34, -0.94),
    end: Alignment(0.34, 0.94),
    colors: [bgCream, bgSky, bgLavender, bgCream],
    stops: [0.0, 0.35, 0.65, 1.0],
  );

  static const LinearGradient bgSignUp = LinearGradient(
    begin: Alignment(-0.42, -0.91),
    end: Alignment(0.42, 0.91),
    colors: [bgLavenderSoft, bgCream, bgSky, bgLavenderSoft],
    stops: [0.0, 0.3, 0.65, 1.0],
  );

  static const LinearGradient bgOnboarding = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [bgCream, bgLavenderSoft, bgSky],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient chipGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x2663C7F7), Color(0x268B7CF8)],
  );
}
