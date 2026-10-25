import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:serena/controllers/focus_controller.dart';
import 'package:serena/models/focus_session.dart';

/// Tampilan timer fokus yang dipakai bersama oleh mode Pomodoro,
/// Deep Focus, dan Exam Mode. Menampilkan pengaturan durasi saat idle,
/// lalu countdown + kontrol saat berjalan.
class FocusTimerView extends StatefulWidget {
  const FocusTimerView({
    super.key,
    required this.mode,
    required this.initialMinutes,
    this.allowAdjust = false,
    this.title,
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

  FocusController get c => Get.find<FocusController>();

  @override
  void dispose() {
    if (c.phase.value != FocusPhase.idle) {
      c.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title ?? widget.mode.label)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Obx(
            () => c.phase.value == FocusPhase.idle
                ? _buildIdle(context)
                : _buildRunning(context),
          ),
        ),
      ),
    );
  }

  Widget _buildIdle(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.mode.label,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          '$_minutes menit',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        if (widget.allowAdjust) ...[
          const SizedBox(height: 16),
          Slider(
            min: 10,
            max: 120,
            divisions: 22,
            value: _minutes.toDouble(),
            label: '$_minutes',
            onChanged: (v) => setState(() => _minutes = v.round()),
          ),
        ],
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => c.start(widget.mode, _minutes),
            child: const Text('Mulai'),
          ),
        ),
      ],
    );
  }

  Widget _buildRunning(BuildContext context) {
    final running = c.isRunning;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: c.progress,
                strokeWidth: 10,
                backgroundColor: Colors.grey.shade200,
              ),
              Center(
                child: Text(
                  c.formattedRemaining,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontFeatures: const [
                          FontFeature.tabularFigures(),
                        ],
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: running ? c.pause : c.resume,
              child: Text(running ? 'Jeda' : 'Lanjut'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () async {
                await c.finish();
                if (!context.mounted) return;
                Get.back();
                Get.snackbar('Selesai', 'Sesi fokus tersimpan 🎉');
              },
              child: const Text('Selesai'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () async {
            await c.cancel();
            Get.back();
          },
          child: const Text('Batalkan'),
        ),
      ],
    );
  }
}
