/// Goal/interest pengguna (tabel `user_goals`), diisi saat onboarding.
class UserGoal {
  const UserGoal({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.targetDate,
    this.isCompleted = false,
  });

  final String id;
  final String userId;
  final String title;
  final String? description;
  final DateTime? targetDate;
  final bool isCompleted;

  factory UserGoal.fromJson(Map<String, dynamic> json) => UserGoal(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        title: json['title'] as String,
        description: json['description'] as String?,
        targetDate: json['target_date'] == null
            ? null
            : DateTime.parse(json['target_date'] as String),
        isCompleted: json['is_completed'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'title': title,
        'description': description,
        'target_date': targetDate?.toIso8601String(),
        'is_completed': isCompleted,
      };
}
