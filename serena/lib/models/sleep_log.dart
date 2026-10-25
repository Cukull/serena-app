/// Log tidur (tabel `sleep_logs`).
class SleepLog {
  const SleepLog({
    required this.id,
    required this.userId,
    required this.sleepDate,
    this.bedtime,
    this.wakeTime,
    this.quality,
    this.note,
  });

  final String id;
  final String userId;
  final DateTime sleepDate;
  final DateTime? bedtime;
  final DateTime? wakeTime;
  final int? quality;
  final String? note;

  factory SleepLog.fromJson(Map<String, dynamic> json) => SleepLog(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        sleepDate: DateTime.parse(json['sleep_date'] as String),
        bedtime: json['bedtime'] == null
            ? null
            : DateTime.parse(json['bedtime'] as String).toLocal(),
        wakeTime: json['wake_time'] == null
            ? null
            : DateTime.parse(json['wake_time'] as String).toLocal(),
        quality: json['quality'] as int?,
        note: json['note'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'sleep_date': sleepDate.toIso8601String().substring(0, 10),
        'bedtime': bedtime?.toUtc().toIso8601String(),
        'wake_time': wakeTime?.toUtc().toIso8601String(),
        'quality': quality,
        'note': note,
      };
}
