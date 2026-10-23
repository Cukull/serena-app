// ignore_for_file: public_member_api_docs

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_spacing.dart';

/// Shadow digambar di luar clip, jadi tidak terpotong oleh blur.
class AppGlass extends StatelessWidget {
  const AppGlass({
    required this.child,
    super.key,
    this.blur = AppBlur.card,
    this.borderRadius,
    this.color = AppColors.glassCard,
    this.borderColor = AppColors.glassBorderCard,
    this.borderWidth = 1,
    this.shadows = const [],
    this.padding,
    this.width,
    this.height,
  });

  final Widget child;
  final double blur;

  /// Default: [AppRadius.cardRadius].
  final BorderRadius? borderRadius;
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final List<BoxShadow> shadows;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppRadius.cardRadius;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(borderRadius: radius, boxShadow: shadows),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: color,
              borderRadius: radius,
              border: Border.all(color: borderColor, width: borderWidth),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
