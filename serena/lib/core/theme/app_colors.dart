import 'package:flutter/material.dart';

/// Palet warna Serena.
///
/// Sumber tunggal: `design.md` (Info Pribadi, Keamanan & Privasi, Profil).
/// Pakai konstanta ini di semua widget, jangan hardcode hex.
class AppColors {
  AppColors._();

  // ---------------------------------------------------------------- brand
  /// Violet utama — aksi, tautan, item aktif.
  static const primary = Color(0xFF7C6BF0);
  static const primaryDark = Color(0xFF5A49C9);
  static const primaryTint = Color(0xFFEDE9FE);

  /// Biru sekunder — angka skor, aksen dingin.
  static const secondary = Color(0xFF4F9BE8);
  static const secondaryDark = Color(0xFF2F6DB5);
  static const secondaryTint = Color(0xFFE3F0FD);

  /// Hijau (teal) — status aman / berhasil.
  static const accent = Color(0xFF2BAE8E);
  static const accentDark = Color(0xFF1F7A58);
  static const accentTint = Color(0xFFDFF3EA);
  static const success = accent;

  /// Merah — zona bahaya.
  static const danger = Color(0xFFE5646B);
  static const dangerDark = Color(0xFFC2444C);
  static const dangerTint = Color(0xFFFFF1F2);
  static const dangerBorder = Color(0xFFF2A2AA);
  static const dangerListBorder = Color(0xFFF6CFD2);

  // ---------------------------------------------------------------- text
  static const textPrimary = Color(0xFF1B2340);
  static const textStrong = Color(0xFF2B3A67);
  static const textMuted = Color(0xFF6B7391);
  static const textFaint = Color(0xFF8C93AE);
  static const textOnGradient = Colors.white;

  // -------------------------------------------------------------- surface
  static const bgCream = Color(0xFFF5F3FF);
  static const white = Color(0xFFFFFFFF);
  static const divider = Color(0xFFE6E9F5);

  static const glassCard = white;
  static const glassBorder = divider;
  static const glassBorderCard = divider;
  static const glassInput = Color(0xFFFAFBFF);
  static const glassBadge = Color(0xFFF1F3FA);
  static const glassOption = Color(0xFFF7F9FF);
  static const glassStat = white;
  static const glassStatBorder = divider;

  static const progressTrack = Color(0xFFE8EDF7);
  static const optionBorderPrimary = primary;
  static const chipBorderPrimary = Color(0xFFBBD8F7);
  static const chipBorderSecondary = Color(0xFFD2C8FA);
  static const inputSuccessBorder = Color(0xFFB5E3CE);
  static const inputSuccessGlow = Color(0x33B5E3CE);
  static const logoRing = Color(0xFFCFE3F8);

  // --------------------------------------------------------- stat tiles
  static const statTitle = textPrimary;
  static const statLabel = textMuted;
  static const statPurple = primary;
  static const statGreen = accentDark;
  static const statSky = secondary;
  static const statIconSkyTint = secondaryTint;
  static const statIconGreenTint = accentTint;

  // ------------------------------------------------------ status pills
  static const okPill = Color(0xFFD6F2E4);
  static const okPillBorder = Color(0xFFB5E3CE);
  static const okPillText = accentDark;
  static const warnPill = Color(0xFFFFE9D6);
  static const warnPillBorder = Color(0xFFF8CDB0);
  static const warnText = Color(0xFFB5581F);

  // ------------------------------------------------------------- chips
  static const chipBlueBg = secondaryTint;
  static const chipBlueBorder = Color(0xFFBBD8F7);
  static const chipBlueText = secondaryDark;
  static const chipVioletBg = primaryTint;
  static const chipVioletText = primaryDark;
  static const chipGreenBg = accentTint;
  static const chipGreenText = accentDark;
  static const chipPeachBg = Color(0xFFFFEBDD);
  static const chipPeachBorder = Color(0xFFF8CDB0);
  static const chipPeachText = Color(0xFFB5581F);

  // ------------------------------------------------------- icon tiles
  static const tileBlue = Color(0xFFE7EEFD);
  static const tileViolet = Color(0xFFEDE9FE);
  static const tilePeach = Color(0xFFFFEBDD);
  static const tileGreen = Color(0xFFDFF3EA);
  static const tileRed = Color(0xFFFFE3E5);

  // --------------------------------------------------------- gradients
  /// Tombol utama & pill aktif.
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF6FB4F2), primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const gradientPrimary = primaryGradient;

  /// Latar halaman: lavender → biru → mint.
  static const gradientBackground = LinearGradient(
    colors: [Color(0xFFF5F3FF), Color(0xFFEAF4FD), Color(0xFFEFFAF4)],
    stops: [0, 0.38, 1],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Kartu hero profil.
  static const profileGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF5B8DEF), Color(0xFF2DD4BF)],
    stops: [0, 0.52, 1],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const avatarGradient = LinearGradient(
    colors: [Color(0xFFFFB88C), Color(0xFFE58AB8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Ring avatar halaman Info Pribadi.
  static const avatarRingGradient = LinearGradient(
    colors: [Color(0xFFFFB88C), Color(0xFF8FB8F5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Progress bar keamanan & tombol sukses.
  static const successGradient = LinearGradient(
    colors: [secondary, Color(0xFF34C3A8)],
  );
  static const progressGradient = LinearGradient(
    colors: [secondary, Color(0xFF34C3A8)],
  );

  // -------------------------------------------------- dekorasi latar
  static const blobViolet = Color(0xFFC9BDFB);
  static const blobCyan = Color(0xFFB7E6F4);
  static const pageEdge = Color(0xFFEAF0FB);
  static const cardShadow = Color(0x143C4682);

  // ------------------------------------------------------ ilustrasi
  static const illusSoftOval = Color(0xFFEFF4FE);
  static const illusGroundShadow = Color(0xFFDDE3F3);
  static const illusTreeLeaf = Color(0xFF9ED9C0);
  static const illusTreeLeafDeep = Color(0xFF6CC5A4);
  static const illusTreeTrunk = Color(0xFFC6A98A);
  static const illusRope = Color(0xFFC9D2E8);
  static const illusBody = Color(0xFF7C6BF0);
  static const illusBodyLight = Color(0xFFA99DF7);
  static const illusSkinFade = Color(0xFFFBD7BD);
  static const illusSkin = Color(0xFFF3A27E);
  static const illusHair = Color(0xFF4A3E63);
  static const illusFace = Color(0xFF1B2340);
  static const illusBook = Color(0xFF6FB4F2);
  static const illusBookLight = Color(0xFFA8D2FA);
  static const illusBookLine = Colors.white;
  static const illusSparkle = Color(0xFFFFC96B);
  static const illusMint = Color(0xFF2BAE8E);
  static const illusDotLavender = Color(0xFFB9ACF7);
  static const illusDotBlue = Color(0xFF8FC4F5);
  static const illusMoon = Color(0xFFFFD98E);
  static const illusRing = divider;
  static const illusBlush = Color(0xFFFFE3E5);
  static const illusDesk = tileBlue;
  static const illusDeskLeg = Color(0xFFC9D2E8);
  static const illusTorso = Color(0xFF5B8DEF);
  static const illusSleeve = secondary;
  static const illusHeadphone = textStrong;
  static const illusHeadphoneCup = primary;
  static const illusScreen = Colors.white;
  static const illusScreenBorder = logoRing;
  static const illusLineViolet = Color(0xFFB9ACF7);
  static const illusLineBlue = Color(0xFF8FC4F5);
  static const illusLineGreen = Color(0xFF9ED9C0);
  static const illusLineFaint = divider;
  static const illusChartPanel = glassBadge;
  static const illusBarBlue = secondary;
  static const illusBarGreen = accent;
  static const illusLaptopBase = Color(0xFFC9D2E8);
  static const illusIconTile = primaryTint;
  static const illusMug = Color(0xFFFFB88C);
  static const illusRed = danger;

  // ------------------------------------ alias lama (jaga kompatibilitas)
  static const softBlue = secondary;
  static const softPurple = primary;
  static const warmWhite = glassInput;
  static const lightBlue = Color(0xFFEAF4FD);
  static const background = bgCream;
  static const ink = textPrimary;
  static const bodyGray = textMuted;
  static const mutedGray = textFaint;
  static const skyBlue = secondary;
  static const deepBlue = Color(0xFF3B82F6);
  static const mint = okPill;
  static const mintText = accentDark;
  static const peach = chipPeachBg;
  static const lavender = primaryTint;
  static const babyBlue = lightBlue;

  static const Color successTint = Color(0xFFEDFFF4);
  static const Color successDark = Color(0xFF3A8C1A);
  static const Color chipBorderSuccess = Color(0x407ED957);
  static const Color chipBorderAccent = Color(0x40FF9F68);

  static const Color bgSky = Color(0xFFEDF8FD);
  static const Color bgLavender = Color(0xFFF0EDFF);
  static const Color bgLavenderSoft = Color(0xFFF5F3FF);

  static const Color progressDot = Color(0x1A000000);
  static const Color iconOverlayOnButton = Color(0x40FFFFFF);

  static const Color strengthStrong = success;
  static const Color strengthGood = primary;

  static const Color optionBorderSecondary = Color(0x808B7CF8);
  static const Color optionFillPrimary = Color(0x1F63C7F7);

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
