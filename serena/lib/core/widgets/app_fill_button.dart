import 'package:flutter/material.dart';
import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_typography.dart';

enum AppFillVariant { primary, emerald, outline }

/// Tombol pil penuh layar auth (radius 26, sama dengan mockup serena-web).
class AppFillButton extends StatelessWidget {
  const AppFillButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = AppFillVariant.primary,
    this.leading,
    this.trailing,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppFillVariant variant;
  final Widget? leading;
  final Widget? trailing;
  final bool isLoading;

  static const _radius = BorderRadius.all(Radius.circular(26));

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null && !isLoading;
    final outline = variant == AppFillVariant.outline;

    final decoration = switch (variant) {
      AppFillVariant.primary => const BoxDecoration(
          gradient: AppColors.webPrimary,
          borderRadius: _radius,
          boxShadow: [
            BoxShadow(
              color: Color(0x598B6CF0),
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
          ],
        ),
      AppFillVariant.emerald => const BoxDecoration(
          gradient: AppColors.webEmerald,
          borderRadius: _radius,
          boxShadow: [
            BoxShadow(
              color: Color(0x5910B981),
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
          ],
        ),
      AppFillVariant.outline => BoxDecoration(
          color: AppColors.white,
          borderRadius: _radius,
          border: Border.all(color: AppColors.webFieldBorder, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A1E293B),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
    };

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
              if (leading != null) ...[leading!, const SizedBox(width: 10)],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.button.copyWith(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: outline ? const Color(0xFF1E293B) : Colors.white,
                  ),
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 10), trailing!],
            ],
          );

    return Opacity(
      opacity: disabled ? 0.5 : 1,
      child: Container(
        height: 52,
        decoration:
            disabled ? decoration.copyWith(boxShadow: const []) : decoration,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: disabled || isLoading ? null : onPressed,
            borderRadius: _radius,
            child: Center(child: content),
          ),
        ),
      ),
    );
  }
}
