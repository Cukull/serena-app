// ignore_for_file: public_member_api_docs
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:serena/app/app_routes.dart';
import 'package:serena/controllers/auth_controller.dart';
import 'package:serena/controllers/focus_controller.dart';
import 'package:serena/controllers/main_controller.dart';
import 'package:serena/controllers/task_controller.dart';
import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_typography.dart';
import 'package:serena/core/widgets/app_header.dart';
import 'package:serena/core/widgets/app_ui.dart';
import 'package:serena/core/widgets/deadline_card.dart';
import 'package:serena/core/widgets/section_header.dart';
import 'package:serena/core/widgets/stat_card.dart';
import 'package:serena/models/focus_session.dart';
import 'package:serena/models/task.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SerenaBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                children: const [
                  _GreetingSection(),
                  SizedBox(height: 20),
                  _FocusHeroCard(),
                  SizedBox(height: 24),
                  _StatsSection(),
                  SizedBox(height: 24),
                  _DeadlineSection(),
                  SizedBox(height: 24),
                  _AgendaSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Greeting ──────────────────────────────────────────────────────────────────

class _GreetingSection extends StatelessWidget {
  const _GreetingSection();

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat pagi';
    if (hour < 15) return 'Selamat siang';
    if (hour < 18) return 'Selamat sore';
    return 'Selamat malam';
  }

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Obx(() {
      final name = auth.user.value?.displayName.split(' ').first ?? 'Kamu';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_greeting()}, $name 👋',
            style: AppTypography.h2.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 4),
          Text(
            'Yuk, buat hari ini produktif dan tenang.',
            style: AppTypography.subtitle,
          ),
        ],
      );
    });
  }
}

// ── Focus Hero Card ───────────────────────────────────────────────────────────

class _FocusHeroCard extends StatefulWidget {
  const _FocusHeroCard();

  @override
  State<_FocusHeroCard> createState() => _FocusHeroCardState();
}

class _FocusHeroCardState extends State<_FocusHeroCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _gradientCtrl;

  @override
  void initState() {
    super.initState();
    _gradientCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _gradientCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focus = Get.find<FocusController>();
    return Obx(() {
      final isRunning = focus.phase.value == FocusPhase.running;
      final isPaused = focus.phase.value == FocusPhase.paused;
      final isActive = isRunning || isPaused;

      return AnimatedBuilder(
        animation: _gradientCtrl,
        builder: (context, _) {
          final t = _gradientCtrl.value;

          // Menggerakkan arah rotasi dan alignment gradien
          final beginAlignment = Alignment(
            -1.0 + 0.35 * math.sin(t * math.pi),
            -1.0 + 0.35 * math.cos(t * math.pi),
          );
          final endAlignment = Alignment(
            1.0 - 0.35 * math.cos(t * math.pi),
            1.0 + 0.35 * math.sin(t * math.pi),
          );

          // Interpolasi warna gradien hidup (violet - biru - toska - zamrud)
          final color1 = Color.lerp(
            const Color(0xFF8B5CF6),
            const Color(0xFF6366F1),
            t,
          )!;
          final color2 = Color.lerp(
            const Color(0xFF5B8DEF),
            const Color(0xFF3B82F6),
            t,
          )!;
          final color3 = Color.lerp(
            const Color(0xFF2DD4BF),
            const Color(0xFF10B981),
            t,
          )!;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: beginAlignment,
                end: endAlignment,
                colors: [color1, color2, color3],
                stops: const [0.0, 0.52, 1.0],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: color2.withAlpha(90),
                  blurRadius: 26,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                children: [
                  // Stripe aksen latar bawah sesuai focus-banner.css
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 26,
                    height: 44,
                    child: Container(
                      color: Colors.white.withAlpha(16),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 24,
                    child: Container(
                      color: Colors.white.withAlpha(26),
                    ),
                  ),
                  // Glow radial bergerak halus
                  Positioned(
                    right: -20 + 16 * math.sin(t * 2 * math.pi),
                    top: -20 + 16 * math.cos(t * 2 * math.pi),
                    child: IgnorePointer(
                      child: Container(
                        width: 190,
                        height: 190,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withAlpha(85),
                              Colors.white.withAlpha(0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Status badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(35),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withAlpha(70),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (isRunning)
                                      _PulsingDot()
                                    else
                                      const Icon(
                                        LucideIcons.timer,
                                        size: 10,
                                        color: Colors.white,
                                      ),
                                    const SizedBox(width: 6),
                                    Text(
                                      isRunning
                                          ? 'Sedang fokus'
                                          : isPaused
                                              ? 'Dijeda'
                                              : 'Siap fokus',
                                      style: AppTypography.caption.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Timer display
                              Text(
                                isActive ? focus.formattedRemaining : '25:00',
                                style: AppTypography.h1.copyWith(
                                  color: Colors.white,
                                  fontSize: 36,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isActive ? focus.mode.value.label : 'Pomodoro',
                                style: AppTypography.body.copyWith(
                                  color: Colors.white.withAlpha(200),
                                ),
                              ),
                              const SizedBox(height: 14),
                              // CTA button
                              GestureDetector(
                                onTap: () => _handleFocusTap(focus),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(35),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withAlpha(85),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isRunning
                                            ? LucideIcons.pause
                                            : LucideIcons.play,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        isRunning
                                            ? 'Jeda Fokus'
                                            : isPaused
                                                ? 'Lanjutkan'
                                                : 'Mulai Fokus',
                                        style: AppTypography.button,
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(
                                        Icons.chevron_right_rounded,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Jam Pasir Animasi Bulak-Balik
                        const _AnimatedHourglassArt(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  void _handleFocusTap(FocusController focus) {
    if (focus.phase.value == FocusPhase.running) {
      focus.pause();
    } else if (focus.phase.value == FocusPhase.paused) {
      focus.resume();
    } else {
      focus.start(FocusMode.pomodoro, 25);
    }
  }
}

class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Opacity(
        opacity: _anim.value,
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFF7BE3D0),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _AnimatedHourglassArt extends StatefulWidget {
  const _AnimatedHourglassArt();

  @override
  State<_AnimatedHourglassArt> createState() => _AnimatedHourglassArtState();
}

class _AnimatedHourglassArtState extends State<_AnimatedHourglassArt>
    with TickerProviderStateMixin {
  late final AnimationController _cycleCtrl;
  late final AnimationController _tapSpinCtrl;

  @override
  void initState() {
    super.initState();
    // Siklus animasi jam pasir bulak-balik 8 detik
    _cycleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // Animasi putar cepat 360 derajat jika diketuk
    _tapSpinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _cycleCtrl.dispose();
    _tapSpinCtrl.dispose();
    super.dispose();
  }

  void _onTap() {
    if (!_tapSpinCtrl.isAnimating) {
      _tapSpinCtrl.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: Listenable.merge([_cycleCtrl, _tapSpinCtrl]),
        builder: (context, _) {
          final t = _cycleCtrl.value; // 0.0 - 1.0
          double angle;
          double sandLevel;
          var isFlipping = false;

          // Siklus jam pasir bulak-balik:
          // 0.00 - 0.42: Posisi tegak (angle 0), pasir turun habis
          // 0.42 - 0.50: Berputar balik 180° (0 ke pi)
          // 0.50 - 0.92: Posisi terbalik (angle pi), pasir turun habis
          // 0.92 - 1.00: Berputar balik ke posisi awal (pi ke 2*pi)
          if (t < 0.42) {
            angle = 0.0;
            sandLevel = t / 0.42;
          } else if (t < 0.50) {
            isFlipping = true;
            sandLevel = 1.0;
            final p = (t - 0.42) / 0.08;
            angle = Curves.easeInOutBack.transform(p) * math.pi;
          } else if (t < 0.92) {
            angle = math.pi;
            sandLevel = (t - 0.50) / 0.42;
          } else {
            isFlipping = true;
            sandLevel = 1.0;
            final p = (t - 0.92) / 0.08;
            angle = math.pi + Curves.easeInOutBack.transform(p) * math.pi;
          }

          final tapSpin =
              Curves.easeOutBack.transform(_tapSpinCtrl.value) * (2 * math.pi);
          final totalAngle = angle + tapSpin;

          return SizedBox(
            width: 68,
            height: 110,
            child: CustomPaint(
              painter: _HourglassPainter(
                angle: totalAngle,
                sandLevel: sandLevel,
                isFlipping: isFlipping,
                streamPhase: t * 45,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HourglassPainter extends CustomPainter {
  const _HourglassPainter({
    required this.angle,
    required this.sandLevel,
    required this.isFlipping,
    required this.streamPhase,
  });

  final double angle;
  final double sandLevel;
  final bool isFlipping;
  final double streamPhase;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;

    // 1. Kapsul Luar Kaca (Glass Capsule)
    final capsuleRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy), width: 50, height: 96),
      const Radius.circular(25),
    );

    // Latar belakang kaca transparan
    canvas.drawRRect(
      capsuleRect,
      Paint()
        ..color = Colors.white.withAlpha(35)
        ..style = PaintingStyle.fill,
    );

    // Garis luar kapsul kaca
    canvas.drawRRect(
      capsuleRect,
      Paint()
        ..color = Colors.white.withAlpha(160)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.6,
    );

    // Kilauan refleksi kaca di sisi kiri
    final shinePath = Path()
      ..moveTo(cx - 16, cy - 30)
      ..quadraticBezierTo(cx - 20, cy, cx - 16, cy + 30);
    canvas.drawPath(
      shinePath,
      Paint()
        ..color = Colors.white.withAlpha(85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round,
    );

    // 2. Konten Jam Pasir yang Berputar (Sand Bulbs)
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(angle);
    canvas.translate(-cx, -cy);

    // Shader gradien pasir ungu ke toska muda
    final sandShader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFC4A8FF), Color(0xFF7BE3D0)],
    ).createShader(Rect.fromLTWH(cx - 20, cy - 38, 40, 76));

    final sandPaint = Paint()
      ..shader = sandShader
      ..style = PaintingStyle.fill;

    // Pasir di tabung atas (mengalir turun / menyusut)
    final topRemaining = (1.0 - sandLevel).clamp(0.0, 1.0);
    if (topRemaining > 0.04) {
      final topSandPath = Path();
      final sandTopY = cy - 4 - 30 * topRemaining;
      const waistWidth = 6.0;
      final topWidth = 10.0 + 22.0 * topRemaining;

      topSandPath.moveTo(cx - topWidth / 2, sandTopY);
      topSandPath.lineTo(cx + topWidth / 2, sandTopY);
      topSandPath.quadraticBezierTo(
        cx + waistWidth / 2 + 2,
        cy - 4,
        cx + waistWidth / 2,
        cy - 2,
      );
      topSandPath.lineTo(cx - waistWidth / 2, cy - 2);
      topSandPath.quadraticBezierTo(
        cx - waistWidth / 2 - 2,
        cy - 4,
        cx - topWidth / 2,
        sandTopY,
      );
      topSandPath.close();
      canvas.drawPath(topSandPath, sandPaint);
    }

    // Pasir di tabung bawah (menumpuk / naik)
    final botFill = sandLevel.clamp(0.0, 1.0);
    if (botFill > 0.04) {
      final botSandPath = Path();
      final botSandH = 30.0 * botFill;
      final botBaseY = cy + 34;
      final botSurfaceY = botBaseY - botSandH;
      const baseWidth = 32.0;
      final surfaceWidth = 10.0 + 22.0 * botFill;

      botSandPath.moveTo(cx - surfaceWidth / 2, botSurfaceY);
      botSandPath.lineTo(cx + surfaceWidth / 2, botSurfaceY);
      botSandPath.quadraticBezierTo(
        cx + baseWidth / 2,
        botBaseY - 4,
        cx + baseWidth / 2 - 4,
        botBaseY,
      );
      botSandPath.lineTo(cx - baseWidth / 2 + 4, botBaseY);
      botSandPath.quadraticBezierTo(
        cx - baseWidth / 2,
        botBaseY - 4,
        cx - surfaceWidth / 2,
        botSurfaceY,
      );
      botSandPath.close();
      canvas.drawPath(botSandPath, sandPaint);
    }

    canvas.restore();

    // 3. Aliran Butiran Pasir Menetes (Selalu mengalir ke bawah ditarik gravitasi)
    if (!isFlipping && sandLevel < 0.96) {
      final streamPaint = Paint()
        ..color = const Color(0xFF7BE3D0).withAlpha(230)
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round;

      final streamTop = cy - 2;
      final streamBot = cy + 32 - (28.0 * sandLevel);
      if (streamBot > streamTop + 4) {
        const dashLength = 4.0;
        const dashSpace = 3.5;
        var y = streamTop + (streamPhase % (dashLength + dashSpace));
        while (y < streamBot) {
          final nextY = math.min(y + dashLength, streamBot);
          canvas.drawLine(Offset(cx, y), Offset(cx, nextY), streamPaint);
          y += dashLength + dashSpace;
        }
      }
    }
  }

  @override
  bool shouldRepaint(_HourglassPainter old) =>
      old.angle != angle ||
      old.sandLevel != sandLevel ||
      old.isFlipping != isFlipping ||
      old.streamPhase != streamPhase;
}

// ── Stats Section ─────────────────────────────────────────────────────────────

class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    final tasks = Get.find<TaskController>();
    final focus = Get.find<FocusController>();

    return Obx(() {
      final remaining = tasks.tasks
          .where(
            (t) =>
                t.status != TaskStatus.completed &&
                t.status != TaskStatus.cancelled,
          )
          .length;
      final completed =
          tasks.tasks.where((t) => t.status == TaskStatus.completed).length;

      // Focus minutes today
      final today = DateTime.now();
      final todayMinutes = focus.sessions.where((s) {
        final d = s.startedAt;
        return d.year == today.year &&
            d.month == today.month &&
            d.day == today.day;
      }).fold<int>(0, (sum, s) => sum + (s.actualMinutes ?? 0));

      final focusLabel = todayMinutes >= 60
          ? '${todayMinutes ~/ 60}j ${todayMinutes % 60}m'
          : '${todayMinutes}m';

      final hasTaskData = tasks.tasks.isNotEmpty;
      final displayRemaining = hasTaskData ? '$remaining' : '3';
      final displayFocus = todayMinutes > 0 ? focusLabel : '1j 40m';
      final displayCompleted = hasTaskData ? '$completed' : '2';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Statistik Harian',
            actionLabel: 'Lihat grafik →',
            onAction: () => Get.toNamed<void>(Routes.stats),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: _buildChecklistIcon(),
                  value: displayRemaining,
                  label: 'Tugas tersisa',
                  iconGradient: const LinearGradient(
                    colors: [Color(0xFF6FA8F5), Color(0xFFA66BF0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onTap: () => MainController.to.goTab(1),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  icon: const Icon(
                    LucideIcons.hourglass,
                    color: Color(0xFF6FA8F5),
                    size: 22,
                  ),
                  value: displayFocus,
                  label: 'Waktu fokus',
                  iconBg: const Color(0xFFEAF1FE),
                  iconColor: const Color(0xFF6FA8F5),
                  onTap: () => MainController.to.goTab(2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  icon: const Icon(
                    LucideIcons.check,
                    color: Colors.white,
                    size: 22,
                  ),
                  value: displayCompleted,
                  label: 'Selesai',
                  iconGradient: const LinearGradient(
                    colors: [Color(0xFF6C8CF0), Color(0xFF34C3A8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onTap: () => MainController.to.goTab(1),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildChecklistIcon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < 3; i++) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 14,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
            ],
          ),
          if (i < 2) const SizedBox(height: 3.5),
        ],
      ],
    );
  }
}

// ── Deadline Section ──────────────────────────────────────────────────────────

class _DeadlineSection extends StatelessWidget {
  const _DeadlineSection();

  @override
  Widget build(BuildContext context) {
    final tasks = Get.find<TaskController>();
    return Obx(() {
      final upcoming = tasks.tasks
          .where(
            (t) =>
                t.deadline != null &&
                t.status != TaskStatus.completed &&
                t.status != TaskStatus.cancelled,
          )
          .toList()
        ..sort((a, b) => a.deadline!.compareTo(b.deadline!));

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Tenggat Terdekat',
            actionLabel: 'Lihat semua →',
            onAction: () => MainController.to.goTab(1),
          ),
          const SizedBox(height: 12),
          if (upcoming.isNotEmpty)
            for (final task in upcoming.take(2)) ...[
              DeadlineCard.fromTask(
                task: task,
                onTap: () => Get.toNamed<void>(
                  Routes.plannerDetail.replaceFirst(':id', task.id),
                ),
              ),
              const SizedBox(height: 12),
            ]
          else
            DeadlineCard(
              title: 'Tugas Web Development',
              subtitle: 'Batas waktu: Hari ini, 23.59 WIB',
              onTap: () => MainController.to.goTab(1),
            ),
        ],
      );
    });
  }
}

// ── Agenda Section ────────────────────────────────────────────────────────────

class _AgendaSection extends StatelessWidget {
  const _AgendaSection();

  @override
  Widget build(BuildContext context) {
    final tasks = Get.find<TaskController>();
    return Obx(() {
      final today = DateTime.now();
      final todayTasks = tasks.tasks.where((t) {
        final d = t.deadline;
        if (d == null) return false;
        final local = d.toLocal();
        return local.year == today.year &&
            local.month == today.month &&
            local.day == today.day;
      }).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Agenda Hari Ini',
            actionLabel: 'Semua agenda →',
            onAction: () => MainController.to.goTab(1),
          ),
          const SizedBox(height: 12),
          if (todayTasks.isNotEmpty) ...[
            for (int i = 0; i < todayTasks.length; i++) ...[
              _buildTaskTimelineItem(todayTasks[i], i == todayTasks.length - 1),
            ],
          ] else ...[
            GestureDetector(
              onTap: () => MainController.to.goTab(1),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0x33B4C5FF)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A3C4682),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Belum ada tugas hari ini 🎉',
                      style: AppTypography.body.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ketuk untuk melihat agenda lainnya di Jadwal',
                      textAlign: TextAlign.center,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.webSlate,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      );
    });
  }

  Widget _buildTaskTimelineItem(Task task, bool isLast) {
    final deadline = task.deadline?.toLocal();
    final timeStr =
        deadline != null ? DateFormat('HH:mm').format(deadline) : 'Hari ini';

    final isUrgent = task.priority == TaskPriority.urgent;
    final dotColor =
        isUrgent ? const Color(0xFFE5646B) : const Color(0xFF6BAAFF);
    final accentBorderColor =
        isUrgent ? const Color(0xFFE5646B) : const Color(0xFF8B7CF8);
    final categoryColor =
        isUrgent ? const Color(0xFFE5646B) : const Color(0xFF4A8FE0);

    return _AgendaTimelineItem(
      time: timeStr,
      category: task.priority.label.toUpperCase(),
      categoryColor: categoryColor,
      dotColor: dotColor,
      accentBorderColor: accentBorderColor,
      title: task.title,
      meta: (task.description?.isNotEmpty ?? false) ? task.description : null,
      isLast: isLast,
      onTap: () => Get.toNamed<void>(
        Routes.plannerDetail.replaceFirst(':id', task.id),
      ),
      tags: [
        (
          label: task.priority.label,
          bg: isUrgent ? const Color(0x24FF383C) : const Color(0x1F6BAAFF),
          textColor:
              isUrgent ? const Color(0xFFE5646B) : const Color(0xFF4A8FE0),
        ),
        if (task.status == TaskStatus.completed)
          (
            label: 'Selesai',
            bg: const Color(0x1F34D399),
            textColor: const Color(0xFF059669),
          ),
      ],
    );
  }
}

class _AgendaTimelineItem extends StatelessWidget {
  const _AgendaTimelineItem({
    required this.time,
    required this.category,
    required this.categoryColor,
    required this.dotColor,
    required this.accentBorderColor,
    required this.title,
    required this.tags,
    this.meta,
    this.isLast = false,
    this.onTap,
  });

  final String time;
  final String category;
  final Color categoryColor;
  final Color dotColor;
  final Color accentBorderColor;
  final String title;
  final String? meta;
  final List<({String label, Color bg, Color textColor})> tags;
  final bool isLast;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!isLast)
          const Positioned(
            left: 50,
            top: 24,
            bottom: 0,
            child: SizedBox(
              width: 2,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0x66C8D7F5)),
              ),
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 38,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  time,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF1F3FA)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0F3C4682),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            width: 4.5,
                            child: Container(color: accentBorderColor),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 14,
                              right: 14,
                              top: 12,
                              bottom: 12,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category,
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                    color: categoryColor,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                    height: 1.25,
                                  ),
                                ),
                                if (meta != null) ...[
                                  const SizedBox(height: 3),
                                  Text(
                                    meta!,
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: [
                                    for (final tag in tags)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2.5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: tag.bg,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          tag.label,
                                          style: TextStyle(
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w700,
                                            color: tag.textColor,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
