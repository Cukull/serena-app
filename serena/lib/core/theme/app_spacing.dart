import 'package:flutter/material.dart';

import 'package:serena/core/theme/app_colors.dart';

/// Shared layout dimensions and decoration tokens.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 10;
  static const double lg = 12;
  static const double xl = 16;
  static const double xxl = 20;

  /// Padding horizontal halaman (onboarding & sign up = 24, login = 26).
  static const double screenH = 24;
  static const double screenHLogin = 26;

  /// Padding dalam form card.
  static const double cardPadding = 21;

  /// Jarak antar field / antar kartu pilihan.
  static const double fieldGap = 10;
  static const double optionGap = 8;
}

class AppRadius {
  AppRadius._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 10;
  static const double lg = 14;
  static const double xl = 16;
  static const double xxl = 18;
  static const double card = 28;

  static BorderRadius get input => BorderRadius.circular(lg);
  static BorderRadius get button => BorderRadius.circular(xl);
  static BorderRadius get buttonLarge => BorderRadius.circular(xxl);
  static BorderRadius get cardRadius => BorderRadius.circular(card);
}

class AppSizes {
  AppSizes._();

  static const double inputHeight = 52;
  static const double buttonHeight = 54;
  static const double buttonHeightLarge = 56;
  static const double googleButtonHeight = 52;
  static const double optionCardHeight = 63;
  static const double goalCardHeight = 83;
  static const double goalToggleHeight = 56;

  static const double iconSm = 14;
  static const double iconMd = 18;
  static const double iconLg = 20;
  static const double iconBox = 34;

  static const double logoBox = 52;
  static const double logoBoxSmall = 45;
  static const double avatar = 24;

  static const double progressBarHeight = 4;
  static const double strengthBarHeight = 3;
}

class AppShadows {
  AppShadows._();

  /// Shadow surface glass utama.
  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x1A63C7F7), blurRadius: 32, offset: Offset(0, 8)),
    BoxShadow(color: Color(0x0F000000), blurRadius: 8, offset: Offset(0, 2)),
  ];

  /// Shadow ringan untuk input dan kontrol sekunder.
  static const List<BoxShadow> input = [
    BoxShadow(color: Color(0x0F000000), blurRadius: 12, offset: Offset(0, 2)),
  ];

  /// Shadow untuk tombol utama.
  static const List<BoxShadow> buttonPrimary = [
    BoxShadow(color: Color(0x6163C7F7), blurRadius: 28, offset: Offset(0, 10)),
    BoxShadow(color: Color(0x388B7CF8), blurRadius: 12, offset: Offset(0, 4)),
  ];

  /// Shadow khusus tombol onboarding.
  static const List<BoxShadow> buttonContinue = [
    BoxShadow(color: Color(0x5963C7F7), blurRadius: 24, offset: Offset(0, 8)),
    BoxShadow(color: Color(0x338B7CF8), blurRadius: 8, offset: Offset(0, 2)),
  ];

  /// Shadow untuk tombol dengan gradient sukses.
  static const List<BoxShadow> buttonSuccess = [
    BoxShadow(color: Color(0x527ED957), blurRadius: 28, offset: Offset(0, 10)),
    BoxShadow(color: Color(0x3363C7F7), blurRadius: 12, offset: Offset(0, 4)),
  ];

  /// Shadow untuk badge yang mengambang di atas konten.
  static const List<BoxShadow> badge = [
    BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, 4)),
  ];

  /// Menghasilkan shadow pilihan aktif sesuai warna aksen.
  static List<BoxShadow> option(Color accent) => [
        BoxShadow(
            color: accent.withAlpha(38),
            blurRadius: 16,
            offset: const Offset(0, 4)),
      ];

  /// Shadow untuk wadah logo.
  static const List<BoxShadow> logo = [
    BoxShadow(color: Color(0x2E63C7F7), blurRadius: 20, offset: Offset(0, 6)),
  ];
}

/// Nilai blur backdrop untuk permukaan glassmorphism.
class AppBlur {
  AppBlur._();

  static const double card = 12;
  static const double badge = 7;
  static const double input = 6;
  static const double option = 5;
  static const double logo = 8;
  static const double blob = 25;
}

/// BoxDecoration bersama untuk komponen glass dan tombol.
class AppDecorations {
  AppDecorations._();

  static BoxDecoration formCard = BoxDecoration(
    color: AppColors.glassCard,
    borderRadius: AppRadius.cardRadius,
    border: Border.all(color: AppColors.glassBorderCard),
    boxShadow: AppShadows.card,
  );

  static BoxDecoration input = BoxDecoration(
    color: AppColors.glassInput,
    borderRadius: AppRadius.input,
    border: Border.all(color: AppColors.glassBorder),
    boxShadow: AppShadows.input,
  );

  static BoxDecoration inputSuccess = BoxDecoration(
    color: AppColors.glassInput,
    borderRadius: AppRadius.input,
    border: Border.all(color: AppColors.inputSuccessBorder),
    boxShadow: [
      const BoxShadow(color: AppColors.inputSuccessGlow, spreadRadius: 3),
      ...AppShadows.input,
    ],
  );

  static BoxDecoration primaryButton = BoxDecoration(
    gradient: AppColors.primaryGradient,
    borderRadius: AppRadius.button,
    boxShadow: AppShadows.buttonPrimary,
  );

  static BoxDecoration successButton = BoxDecoration(
    gradient: AppColors.successGradient,
    borderRadius: AppRadius.button,
    boxShadow: AppShadows.buttonSuccess,
  );

  static BoxDecoration floatingBadge = BoxDecoration(
    color: AppColors.glassBadge,
    borderRadius: AppRadius.input,
    border: Border.all(color: AppColors.glassBorder),
    boxShadow: AppShadows.badge,
  );
}
