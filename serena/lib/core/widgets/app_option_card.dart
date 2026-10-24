// ignore_for_file: always_put_required_named_parameters_first, public_member_api_docs

import 'package:flutter/material.dart';

import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_spacing.dart';
import 'package:serena/core/theme/app_typography.dart';
import 'package:serena/core/widgets/app_glass.dart';

class AppOptionCard extends StatelessWidget {
  const AppOptionCard({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.caption,
    this.emoji,
    this.icon,
    this.leading,
    this.accent = AppColors.primary,
    this.height = AppSizes.optionCardHeight,
    this.multiSelect = false,
  });

  final String label;
  final String? caption;
  final bool selected;
  final VoidCallback? onTap;

  final String? emoji;
  final IconData? icon;
  final Widget? leading;
  final Color accent;
  final double height;
  final bool multiSelect;

  Color get _selectedFill => accent == AppColors.primary
      ? AppColors.optionFillPrimary
      : accent.withAlpha(31);

  Color get _selectedBorder {
    if (accent == AppColors.primary) return AppColors.optionBorderPrimary;
    if (accent == AppColors.secondary) return AppColors.optionBorderSecondary;
    return accent.withAlpha(128);
  }

  @override
  Widget build(BuildContext context) {
    final hasLeading = emoji != null || icon != null || leading != null;

    return AppGlass(
      blur: AppBlur.option,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      color: selected ? _selectedFill : AppColors.glassOption,
      borderColor: selected ? _selectedBorder : AppColors.glassBorder,
      borderWidth: selected ? 1.5 : 1,
      shadows: selected ? AppShadows.option(accent) : const <BoxShadow>[],
      width: double.infinity,
      height: height,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                if (hasLeading) ...[
                  Container(
                    width: AppSizes.iconBox,
                    height: AppSizes.iconBox,
                    decoration: BoxDecoration(
                      color: selected
                          ? accent.withAlpha(46)
                          : Colors.white.withAlpha(179),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    alignment: Alignment.center,
                    child: leading ??
                        (emoji != null
                            ? Text(emoji!, style: const TextStyle(fontSize: 18))
                            : Icon(icon, size: AppSizes.iconLg, color: accent)),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                ],
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: caption != null
                            ? AppTypography.optionTitle
                            : AppTypography.optionLabel,
                      ),
                      if (caption != null) ...[
                        const SizedBox(height: 2),
                        Text(caption!, style: AppTypography.optionCaption),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                _SelectIndicator(
                  selected: selected,
                  accent: accent,
                  multiSelect: multiSelect,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectIndicator extends StatelessWidget {
  const _SelectIndicator({
    required this.selected,
    required this.accent,
    required this.multiSelect,
  });

  final bool selected;
  final Color accent;
  final bool multiSelect;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: selected ? accent : Colors.transparent,
        borderRadius: BorderRadius.circular(multiSelect ? 6 : 10),
        border: selected
            ? null
            : Border.all(color: AppColors.textFaint, width: 1.5),
      ),
      child: selected
          ? const Icon(Icons.check_rounded, size: 13, color: Colors.white)
          : null,
    );
  }
}
