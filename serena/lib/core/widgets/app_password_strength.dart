// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_spacing.dart';
import 'package:serena/core/theme/app_typography.dart';

/// Skor: panjang ≥ 8, huruf besar & kecil, angka, simbol.
class AppPasswordStrength extends StatelessWidget {
  const AppPasswordStrength({required this.password, super.key});

  final String password;

  /// 0 (kosong) sampai 4.
  static int score(String p) {
    if (p.isEmpty) return 0;
    var s = 0;
    if (p.length >= 8) s++;
    if (RegExp('[a-z]').hasMatch(p) && RegExp('[A-Z]').hasMatch(p)) s++;
    if (RegExp(r'\d').hasMatch(p)) s++;
    if (RegExp('[^A-Za-z0-9]').hasMatch(p)) s++;
    return s == 0 ? 1 : s;
  }

  static const _labels = ['', 'Weak', 'Fair', 'Good', 'Strong'];
  static const _colors = [
    AppColors.progressTrack,
    AppColors.accent,
    AppColors.secondary,
    AppColors.strengthGood,
    AppColors.strengthStrong,
  ];

  @override
  Widget build(BuildContext context) {
    final level = score(password);
    final color = _colors[level];

    return Row(
      children: [
        Expanded(
          child: Row(
            children: List.generate(4, (i) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i == 3 ? 0 : 4),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    height: AppSizes.strengthBarHeight,
                    decoration: BoxDecoration(
                      color: i < level ? color : AppColors.progressTrack,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 46,
          child: Text(
            _labels[level],
            textAlign: TextAlign.right,
            style: AppTypography.helper.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
