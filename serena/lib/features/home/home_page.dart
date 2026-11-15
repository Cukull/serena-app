// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:serena/app/app_routes.dart';
import 'package:serena/controllers/auth_controller.dart';
import 'package:serena/controllers/focus_controller.dart';
import 'package:serena/controllers/main_controller.dart';
import 'package:serena/controllers/task_controller.dart';
import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_typography.dart';
import 'package:serena/core/widgets/agenda_item.dart';
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
      final name = auth.user.value?.displayName?.split(' ').first ?? 'Kamu';
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

class _FocusHeroCard extends StatelessWidget {
  const _FocusHeroCard();

  @override
  Widget build(BuildContext context) {
    final focus = Get.find<FocusController>();
    return Obx(() {
      final isRunning = focus.phase.value == FocusPhase.running;
      final isPaused = focus.phase.value == FocusPhase.paused;
      final isActive = isRunning || isPaused;

      return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF5BA8F5), Color(0xFF7C6BF0), Color(0xFF2BAE8E)],
            stops: [0, 0.55, 1],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(80),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative radial glow
            Positioned(
              right: -30,
              top: -30,
              child: IgnorePointer(
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Color(0x40FFFFFF), Color(0x00FFFFFF)],
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
                            color: Colors.white.withAlpha(30),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withAlpha(60),
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
                          isActive
                              ? focus.formattedRemaining
                              : '25:00',
                          style: AppTypography.h1.copyWith(
                            color: Colors.white,
                            fontSize: 36,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isActive
                              ? focus.mode.value.label
                              : 'Pomodoro',
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
                              color: Colors.white.withAlpha(30),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withAlpha(80),
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
                  const SizedBox(width: 12),
                  // Hourglass artwork
                  _HourglassArt(progress: isActive ? focus.progress : 0),
                ],
              ),
            ),
          ],
        ),
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

class _HourglassArt extends StatelessWidget {
  const _HourglassArt({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 90,
      child: CustomPaint(painter: _HourglassPainter(progress: progress)),
    );
  }
}

class _HourglassPainter extends CustomPainter {
  _HourglassPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Outline capsule
    final capsulePaint = Paint()
      ..color = Colors.white.withAlpha(50)
      ..style = PaintingStyle.fill;
    final capsuleBorder = Paint()
      ..color = Colors.white.withAlpha(120)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final rr = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.1, h * 0.05, w * 0.8, h * 0.9),
      Radius.circular(w * 0.4),
    );
    canvas.drawRRect(rr, capsulePaint);
    canvas.drawRRect(rr, capsuleBorder);

    // Sand gradient paint
    final sandPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFC4A8FF), Color(0xFF7BE3D0)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    // Upper sand (decreases as progress increases)
    final topSandH = h * 0.4 * (1 - progress);
    if (topSandH > 0) {
      final topPath = Path()
        ..moveTo(w * 0.15, h * 0.1)
        ..lineTo(w * 0.85, h * 0.1)
        ..lineTo(w * 0.5, h * 0.1 + topSandH)
        ..close();
      canvas.drawPath(topPath, sandPaint);
    }

    // Lower sand (increases as progress increases)
    final botSandH = h * 0.4 * progress;
    if (botSandH > 0) {
      final botPath = Path()
        ..moveTo(w * 0.15, h * 0.9)
        ..lineTo(w * 0.85, h * 0.9)
        ..lineTo(w * 0.5, h * 0.9 - botSandH)
        ..close();
      canvas.drawPath(botPath, sandPaint);
    }

    // Sand stream line
    final streamPaint = Paint()
      ..color = const Color(0xFF7BE3D0).withAlpha(180)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.5, h * 0.45),
      Offset(w * 0.5, h * 0.55),
      streamPaint,
    );
  }

  @override
  bool shouldRepaint(_HourglassPainter old) => old.progress != progress;
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
      final completed = tasks.tasks
          .where((t) => t.status == TaskStatus.completed)
          .length;

      // Focus minutes today
      final today = DateTime.now();
      final todayMinutes = focus.sessions
          .where((s) {
            final d = s.startedAt;
            return d.year == today.year &&
                d.month == today.month &&
                d.day == today.day;
          })
          .fold<int>(0, (sum, s) => sum + (s.actualMinutes ?? 0));

      final focusLabel = todayMinutes >= 60
          ? '${todayMinutes ~/ 60}j ${todayMinutes % 60}m'
          : '${todayMinutes}m';

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
                  icon: const Icon(LucideIcons.listChecks),
                  value: '$remaining',
                  label: 'Tugas tersisa',
                  iconBg: AppColors.tileViolet,
                  iconColor: AppColors.primary,
                  valueColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  icon: const Icon(LucideIcons.timer),
                  value: focusLabel,
                  label: 'Waktu fokus',
                  iconBg: AppColors.tileBlue,
                  iconColor: AppColors.secondary,
                  valueColor: AppColors.secondary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  icon: const Icon(LucideIcons.checkCircle),
                  value: '$completed',
                  label: 'Selesai',
                  iconBg: AppColors.tileGreen,
                  iconColor: AppColors.success,
                  valueColor: AppColors.accentDark,
                ),
              ),
            ],
          ),
        ],
      );
    });
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

      final shown = upcoming.take(2).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Tenggat Terdekat',
            actionLabel: 'Lihat semua →',
            onAction: () => MainController.to.goTab(1),
          ),
          const SizedBox(height: 12),
          if (shown.isEmpty)
            _EmptyState(message: 'Tidak ada tenggat mendekat 🎉')
          else
            for (final task in shown) ...[
              DeadlineCard(
                task: task,
                onTap: () => Get.toNamed<void>(
                  Routes.plannerDetail.replaceFirst(':id', task.id),
                ),
              ),
              const SizedBox(height: 12),
            ],
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
          const SectionHeader(title: 'Agenda Hari Ini'),
          const SizedBox(height: 12),
          if (todayTasks.isEmpty)
            _EmptyState(message: 'Tidak ada agenda hari ini 🌟')
          else
            for (final task in todayTasks) ...[
              AgendaItem(
                task: task,
                onTap: () => Get.toNamed<void>(
                  Routes.plannerDetail.replaceFirst(':id', task.id),
                ),
              ),
              const SizedBox(height: 10),
            ],
        ],
      );
    });
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorderCard),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: AppTypography.subtitle,
      ),
    );
  }
}
