// ignore_for_file: public_member_api_docs
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
              progress: 0.58,
              badges: const [
                (label: 'Segera', isUrgent: true),
                (label: 'LMS', isUrgent: false),
              ],
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
            const _AgendaTimelineItem(
              time: '09:00',
              category: 'KULIAH',
              categoryColor: Color(0xFF4A8FE0),
              dotColor: Color(0xFF6BAAFF),
              accentBorderColor: Color(0xFF8B7CF8),
              title: 'Kuliah UI/UX Design',
              meta: '09:00–11:00 AM · Room E12',
              tags: [
                (
                  label: 'Design',
                  bg: Color(0x1F6BAAFF),
                  textColor: Color(0xFF4A8FE0),
                ),
                (
                  label: 'Sem. 6',
                  bg: Color(0x1FA78BFA),
                  textColor: Color(0xFF8B7CF8),
                ),
              ],
            ),
            const _AgendaTimelineItem(
              time: '09:00',
              category: 'TUGAS',
              categoryColor: Color(0xFFE5646B),
              dotColor: Color(0xFFE5646B),
              accentBorderColor: Color(0xFFE5646B),
              title: 'Kumpulkan Tugas Web Development',
              tags: [
                (
                  label: 'Segera',
                  bg: Color(0x24FF383C),
                  textColor: Color(0xFFE5646B),
                ),
                (
                  label: 'LMS',
                  bg: Color(0x1FA78BFA),
                  textColor: Color(0xFF8B7CF8),
                ),
              ],
              isLast: true,
            ),
          ],
        ],
      );
    });
  }

  Widget _buildTaskTimelineItem(Task task, bool isLast) {
    final deadline = task.deadline?.toLocal();
    final timeStr = deadline != null
        ? DateFormat('HH:mm').format(deadline)
        : 'Hari ini';

    final isUrgent = task.priority == TaskPriority.urgent;
    final dotColor = isUrgent
        ? const Color(0xFFE5646B)
        : const Color(0xFF6BAAFF);
    final accentBorderColor = isUrgent
        ? const Color(0xFFE5646B)
        : const Color(0xFF8B7CF8);
    final categoryColor = isUrgent
        ? const Color(0xFFE5646B)
        : const Color(0xFF4A8FE0);

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
                                        borderRadius: BorderRadius.circular(8),
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
