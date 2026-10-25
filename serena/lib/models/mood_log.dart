/// Log mood (tabel `mood_logs`).
class MoodLog {
  const MoodLog({
    required this.id,
    required this.userId,
    required this.moodScore,
    this.moodLabel,
    this.note,
    required this.loggedAt,
  });

  final String id;
  final String userId;
  final int moodScore;
  final String? moodLabel;
  final String? note;
  final DateTime loggedAt;

  factory MoodLog.fromJson(Map<String, dynamic> json) => MoodLog(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        moodScore: json['mood_score'] as int,
        moodLabel: json['mood_label'] as String?,
        note: json['note'] as String?,
        loggedAt: DateTime.parse(json['logged_at'] as String).toLocal(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'mood_score': moodScore,
        'mood_label': moodLabel,
        'note': note,
        'logged_at': loggedAt.toUtc().toIso8601String(),
      };
}
