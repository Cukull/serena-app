import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_typography.dart';
import 'package:serena/core/widgets/app_glass.dart';

class GlassStatCard extends StatelessWidget {
  const GlassStatCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(16),
    this.radius = 20,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return AppGlass(
      borderRadius: BorderRadius.circular(radius),
      color: AppColors.glassStat,
      borderColor: AppColors.glassStatBorder,
      borderWidth: 1.2,
      padding: padding,
      child: child,
    );
  }
}

class FocusHammockCard extends StatelessWidget {
  const FocusHammockCard({
    super.key,
    this.streakDays = 14,
    this.moodLabel = 'Great!',
    this.moodEmoji = '😊',
    this.borderRadius = 24,
  });
  final int streakDays;
  final String moodLabel;
  final String moodEmoji;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 739 / 346,
      child: LayoutBuilder(builder: (context, c) {
        final w = c.maxWidth;
        final h = c.maxHeight;
        final s = w / 739;

        final captionStyle = AppTypography.body.copyWith(
          fontSize: 19 * s,
          color: AppColors.statLabel,
        );
        final valueStyle = AppTypography.statValue.copyWith(
          fontSize: 31 * s,
          fontWeight: FontWeight.w800,
        );
        final emojiStyle = AppTypography.body.copyWith(fontSize: 28 * s);

        return Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            CustomPaint(painter: _HammockScenePainter()),
            Positioned(
              left: 14 * s,
              bottom: 36 * s,
              child: GlassStatCard(
                radius: 22 * s,
                padding: EdgeInsets.symmetric(
                  horizontal: 24 * s,
                  vertical: 16 * s,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Focus streak', style: captionStyle),
                    SizedBox(height: 4 * s),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🔥', style: emojiStyle),
                        SizedBox(width: 6 * s),
                        Text(
                          '$streakDays days',
                          style: valueStyle.copyWith(
                            color: AppColors.statPurple,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 18 * s,
              top: h * 0.12,
              child: GlassStatCard(
                radius: 22 * s,
                padding: EdgeInsets.symmetric(
                  horizontal: 24 * s,
                  vertical: 16 * s,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Today's mood", style: captionStyle),
                    SizedBox(height: 4 * s),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(moodEmoji, style: emojiStyle),
                        SizedBox(width: 8 * s),
                        Text(
                          moodLabel,
                          style: valueStyle.copyWith(color: AppColors.statSky),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _HammockScenePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 739;
    final sy = size.height / 346;
    Offset o(double x, double y) => Offset(x * sx, y * sy);
    Rect r(double l, double t, double rr, double b) =>
        Rect.fromLTRB(l * sx, t * sy, rr * sx, b * sy);

    canvas
      ..drawOval(
        r(60, 60, 680, 290),
        Paint()..color = AppColors.illusSoftOval.withAlpha(150),
      )
      ..drawOval(
        r(230, 290, 520, 322),
        Paint()..color = AppColors.illusGroundShadow.withAlpha(150),
      )
      ..drawOval(r(64, 34, 132, 118),
          Paint()..color = AppColors.illusTreeLeaf.withAlpha(210))
      ..drawOval(r(72, 34, 124, 92),
          Paint()..color = AppColors.illusTreeLeafDeep.withAlpha(200))
      ..drawRRect(
        RRect.fromRectAndRadius(r(87, 88, 108, 215), Radius.circular(10 * sx)),
        Paint()..color = AppColors.illusTreeTrunk,
      )
      ..drawOval(r(600, 34, 668, 118),
          Paint()..color = AppColors.illusTreeLeaf.withAlpha(120))
      ..drawRRect(
        RRect.fromRectAndRadius(
            r(625, 150, 646, 298), Radius.circular(10 * sx)),
        Paint()..color = AppColors.illusTreeTrunk,
      );
    final rope = Paint()
      ..color = AppColors.illusRope
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6 * sx
      ..strokeCap = StrokeCap.round;
    final p1 = Path()
      ..moveTo(108 * sx, 140 * sy)
      ..quadraticBezierTo(170 * sx, 175 * sy, 275 * sx, 168 * sy);
    final p2 = Path()
      ..moveTo(500 * sx, 168 * sy)
      ..quadraticBezierTo(580 * sx, 172 * sy, 630 * sx, 142 * sy);
    _dashPath(canvas, p1, rope, dash: 7 * sx, gap: 6 * sx);
    _dashPath(canvas, p2, rope, dash: 7 * sx, gap: 6 * sx);

    final bodyRect = r(250, 166, 482, 216);
    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, Radius.circular(25 * sy)),
      Paint()
        ..shader = const LinearGradient(
          colors: [AppColors.illusBody, AppColors.illusBodyLight],
        ).createShader(bodyRect),
    );

    final armRect = r(384, 186, 468, 206);
    canvas.drawRRect(
      RRect.fromRectAndRadius(armRect, Radius.circular(10 * sy)),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [AppColors.illusSkinFade, AppColors.illusSkin],
        ).createShader(armRect),
    );

    final headC = o(483, 174);
    final headR = 28 * sx;
    canvas
      ..drawCircle(headC, headR, Paint()..color = AppColors.illusSkin)
      ..drawArc(
        Rect.fromCircle(center: headC, radius: headR),
        math.pi * 1.02,
        math.pi * 0.85,
        true,
        Paint()..color = AppColors.illusHair,
      );
    final face = Paint()
      ..color = AppColors.illusFace
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * sx
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawLine(o(472, 178), o(479, 178), face)
      ..drawLine(o(492, 178), o(499, 178), face)
      ..drawArc(
          Rect.fromCenter(center: o(487, 187), width: 16 * sx, height: 9 * sx),
          0.2,
          math.pi * 0.7,
          false,
          face)
      ..save()
      ..translate(318 * sx, 196 * sy)
      ..rotate(0.12);
    final bookRect =
        Rect.fromCenter(center: Offset.zero, width: 82 * sx, height: 62 * sy);
    canvas.drawRRect(
      RRect.fromRectAndRadius(bookRect, Radius.circular(8 * sx)),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.illusBook, AppColors.illusBookLight],
        ).createShader(bookRect),
    );
    final line = Paint()
      ..color = AppColors.illusBookLine
      ..strokeWidth = 3 * sx
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 3; i++) {
      final y = -14 * sy + i * 12 * sy;
      canvas.drawLine(
          Offset(-24 * sx, y), Offset((i == 2 ? 6 : 24) * sx, y), line);
    }
    canvas.restore();
    _sparkle(canvas, o(167, 121), 9 * sx, AppColors.illusSparkle);
    _sparkle(canvas, o(558, 237), 5 * sx, AppColors.illusMint);
    final moon = Path()
      ..addArc(Rect.fromCircle(center: o(156, 162), radius: 13 * sx),
          math.pi * 0.2, math.pi * 1.1);
    canvas
      ..drawCircle(
          o(38, 187), 3.5 * sx, Paint()..color = AppColors.illusDotLavender)
      ..drawCircle(o(660, 0), 5 * sx, Paint()..color = AppColors.illusDotBlue)
      ..drawPath(
        moon,
        Paint()
          ..color = AppColors.illusMoon
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3 * sx
          ..strokeCap = StrokeCap.round,
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StreakMoodDeskCard extends StatelessWidget {
  final int streakDays;
  final double moodScore;
  final String moodText;
  final double borderRadius;

  const StreakMoodDeskCard({
    super.key,
    this.streakDays = 14,
    this.moodScore = 8.4,
    this.moodText = 'Feeling good',
    this.borderRadius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 592 / 316,
      child: LayoutBuilder(builder: (context, c) {
        final w = c.maxWidth;
        final s = w / 592;

        final titleStyle = AppTypography.body.copyWith(
          fontSize: 17 * s,
          color: AppColors.statTitle,
        );
        final captionStyle = AppTypography.body.copyWith(
          fontSize: 15 * s,
          color: AppColors.statLabel,
        );
        final valueStyle = AppTypography.statValue.copyWith(
          fontSize: 32 * s,
          fontWeight: FontWeight.w800,
        );

        return Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            CustomPaint(painter: _DeskScenePainter()),
            Positioned(
              left: 58 * s,
              top: 20 * s,
              child: GlassStatCard(
                radius: 18 * s,
                padding: EdgeInsets.fromLTRB(16 * s, 14 * s, 22 * s, 14 * s),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _IconBox(
                          emoji: '✅',
                          size: 30 * s,
                          color: AppColors.statIconGreenTint,
                        ),
                        SizedBox(width: 8 * s),
                        Text('Streak', style: titleStyle),
                      ],
                    ),
                    SizedBox(height: 6 * s),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$streakDays',
                          style:
                              valueStyle.copyWith(color: AppColors.statGreen),
                        ),
                        SizedBox(width: 6 * s),
                        Text(
                          '🔥',
                          style: AppTypography.body.copyWith(fontSize: 26 * s),
                        ),
                      ],
                    ),
                    Text('days consistent', style: captionStyle),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 50 * s,
              top: 20 * s,
              child: GlassStatCard(
                radius: 18 * s,
                padding: EdgeInsets.fromLTRB(16 * s, 14 * s, 22 * s, 14 * s),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _IconBox(
                          emoji: '😊',
                          size: 30 * s,
                          color: AppColors.statIconSkyTint,
                        ),
                        SizedBox(width: 8 * s),
                        Text('Mood', style: titleStyle),
                      ],
                    ),
                    SizedBox(height: 6 * s),
                    Text(
                      moodScore.toStringAsFixed(1),
                      style: valueStyle.copyWith(color: AppColors.statSky),
                    ),
                    SizedBox(height: 2 * s),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 11 * s,
                          height: 11 * s,
                          decoration: const BoxDecoration(
                            color: AppColors.statGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6 * s),
                        Text(moodText, style: captionStyle),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _IconBox extends StatelessWidget {
  final String emoji;
  final double size;
  final Color color;
  const _IconBox(
      {required this.emoji, required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Text(
        emoji,
        style: AppTypography.body.copyWith(fontSize: size * 0.58),
      ),
    );
  }
}

class _DeskScenePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 592;
    final sy = size.height / 316;
    Offset o(double x, double y) => Offset(x * sx, y * sy);
    Rect r(double l, double t, double rr, double b) =>
        Rect.fromLTRB(l * sx, t * sy, rr * sx, b * sy);
    RRect rr(double l, double t, double rt, double b, double rad) =>
        RRect.fromRectAndRadius(r(l, t, rt, b), Radius.circular(rad * sx));

    canvas
      ..drawCircle(
        o(530, 150),
        130 * sx,
        Paint()
          ..color = AppColors.illusRing.withAlpha(170)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4 * sx,
      )
      ..drawOval(r(462, 98, 502, 128),
          Paint()..color = AppColors.illusMint.withAlpha(90))
      ..drawOval(r(104, 118, 146, 146),
          Paint()..color = AppColors.illusBlush.withAlpha(70))
      ..drawRRect(
          rr(108, 208, 497, 220, 6), Paint()..color = AppColors.illusDesk)
      ..drawRRect(
          rr(153, 220, 165, 266, 6), Paint()..color = AppColors.illusDeskLeg)
      ..drawRRect(
          rr(440, 220, 452, 266, 6), Paint()..color = AppColors.illusDeskLeg)
      ..drawRRect(
        rr(278, 98, 330, 150, 22),
        Paint()..color = AppColors.illusTorso,
      );
    final arm = Paint()
      ..color = AppColors.illusSleeve
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12 * sx
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawPath(
          Path()
            ..moveTo(282 * sx, 120 * sy)
            ..quadraticBezierTo(250 * sx, 128 * sy, 252 * sx, 150 * sy),
          arm)
      ..drawPath(
          Path()
            ..moveTo(326 * sx, 120 * sy)
            ..quadraticBezierTo(356 * sx, 126 * sy, 352 * sx, 150 * sy),
          arm);
    final headC = o(303, 72);
    final headR = 25 * sx;
    canvas.drawCircle(headC, headR, Paint()..color = AppColors.illusSkin);
    final band = Paint()
      ..color = AppColors.illusHeadphone
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6 * sx
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawArc(Rect.fromCircle(center: headC, radius: headR + 2 * sx),
          math.pi * 1.05, math.pi * 0.9, false, band)
      ..drawRRect(
          rr(272, 62, 282, 88, 5), Paint()..color = AppColors.illusHeadphoneCup)
      ..drawRRect(rr(324, 62, 334, 88, 5),
          Paint()..color = AppColors.illusHeadphoneCup);
    final face = Paint()
      ..color = AppColors.illusFace
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * sx
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawCircle(o(294, 72), 1.6 * sx, Paint()..color = AppColors.illusFace)
      ..drawCircle(o(312, 72), 1.6 * sx, Paint()..color = AppColors.illusFace)
      ..drawArc(
          Rect.fromCenter(center: o(303, 82), width: 16 * sx, height: 9 * sx),
          0.2,
          math.pi * 0.7,
          false,
          face)
      ..drawRRect(
        rr(230, 142, 390, 208, 8),
        Paint()..color = AppColors.illusScreen,
      )
      ..drawRRect(
        rr(230, 142, 390, 208, 8),
        Paint()
          ..color = AppColors.illusScreenBorder
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5 * sx,
      );
    final lp = Paint()
      ..strokeWidth = 3.5 * sx
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawLine(
          o(242, 156), o(300, 156), lp..color = AppColors.illusLineViolet)
      ..drawLine(o(242, 166), o(312, 166), lp..color = AppColors.illusLineBlue)
      ..drawLine(o(242, 176), o(290, 176), lp..color = AppColors.illusLineGreen)
      ..drawLine(
          o(242, 186), o(306, 186), lp..color = AppColors.illusLineViolet)
      ..drawLine(o(242, 196), o(284, 196), lp..color = AppColors.illusLineFaint)
      ..drawRRect(
          rr(326, 152, 382, 200, 6), Paint()..color = AppColors.illusChartPanel)
      ..drawRRect(
          rr(334, 178, 343, 194, 2), Paint()..color = AppColors.statPurple)
      ..drawRRect(
          rr(349, 164, 358, 194, 2), Paint()..color = AppColors.illusBarBlue)
      ..drawRRect(
          rr(364, 158, 373, 194, 2), Paint()..color = AppColors.illusBarGreen)
      ..drawRRect(
          rr(222, 206, 398, 212, 3), Paint()..color = AppColors.illusLaptopBase)
      ..save()
      ..translate(178 * sx, 192 * sy)
      ..rotate(-0.06);
    final bk =
        Rect.fromCenter(center: Offset.zero, width: 78 * sx, height: 28 * sy);
    canvas
      ..drawRRect(
        RRect.fromRectAndRadius(bk, Radius.circular(6 * sx)),
        Paint()
          ..shader = const LinearGradient(
            colors: [AppColors.statPurple, AppColors.illusBook],
          ).createShader(bk),
      )
      ..restore()
      ..drawRRect(
          rr(103, 162, 143, 202, 9), Paint()..color = AppColors.illusIconTile)
      ..drawRRect(
          rr(113, 183, 120, 193, 1.5), Paint()..color = AppColors.illusBarBlue)
      ..drawRRect(
          rr(123, 176, 130, 193, 1.5), Paint()..color = AppColors.illusRed)
      ..drawRRect(
          rr(133, 170, 140, 193, 1.5), Paint()..color = AppColors.illusBarGreen)
      ..drawRRect(
          rr(437, 178, 478, 210, 9), Paint()..color = AppColors.illusMug)
      ..drawArc(
        Rect.fromCenter(center: o(480, 194), width: 20 * sx, height: 18 * sy),
        -math.pi / 2,
        math.pi,
        false,
        Paint()
          ..color = AppColors.illusMug
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4 * sx,
      );
    final steam = Paint()
      ..color = AppColors.illusRope
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2 * sx
      ..strokeCap = StrokeCap.round;
    for (final x in [449.0, 462.0]) {
      canvas.drawPath(
          Path()
            ..moveTo(x * sx, 170 * sy)
            ..quadraticBezierTo((x + 5) * sx, 162 * sy, x * sx, 154 * sy),
          steam);
    }
    canvas.drawCircle(o(512, 226), 3.5 * sx,
        Paint()..color = AppColors.statGreen.withAlpha(200));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void _dashPath(Canvas canvas, Path path, Paint paint,
    {double dash = 7, double gap = 6}) {
  for (final metric in path.computeMetrics()) {
    double d = 0;
    while (d < metric.length) {
      final end = math.min(d + dash, metric.length);
      canvas.drawPath(metric.extractPath(d, end), paint);
      d += dash + gap;
    }
  }
}

void _sparkle(Canvas canvas, Offset c, double r, Color color) {
  final p = Path()
    ..moveTo(c.dx, c.dy - r)
    ..quadraticBezierTo(c.dx, c.dy, c.dx + r, c.dy)
    ..quadraticBezierTo(c.dx, c.dy, c.dx, c.dy + r)
    ..quadraticBezierTo(c.dx, c.dy, c.dx - r, c.dy)
    ..quadraticBezierTo(c.dx, c.dy, c.dx, c.dy - r)
    ..close();
  canvas.drawPath(p, Paint()..color = color);
}
