/// Mode fokus (enum `focus_mode`).
enum FocusMode { pomodoro, deepFocus, examMode }

/// Status sesi fokus (enum `focus_status`).
enum FocusStatus { active, paused, completed, cancelled }

extension FocusModeX on FocusMode {
  String get dbValue => switch (this) {
        FocusMode.pomodoro => 'pomodoro',
        FocusMode.deepFocus => 'deep_focus',
        FocusMode.examMode => 'exam_mode',
      };

  String get label => switch (this) {
        FocusMode.pomodoro => 'Pomodoro',
        FocusMode.deepFocus => 'Deep Focus',
        FocusMode.examMode => 'Exam Mode',
      };
}

extension FocusStatusX on FocusStatus {
  String get dbValue => switch (this) {
        FocusStatus.active => 'active',
        FocusStatus.paused => 'paused',
        FocusStatus.completed => 'completed',
        FocusStatus.cancelled => 'cancelled',
      };
}

FocusMode focusModeFromDb(String? value) => switch (value) {
      'deep_focus' => FocusMode.deepFocus,
      'exam_mode' => FocusMode.examMode,
      _ => FocusMode.pomodoro,
    };

FocusStatus focusStatusFromDb(String? value) => switch (value) {
      'paused' => FocusStatus.paused,
      'completed' => FocusStatus.completed,
      'cancelled' => FocusStatus.cancelled,
      _ => FocusStatus.active,
    };

/// Sesi fokus (tabel `focus_sessions`).
class FocusSession {
  const FocusSession({
    required this.id,
    required this.userId,
    required this.mode,
    required this.plannedMinutes,
    this.actualMinutes,
    required this.startedAt,
    this.endedAt,
    this.status = FocusStatus.active,
    this.note,
  });

  final String id;
  final String userId;
  final FocusMode mode;
  final int plannedMinutes;
  final int? actualMinutes;
  final DateTime startedAt;
  final DateTime? endedAt;
  final FocusStatus status;
  final String? note;

  factory FocusSession.fromJson(Map<String, dynamic> json) => FocusSession(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        mode: focusModeFromDb(json['mode'] as String?),
        plannedMinutes: json['planned_minutes'] as int,
        actualMinutes: json['actual_minutes'] as int?,
        startedAt: DateTime.parse(json['started_at'] as String).toLocal(),
        endedAt: json['ended_at'] == null
            ? null
            : DateTime.parse(json['ended_at'] as String).toLocal(),
        status: focusStatusFromDb(json['status'] as String?),
        note: json['note'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'mode': mode.dbValue,
        'planned_minutes': plannedMinutes,
        'actual_minutes': actualMinutes,
        'started_at': startedAt.toUtc().toIso8601String(),
        'ended_at': endedAt?.toUtc().toIso8601String(),
        'status': status.dbValue,
        'note': note,
      };
}
