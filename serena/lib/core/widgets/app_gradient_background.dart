// ignore_for_file: public_member_api_docs

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_spacing.dart';

class AppGradientBackground extends StatelessWidget {
  const AppGradientBackground({
    required this.child,
    super.key,
    this.gradient = AppColors.bgLogin,
    this.showBlobs = true,
  });

  const AppGradientBackground.login({
    required this.child,
    super.key,
    this.showBlobs = true,
  }) : gradient = AppColors.bgLogin;

  const AppGradientBackground.signUp({
    required this.child,
    super.key,
    this.showBlobs = true,
  }) : gradient = AppColors.bgSignUp;

  const AppGradientBackground.onboarding({
    required this.child,
    super.key,
    this.showBlobs = true,
  }) : gradient = AppColors.bgOnboarding;

  final Widget child;
  final LinearGradient gradient;
  final bool showBlobs;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: gradient),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (showBlobs) ...[
            Positioned(
              top: -70,
              right: -60,
              child: _Blob(
                size: 240,
                color: AppColors.primary.withAlpha(71),
              ),
            ),
            Positioned(
              top: 260,
              left: -90,
              child: _Blob(
                size: 220,
                color: AppColors.secondary.withAlpha(51),
              ),
            ),
            Positioned(
              bottom: -80,
              right: -40,
              child: _Blob(
                size: 240,
                color: AppColors.success.withAlpha(46),
              ),
            ),
          ],
          child,
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: AppBlur.blob,
          sigmaY: AppBlur.blob,
          tileMode: TileMode.decal,
        ),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
      ),
    );
  }
}
