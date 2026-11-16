// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:serena/controllers/focus_controller.dart';
import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_typography.dart';
import 'package:serena/core/widgets/app_ui.dart';
import 'package:serena/models/focus_session.dart';

/// Tampilan timer sesi fokus sesuai serena-web (subViewSesiTugas).
/// Mendukung mode Pomodoro, Deep Focus, dan Exam Mode dengan
/// Atur Durasi, Big Timer, Sesi Controls, dan status reaktif.
class FocusTimerView extends StatefulWidget {
  const FocusTimerView({
    required this.mode,
    required this.initialMinutes,
    this.allowAdjust = true,
    this.title,
    super.key,
  });

  final FocusMode mode;
  final int initialMinutes;
  final bool allowAdjust;
  final String? title;

  @override
  State<FocusTimerView> createState() => _FocusTimerViewState();
}

class _FocusTimerViewState extends State<FocusTimerView> {
  late int _minutes = widget.initialMinutes;
  int _breakMinutes = 5;

  FocusController get c => Get.find<FocusController>();

  List<int> get _focusOptions => switch (widget.mode) {
        FocusMode.examMode => [45, 60, 90, 120],
        FocusMode.deepFocus => [30, 45, 60, 90],
        FocusMode.pomodoro => [25, 30, 45, 60],
      };

  static const _breakOptions = [5, 10, 15, 20];

  @override
  Widget build(BuildContext context) {
    return SerenaBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopHeader(),
              Expanded(
                child: Obx(() {
                  final isThisModeActive = c.phase.value != FocusPhase.idle &&
                      c.mode.value == widget.mode;
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                    children: [
                      _buildTaskPreview(),
                      const SizedBox(height: 16),
                      _buildTimerDisplay(isThisModeActive),
                      const SizedBox(height: 16),
                      if (!isThisModeActive) ...[
                        _buildDurationCard(),
                        const SizedBox(height: 14),
                      ],
                      const Text(
                        'Selesai sesi tidak berarti tugas sudah dikumpulkan ke LMS.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildActionButtons(isThisModeActive),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          AppCircleButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Get.back<void>(),
            semanticLabel: 'Kembali',
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title ?? widget.mode.label,
                  style: AppTypography.h2.copyWith(fontSize: 19),
                ),
                Text(
                  'Fokus pada satu tugas hingga selesai',
                  style: AppTypography.subtitle.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskPreview() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A3C4682),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              widget.mode == FocusMode.examMode
                  ? LucideIcons.shield
                  : widget.mode == FocusMode.deepFocus
                      ? LucideIcons.brain
                      : LucideIcons.timer,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.mode == FocusMode.examMode
                      ? 'PERSIAPAN UJIAN'
                      : widget.mode == FocusMode.deepFocus
                          ? 'KONSENTRASI MENDALAM'
                          : 'SISTEM BASIS DATA · DR. LIA',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF6366F1),
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.mode == FocusMode.examMode
                      ? 'Sesi Ujian / Belajar Mandiri'
                      : widget.mode == FocusMode.deepFocus
                          ? 'Tugas Proyek Terfokus'
                          : 'Tugas Database',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Hari ini · 23:59 · LMS',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerDisplay(bool isActive) {
    final isRunning = isActive && c.isRunning;
    final isPaused = isActive && c.phase.value == FocusPhase.paused;

    final String timeStr;
    if (isActive) {
      timeStr = c.formattedRemaining;
    } else {
      final m = _minutes.toString().padLeft(2, '0');
      timeStr = '$m:00';
    }

    final statusText = isRunning
        ? 'Sedang fokus'
        : isPaused
            ? 'Dijeda'
            : 'Siap fokus';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F3C4682),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Status pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color:
                  isRunning ? const Color(0x1F22C55E) : const Color(0x1A6366F1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isRunning
                        ? const Color(0xFF22C55E)
                        : isPaused
                            ? const Color(0xFFF59E0B)
                            : const Color(0xFF6366F1),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isRunning
                        ? const Color(0xFF16A34A)
                        : const Color(0xFF4F46E5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Big Timer
          Text(
            timeStr,
            style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -2,
              height: 1.05,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Waktu sesi: fokus $_minutes mnt / istirahat $_breakMinutes mnt',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ambil napas sejenak, lalu lanjutkan fokusmu.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A3C4682),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Atur Durasi',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Sesuaikan fokus dan istirahat',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Tersimpan',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Focus Duration Pills
          Row(
            children: [
              for (final opt in _focusOptions) ...[
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _minutes = opt),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _minutes == opt
                            ? const Color(0xFF6366F1)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _minutes == opt
                              ? const Color(0xFF6366F1)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                      child: Text(
                        '$opt mnt',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: _minutes == opt
                              ? Colors.white
                              : const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ),
                ),
                if (opt != _focusOptions.last) const SizedBox(width: 6),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFD),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(
                  '$_minutes',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'fokus · menit',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Break Duration Pills
          Row(
            children: [
              for (final opt in _breakOptions) ...[
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _breakMinutes = opt),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _breakMinutes == opt
                            ? const Color(0xFF6366F1)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _breakMinutes == opt
                              ? const Color(0xFF6366F1)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                      child: Text(
                        '$opt mnt',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: _breakMinutes == opt
                              ? Colors.white
                              : const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ),
                ),
                if (opt != _breakOptions.last) const SizedBox(width: 6),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFD),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(
                  '$_breakMinutes',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'istirahat · menit',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isActive) {
    if (!isActive) {
      return GestureDetector(
        onTap: () => c.start(widget.mode, _minutes),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF5B7AF5), Color(0xFF6E60F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3D5B7AF5),
                blurRadius: 14,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.play, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text(
                'Mulai Sesi Fokus',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final running = c.isRunning;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: running ? c.pause : c.resume,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: running
                        ? const Color(0xFFF1F5F9)
                        : const Color(0xFF6366F1),
                    borderRadius: BorderRadius.circular(14),
                    border: running
                        ? Border.all(color: const Color(0xFFCBD5E1))
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        running ? LucideIcons.pause : LucideIcons.play,
                        color: running ? const Color(0xFF334155) : Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        running ? 'Jeda' : 'Lanjutkan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color:
                              running ? const Color(0xFF334155) : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  await c.finish();
                  if (!mounted) return;
                  Get.back<void>();
                  Get.snackbar(
                    'Selesai',
                    'Sesi fokus berhasil disimpan 🎉',
                    backgroundColor: Colors.white,
                    colorText: AppColors.textPrimary,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.check,
                        color: Color(0xFF6366F1),
                        size: 18,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Selesai Sesi',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () async {
            await c.cancel();
            Get.back<void>();
          },
          child: const Text(
            'Batalkan Sesi',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.danger,
            ),
          ),
        ),
      ],
    );
  }
}
