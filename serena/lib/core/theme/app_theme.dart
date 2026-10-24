import 'package:flutter/material.dart';
import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_spacing.dart';
import 'package:serena/core/theme/app_typography.dart';

class AppTheme {
  AppTheme._();

  static const Color error = Color(0xFFEF4444);
  static const Color errorTint = Color(0x1AEF4444);

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryTint,
      onPrimaryContainer: AppColors.primaryDark,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.secondaryTint,
      onSecondaryContainer: AppColors.secondaryDark,
      tertiary: AppColors.accent,
      onTertiary: Colors.white,
      tertiaryContainer: AppColors.accentTint,
      onTertiaryContainer: AppColors.accentDark,
      error: error,
      onError: Colors.white,
      surface: Colors.white,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textMuted,
      outline: AppColors.textFaint,
      outlineVariant: AppColors.divider,
    );

    final textTheme = TextTheme(
      displayLarge: AppTypography.h1,
      displayMedium: AppTypography.h2,
      displaySmall: AppTypography.h3,
      headlineLarge: AppTypography.h1,
      headlineMedium: AppTypography.h2,
      headlineSmall: AppTypography.h3,
      titleLarge: AppTypography.h3,
      titleMedium: AppTypography.label,
      titleSmall: AppTypography.optionTitle,
      bodyLarge: AppTypography.input,
      bodyMedium: AppTypography.body.copyWith(color: AppColors.textPrimary),
      bodySmall: AppTypography.subtitle,
      labelLarge: AppTypography.button,
      labelMedium: AppTypography.link,
      labelSmall: AppTypography.caption,
    );

    final inputBorder = OutlineInputBorder(
      borderRadius: AppRadius.input,
      borderSide: const BorderSide(color: AppColors.glassBorder),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.bgCream,
      canvasColor: AppColors.bgCream,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      splashColor: AppColors.primary.withAlpha(20),
      highlightColor: Colors.transparent,
      dividerColor: AppColors.divider,
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        foregroundColor: AppColors.textPrimary,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: AppTypography.h3.copyWith(fontSize: 18),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.glassInput,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: 16,
        ),
        hintStyle: AppTypography.inputHint,
        labelStyle: AppTypography.inputHint,
        helperStyle: AppTypography.helper,
        errorStyle: AppTypography.helper.copyWith(color: error),
        prefixIconColor: AppColors.textMuted,
        suffixIconColor: AppColors.textMuted,
        border: inputBorder,
        enabledBorder: inputBorder,
        disabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(
            color: AppColors.optionBorderPrimary,
            width: 1.5,
          ),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: error),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: error, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withAlpha(102),
          disabledForegroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
          textStyle: AppTypography.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textStrong,
          backgroundColor: AppColors.glassInput,
          minimumSize: const Size(double.infinity, AppSizes.googleButtonHeight),
          side: const BorderSide(color: AppColors.glassBorder),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.input),
          textStyle: AppTypography.buttonSecondary,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTypography.link,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        side: const BorderSide(color: AppColors.textFaint, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xs + 2),
        ),
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primary
              : Colors.transparent,
        ),
        checkColor: WidgetStateProperty.all(Colors.white),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(Colors.white),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.textFaint,
        ),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.progressTrack,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: AppTypography.body.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.input),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.bgCream,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.card),
          ),
        ),
      ),
    );
  }
}
