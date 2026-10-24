// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_spacing.dart';
import 'package:serena/core/theme/app_typography.dart';

class AppDividerLabel extends StatelessWidget {
  const AppDividerLabel({super.key, this.label = 'or continue with'});

  final String label;

  @override
  Widget build(BuildContext context) {
    const line = Expanded(
      child: Divider(color: AppColors.divider, thickness: 1, height: 1),
    );

    return Row(
      children: [
        line,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(label, style: AppTypography.divider),
        ),
        line,
      ],
    );
  }
}
