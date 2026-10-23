// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_spacing.dart';
import 'package:serena/core/theme/app_typography.dart';
import 'package:serena/core/widgets/app_glass.dart';

class AppFloatingBadge extends StatelessWidget {
  const AppFloatingBadge({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  });

  factory AppFloatingBadge.stat({
    required String value,
    required String label,
    Key? key,
    IconData? icon,
  }) {
    return AppFloatingBadge(
      key: key,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppSizes.iconMd, color: AppColors.primary),
            const SizedBox(width: 6),
          ],
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: AppTypography.statValue),
              Text(label, style: AppTypography.badgeLabel),
            ],
          ),
        ],
      ),
    );
  }

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return AppGlass(
      blur: AppBlur.badge,
      borderRadius: AppRadius.input,
      color: AppColors.glassBadge,
      borderColor: AppColors.glassBorder,
      shadows: AppShadows.badge,
      padding: padding,
      child: child,
    );
  }
}

class AppBadgeChip extends StatelessWidget {
  const AppBadgeChip({
    required this.label,
    super.key,
    this.icon,
    this.gradient = AppColors.chipGradient,
  });

  final String label;
  final IconData? icon;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: AppColors.primaryDark),
            const SizedBox(width: 4),
          ],
          Text(label, style: AppTypography.badgeChip),
        ],
      ),
    );
  }
}

/// Chip kategori berbentuk pill dengan emoji (Wellness, Focus, Sleep, ...).
class AppTagChip extends StatelessWidget {
  const AppTagChip({
    required this.label,
    required this.background,
    required this.foreground,
    required this.border,
    super.key,
    this.emoji,
  });

  const AppTagChip.primary({required this.label, this.emoji, super.key})
      : background = AppColors.primaryTint,
        foreground = AppColors.primaryDark,
        border = AppColors.chipBorderPrimary;

  const AppTagChip.secondary({required this.label, this.emoji, super.key})
      : background = AppColors.secondaryTint,
        foreground = AppColors.secondaryDark,
        border = AppColors.chipBorderSecondary;

  const AppTagChip.success({required this.label, this.emoji, super.key})
      : background = AppColors.successTint,
        foreground = AppColors.successDark,
        border = AppColors.chipBorderSuccess;

  const AppTagChip.accent({required this.label, this.emoji, super.key})
      : background = AppColors.accentTint,
        foreground = AppColors.accentDark,
        border = AppColors.chipBorderAccent;

  final String label;
  final String? emoji;
  final Color background;
  final Color foreground;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (emoji != null) ...[
            Text(emoji!, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 6),
          ],
          Text(label, style: AppTypography.tagChip.copyWith(color: foreground)),
        ],
      ),
    );
  }
}

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    required this.initial,
    super.key,
    this.size = AppSizes.avatar,
    this.background = AppColors.primaryTint,
    this.foreground = AppColors.primaryDark,
  });

  final String initial;
  final double size;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(shape: BoxShape.circle, color: background),
      child: Text(
        initial.isEmpty ? '' : initial.characters.first.toUpperCase(),
        style: AppTypography.avatarInitial.copyWith(color: foreground),
      ),
    );
  }
}
