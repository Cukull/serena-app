// ignore_for_file: lines_longer_than_80_chars, require_trailing_commas, always_put_required_named_parameters_first, public_member_api_docs

import 'package:flutter/material.dart';

import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_spacing.dart';
import 'package:serena/core/theme/app_typography.dart';

/// Progress onboarding berbentuk segmen. [current] 1-based.
class AppStepProgress extends StatelessWidget {
  const AppStepProgress({
    required this.current,
    required this.total,
    super.key,
    this.label,
    this.showLabel = true,
  });

  final int current;
  final int total;

  /// Default: "Step {current} of {total}".
  final String? label;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel) ...[
          Text(label ?? 'Step $current of $total',
              style: AppTypography.stepSmall),
          const SizedBox(height: AppSpacing.sm),
        ],
        Row(
          children: List.generate(total, (i) {
            final filled = i < current;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i == total - 1 ? 0 : 6),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: AppSizes.progressBarHeight,
                  decoration: BoxDecoration(
                    color: filled ? null : AppColors.progressTrack,
                    gradient: filled ? AppColors.primaryGradient : null,
                    borderRadius:
                        BorderRadius.circular(AppSizes.progressBarHeight / 2),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

/// Indikator titik (carousel / onboarding). [index] 0-based.
class AppDotsIndicator extends StatelessWidget {
  const AppDotsIndicator({super.key, required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? null : AppColors.progressDot,
            gradient: active ? AppColors.primaryGradient : null,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
