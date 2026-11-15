// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';

import 'package:serena/core/theme/app_typography.dart';

/// Judul section + "Lihat semua →" link.
/// Matches section-header-row in serena-web pages.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: AppTypography.cardTitle),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: AppTypography.actionLink,
            ),
          ),
      ],
    );
  }
}
