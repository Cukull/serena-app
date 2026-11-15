// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:serena/app/app_routes.dart';
import 'package:serena/controllers/focus_controller.dart';
import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_typography.dart';
import 'package:serena/core/widgets/app_ui.dart';
import 'package:serena/models/focus_session.dart';

class FocusPage extends StatelessWidget {
  const FocusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SerenaBackground(
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
          children: [
            Text('Sesi Fokus 🎯', style: AppTypography.h2),
            const SizedBox(height: 4),
            Text(
              'Pilih mode sesuai kebutuhanmu.',
              style: AppTypography.subtitle,
            ),
            const SizedBox(height: 20),
            // Active focus card (same style as home hero but larger)
            const _ActiveFocusCard(),
            const SizedBox(height: 24),
            // Mode cards
            Text('Pilih Mode', style: AppTypography.cardTitle),
            const SizedBox(height: 12),
            _ModeCard(
              icon: LucideIcons.timer,
              title: 'Pomodoro',
              subtitle: '25 mnt fokus · 5 mnt istirahat',
              description: 'Teknik klasik untuk produktivitas tinggi',
              gradient: AppColors.primaryGradient,
              onTap: () => Get.toNamed<void>(Routes.pomodoro),
            ),
            const SizedBox(height: 12),
            _ModeCard(
              icon: LucideIcons.brain,
              title: 'Deep Focus',
              subtitle: 'Durasi bebas, tanpa interupsi',
              description: 'Untuk tugas besar yang butuh konsentrasi penuh',
              gradient: const LinearGradient(
                colors: [Color(0xFF5B8DEF), Color(0xFF2BAE8E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              onTap: () => Get.toNamed<void>(Routes.deepFocus),
            ),
            const SizedBox(height: 12),
            _ModeCard(
              icon: LucideIcons.shield,
              title: 'Exam Mode',
              subtitle: '90 menit sesi panjang',
              description: 'Mode ujian dengan blokir gangguan maksimal',
              gradient: const LinearGradient(
                colors: [Color(0xFFE5646B), Color(0xFFFFB88C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              onTap: () => Get.toNamed<void>(Routes.examMode),
            ),
            const SizedBox(height: 20),
            // History button
            GestureDetector(
              onTap: () => Get.toNamed<void>(Routes.focusHistory),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.glassBorderCard),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.history, size: 18, color: AppColors.textMuted),
                    const SizedBox(width: 8),
                    Text('Riwayat Fokus', style: AppTypography.buttonSecondary),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Active Focus Card ─────────────────────────────────────────────────────────

class _ActiveFocusCard extends StatelessWidget {
  const _ActiveFocusCard();

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
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  isRunning
                      ? 'Sedang Fokus 🔥'
                      : isPaused
                          ? 'Dijeda ⏸️'
                          : 'Siap Memulai ⚡',
                  style: AppTypography.label.copyWith(color: Colors.white),
                ),
                const Spacer(),
                if (isActive)
                  Text(
                    focus.mode.value.label,
                    style: AppTypography.caption.copyWith(
                      color: Colors.white.withAlpha(200),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              isActive ? focus.formattedRemaining : '25:00',
              style: AppTypography.h1.copyWith(
                color: Colors.white,
                fontSize: 48,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isActive
                  ? '${(focus.progress * 100).toStringAsFixed(0)}% selesai'
                  : 'Pilih mode dan mulai sesi',
              style: AppTypography.body.copyWith(
                color: Colors.white.withAlpha(200),
              ),
            ),
            if (isActive) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: focus.progress,
                  minHeight: 4,
                  backgroundColor: Colors.white.withAlpha(50),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: isRunning ? focus.pause : focus.resume,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(30),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withAlpha(60)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isRunning ? LucideIcons.pause : LucideIcons.play,
                              size: 18,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isRunning ? 'Jeda' : 'Lanjutkan',
                              style: AppTypography.button,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () async => focus.cancel(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(20),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        LucideIcons.x,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    });
  }
}

// ── Mode Card ─────────────────────────────────────────────────────────────────

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.gradient,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final LinearGradient gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Row(
          children: [
            Container(
              width: 64,
              height: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Icon(icon, size: 28, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.cardTitle),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTypography.subtitle),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppTypography.caption,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
