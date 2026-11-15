// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';

import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_typography.dart';

/// Kartu statistik: ikon, angka besar, label.
/// Matches stat-card component in serena-web home/jadwal/statistik pages.
class StatCard extends StatelessWidget {
  const StatCard({
    required this.icon,
    required this.value,
    required this.label,
    this.iconBg = AppColors.tileBlue,
    this.iconColor = AppColors.secondary,
    this.valueColor = AppColors.textPrimary,
    this.onTap,
    super.key,
  });

  final Widget icon;
  final String value;
  final String label;
  final Color iconBg;
  final Color iconColor;
  final Color valueColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.glassBorderCard),
          boxShadow: const [
            BoxShadow(
              color: Color(0x123C4682),
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconTheme(
                data: IconThemeData(color: iconColor, size: 20),
                child: icon,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: AppTypography.statBig.copyWith(color: valueColor),
            ),
            const SizedBox(height: 2),
            Text(label, style: AppTypography.subtitle),
          ],
        ),
      ),
    );
  }
}
