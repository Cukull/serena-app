// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_spacing.dart';
import 'package:serena/core/theme/app_typography.dart';
import 'package:serena/core/widgets/app_glass.dart';

class AppGoogleButton extends StatelessWidget {
  const AppGoogleButton({
    required this.onPressed,
    super.key,
    this.label = 'Continue with Google',
    this.leading,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final String label;
  final Widget? leading;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null && !isLoading;

    return Opacity(
      opacity: disabled ? 0.5 : 1,
      child: AppGlass(
        blur: AppBlur.input,
        borderRadius: AppRadius.input,
        color: AppColors.glassInput,
        borderColor: AppColors.glassBorder,
        shadows: AppShadows.input,
        width: double.infinity,
        height: AppSizes.googleButtonHeight,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: (isLoading || onPressed == null) ? null : onPressed,
            borderRadius: AppRadius.input,
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        leading ?? const _GoogleGlyph(),
                        const SizedBox(width: AppSpacing.md),
                        Text(label, style: AppTypography.buttonSecondary),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleGlyph extends StatelessWidget {
  const _GoogleGlyph();

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => const SweepGradient(
        colors: [
          Color(0xFF4285F4),
          Color(0xFF34A853),
          Color(0xFFFBBC05),
          Color(0xFFEA4335),
          Color(0xFF4285F4),
        ],
      ).createShader(bounds),
      child: const Text(
        'G',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          height: 1,
          color: Colors.white,
        ),
      ),
    );
  }
}
