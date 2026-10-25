import 'dart:async';

import 'package:get/get.dart';

import 'package:serena/controllers/auth_controller.dart';
import 'package:serena/models/focus_session.dart';
import 'package:serena/repositories/focus_repository.dart';

/// Fase timer fokus.
enum FocusPhase { idle, running, paused }

/// Timer fokus (idle → running → paused → finished/cancelled).
/// Durasi dihitung dari detik berjalan; sesi disimpan saat selesai.
class FocusController extends GetxController {
  FocusController({required this.repo});

  final FocusRepository repo;

  final sessions = <FocusSession>[].obs;
  final phase = FocusPhase.idle.obs;
  final mode = FocusMode.pomodoro.obs;
  final totalSeconds = 0.obs;
  final remainingSeconds = 0.obs;
  final isLoading = false.obs;

  Timer? _timer;
  DateTime? _startedAt;

  String? get _uid => Get.find<AuthController>().user.value?.id;

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> fetchSessions() async {
    final uid = _uid;
    if (uid == null) return;
    isLoading.value = true;
    try {
      sessions.value = await repo.fetchSessions(uid);
    } on Object {
      // Riwayat gagal dimuat — biarkan list tetap.
    } finally {
      isLoading.value = false;
    }
  }

  String get formattedRemaining {
    final s = remainingSeconds.value;
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final sec = (s % 60).toString().padLeft(2, '0');
    return '$m:$sec';
  }

  double get progress => totalSeconds.value == 0
      ? 0
      : 1 - (remainingSeconds.value / totalSeconds.value);

  bool get isRunning => phase.value == FocusPhase.running;

  void start(FocusMode m, int minutes) {
    _timer?.cancel();
    mode.value = m;
    totalSeconds.value = minutes * 60;
    remainingSeconds.value = minutes * 60;
    _startedAt = DateTime.now();
    phase.value = FocusPhase.running;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (remainingSeconds.value <= 1) {
      remainingSeconds.value = 0;
      finish();
    } else {
      remainingSeconds.value--;
    }
  }

  void pause() {
    if (phase.value != FocusPhase.running) return;
    _timer?.cancel();
    phase.value = FocusPhase.paused;
  }

  void resume() {
    if (phase.value != FocusPhase.paused) return;
    phase.value = FocusPhase.running;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  Future<void> finish() async {
    _timer?.cancel();
    final elapsed = totalSeconds.value - remainingSeconds.value;
    phase.value = FocusPhase.idle;
    await _record(elapsed, FocusStatus.completed);
  }

  Future<void> cancel() async {
    _timer?.cancel();
    final elapsed = totalSeconds.value - remainingSeconds.value;
    phase.value = FocusPhase.idle;
    // Sesi dibatalkan hanya disimpan bila sudah berjalan > 1 menit.
    if (elapsed >= 60) {
      await _record(elapsed, FocusStatus.cancelled);
    }
  }

  Future<void> _record(int actualSeconds, FocusStatus status) async {
    final uid = _uid;
    if (uid == null) return;
    final now = DateTime.now();
    final started =
        _startedAt ?? now.subtract(Duration(seconds: actualSeconds));
    final session = FocusSession(
      id: '',
      userId: uid,
      mode: mode.value,
      plannedMinutes: totalSeconds.value ~/ 60,
      actualMinutes: actualSeconds ~/ 60,
      startedAt: started,
      endedAt: now,
      status: status,
    );
    await repo.insertSession(session);
    await fetchSessions();
  }
}
