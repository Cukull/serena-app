// ignore: lines_longer_than_80_chars
// ignore_for_file: omit_local_variable_types, always_put_required_named_parameters_first, public_member_api_docs

import 'package:flutter/material.dart';
import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_spacing.dart';
import 'package:serena/core/theme/app_typography.dart';

enum AppButtonVariant {
  primary,
  success,
  large,
}

/// `onPressed: null` = disabled (opacity 50%, tanpa shadow).
class AppGradientButton extends StatelessWidget {
  const AppGradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final bool disabled = onPressed == null && !isLoading;
    final bool tappable = onPressed != null && !isLoading;

    late final BoxDecoration decoration;
    late final BorderRadius radius;
    late final double height;
    late final TextStyle textStyle;

    switch (variant) {
      case AppButtonVariant.primary:
        decoration = AppDecorations.primaryButton;
        radius = AppRadius.button;
        height = AppSizes.buttonHeight;
        textStyle = AppTypography.button;
      case AppButtonVariant.success:
        decoration = AppDecorations.successButton;
        radius = AppRadius.button;
        height = AppSizes.buttonHeight;
        textStyle = AppTypography.button;
      case AppButtonVariant.large:
        radius = AppRadius.buttonLarge;
        decoration = BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: radius,
          boxShadow: AppShadows.buttonContinue,
        );
        height = AppSizes.buttonHeightLarge;
        textStyle = AppTypography.buttonLarge;
    }

    final content = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: AppSizes.iconMd, color: Colors.white),
                const SizedBox(width: AppSpacing.sm),
              ],
              Flexible(
                child: Text(
                  label,
                  style: textStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: AppSpacing.md),
                Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.iconOverlayOnButton,
                  ),
                  child: Icon(
                    trailingIcon,
                    size: AppSizes.iconSm,
                    color: Colors.white,
                  ),
                ),
              ],
            ],
          );

    final button = Container(
      height: height,
      decoration: disabled
          ? decoration.copyWith(boxShadow: const <BoxShadow>[])
          : decoration,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: tappable ? onPressed : null,
          borderRadius: radius,
          child: Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: AppColors.buttonShine,
                      borderRadius: radius,
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: content,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Opacity(
      opacity: disabled ? 0.5 : 1,
      child: expanded
          ? SizedBox(width: double.infinity, child: button)
          : IntrinsicWidth(child: button),
    );
  }
}
