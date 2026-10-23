// ignore_for_file: public_member_api_docs

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:serena/app/app_assets.dart';
import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_spacing.dart';
import 'package:serena/core/theme/app_typography.dart';
import 'package:serena/core/widgets/app_glass.dart';

/// Ikon aplikasi (rounded square) dari [AppAssets.appIcon].
class AppLogoIcon extends StatelessWidget {
  const AppLogoIcon({super.key, this.size = AppSizes.logoBox});

  final double size;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(size * 0.3);

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: AppColors.chipBorderSecondary),
        boxShadow: AppShadows.logo,
        gradient: const LinearGradient(colors: [
          AppColors.chipBorderPrimary,
          AppColors.chipBorderSecondary,
        ]),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Image.asset(
          AppAssets.appIcon,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => ColoredBox(
            color: AppColors.primaryTint,
            child: Icon(
              Icons.spa_rounded,
              size: size * 0.5,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.small = false,
    this.showBox = true,
    this.showTagline = false,
    this.tagline = 'BALANCE YOUR MIND, STUDY & LIFE.',
    this.icon,
    this.boxChild,
    this.nameStart = 'Seren',
    this.nameAccent = 'à',
  });

  final bool small;
  final bool showBox;
  final bool showTagline;
  final String tagline;

  final IconData? icon;

  final Widget? boxChild;
  final String nameStart;
  final String nameAccent;

  Widget _buildBox(double size) {
    if (boxChild == null && icon == null) return AppLogoIcon(size: size);

    return AppGlass(
      blur: AppBlur.logo,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      color: AppColors.glassBadge,
      borderColor: AppColors.glassBorder,
      shadows: AppShadows.logo,
      width: size,
      height: size,
      child: Center(
        child:
            boxChild ?? Icon(icon, size: size * 0.5, color: AppColors.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final boxSize = small ? AppSizes.logoBoxSmall : AppSizes.logoBox;
    final baseStyle = small ? AppTypography.logoSmall : AppTypography.logo;
    final accentStyle = baseStyle.copyWith(
      fontStyle: FontStyle.italic,
      color: AppColors.primary,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showBox) ...[
              _buildBox(boxSize),
              const SizedBox(width: AppSpacing.fieldGap),
            ],
            Text.rich(
              TextSpan(
                style: baseStyle,
                children: [
                  TextSpan(text: nameStart),
                  TextSpan(text: nameAccent, style: accentStyle),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        if (showTagline) ...[
          const SizedBox(height: 6),
          Text(
            tagline,
            textAlign: TextAlign.center,
            style: AppTypography.tagline,
          ),
        ],
      ],
    );
  }
}

class AppLogoStacked extends StatelessWidget {
  const AppLogoStacked({
    super.key,
    this.iconSize = 96,
    this.name = 'SERENA',
  });

  final double iconSize;
  final String name;

  @override
  Widget build(BuildContext context) {
    final ring = iconSize * 1.7;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: ring,
          height: ring,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              _Circle(size: ring, border: AppColors.logoRing),
              _Circle(
                size: ring * 0.84,
                fill: AppColors.glassOption,
                border: AppColors.glassBorder,
              ),
              AppLogoIcon(size: iconSize),
              Positioned(
                left: ring * 0.08,
                bottom: ring * 0.24,
                child: const _Dot(size: 5, color: AppColors.illusDotBlue),
              ),
              Positioned(
                right: ring * 0.02,
                top: ring * 0.3,
                child: const _Dot(size: 6, color: AppColors.illusDotLavender),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _Wordmark(name: name),
      ],
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.wordmark;
    final spacing = style.letterSpacing ?? 0;

    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Padding kiri menyeimbangkan letterSpacing di huruf terakhir.
              Padding(
                padding: EdgeInsets.only(left: spacing),
                child: Text(
                  name,
                  style: style,
                  textAlign: TextAlign.center,
                  softWrap: false,
                ),
              ),
              Positioned(
                right: spacing * 0.3,
                top: -2,
                child: const _Dot(size: 6, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 8,
            width: double.infinity,
            child: CustomPaint(painter: _WavePainter()),
          ),
        ],
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const periods = 3;
    final mid = size.height / 2;
    final amp = mid - 1;

    final path = Path()..moveTo(0, mid);
    for (var x = 0.0; x <= size.width; x++) {
      final y = mid + amp * math.sin(x / size.width * periods * 2 * math.pi);
      path.lineTo(x, y);
    }

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round
        ..shader = AppColors.primaryGradient.createShader(Offset.zero & size),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Circle extends StatelessWidget {
  const _Circle({required this.size, required this.border, this.fill});

  final double size;
  final Color border;
  final Color? fill;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fill,
        border: Border.all(color: border),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
