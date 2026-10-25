/// Kategori task (tabel `task_categories`).
class TaskCategory {
  const TaskCategory({
    required this.id,
    required this.userId,
    required this.name,
    this.color,
    this.icon,
  });

  final String id;
  final String userId;
  final String name;
  final String? color;
  final String? icon;

  factory TaskCategory.fromJson(Map<String, dynamic> json) => TaskCategory(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        name: json['name'] as String,
        color: json['color'] as String?,
        icon: json['icon'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'color': color,
        'icon': icon,
      };
}
