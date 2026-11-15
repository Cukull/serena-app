// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';

import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_typography.dart';

/// Kartu statistik harian: komponen tengah rata (centered), ukuran seragam.
/// Sesuai daily-stats component di serena-web.
class StatCard extends StatelessWidget {
  const StatCard({
    required this.icon,
    required this.value,
    required this.label,
    this.iconBg = AppColors.tileBlue,
    this.iconGradient,
    this.iconColor = AppColors.secondary,
    this.valueColor = AppColors.textPrimary,
    this.onTap,
    super.key,
  });

  final Widget icon;
  final String value;
  final String label;
  final Color iconBg;
  final Gradient? iconGradient;
  final Color iconColor;
  final Color valueColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 132,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconGradient == null ? iconBg : null,
                gradient: iconGradient,
                borderRadius: BorderRadius.circular(13),
              ),
              child: IconTheme(
                data: IconThemeData(color: iconColor, size: 22),
                child: icon,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.statBig.copyWith(
                color: valueColor,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.subtitle.copyWith(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
