/// Frekuensi habit (enum `habit_frequency`).
enum HabitFrequency { daily, weekly, custom }

extension HabitFrequencyX on HabitFrequency {
  String get dbValue => switch (this) {
        HabitFrequency.daily => 'daily',
        HabitFrequency.weekly => 'weekly',
        HabitFrequency.custom => 'custom',
      };

  String get label => switch (this) {
        HabitFrequency.daily => 'Harian',
        HabitFrequency.weekly => 'Mingguan',
        HabitFrequency.custom => 'Custom',
      };
}

HabitFrequency habitFrequencyFromDb(String? value) => switch (value) {
      'weekly' => HabitFrequency.weekly,
      'custom' => HabitFrequency.custom,
      _ => HabitFrequency.daily,
    };

/// Habit (tabel `habits`).
class Habit {
  const Habit({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.frequency = HabitFrequency.daily,
    this.targetPerWeek,
    this.color,
    this.icon,
    this.isActive = true,
  });

  final String id;
  final String userId;
  final String title;
  final String? description;
  final HabitFrequency frequency;
  final int? targetPerWeek;
  final String? color;
  final String? icon;
  final bool isActive;

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        title: json['title'] as String,
        description: json['description'] as String?,
        frequency: habitFrequencyFromDb(json['frequency'] as String?),
        targetPerWeek: json['target_per_week'] as int?,
        color: json['color'] as String?,
        icon: json['icon'] as String?,
        isActive: json['is_active'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'title': title,
        'description': description,
        'frequency': frequency.dbValue,
        'target_per_week': targetPerWeek,
        'color': color,
        'icon': icon,
        'is_active': isActive,
      };
}

/// Log harian habit (tabel `habit_logs`).
class HabitLog {
  const HabitLog({
    required this.id,
    required this.habitId,
    required this.userId,
    required this.loggedDate,
    this.isCompleted = true,
    this.note,
  });

  final String id;
  final String habitId;
  final String userId;
  final DateTime loggedDate;
  final bool isCompleted;
  final String? note;

  factory HabitLog.fromJson(Map<String, dynamic> json) => HabitLog(
        id: json['id'] as String,
        habitId: json['habit_id'] as String,
        userId: json['user_id'] as String,
        loggedDate: DateTime.parse(json['logged_date'] as String),
        isCompleted: json['is_completed'] as bool? ?? true,
        note: json['note'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'habit_id': habitId,
        'user_id': userId,
        'logged_date': loggedDate.toIso8601String().substring(0, 10),
        'is_completed': isCompleted,
        'note': note,
      };
}
