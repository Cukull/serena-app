/// Prioritas task (enum `task_priority`).
enum TaskPriority { low, medium, high, urgent }

/// Status task (enum `task_status`).
enum TaskStatus { pending, inProgress, completed, cancelled }

extension TaskPriorityX on TaskPriority {
  String get dbValue => switch (this) {
        TaskPriority.low => 'low',
        TaskPriority.medium => 'medium',
        TaskPriority.high => 'high',
        TaskPriority.urgent => 'urgent',
      };

  String get label => switch (this) {
        TaskPriority.low => 'Rendah',
        TaskPriority.medium => 'Sedang',
        TaskPriority.high => 'Tinggi',
        TaskPriority.urgent => 'Urgent',
      };
}

extension TaskStatusX on TaskStatus {
  String get dbValue => switch (this) {
        TaskStatus.pending => 'pending',
        TaskStatus.inProgress => 'in_progress',
        TaskStatus.completed => 'completed',
        TaskStatus.cancelled => 'cancelled',
      };

  String get label => switch (this) {
        TaskStatus.pending => 'Upcoming',
        TaskStatus.inProgress => 'In Progress',
        TaskStatus.completed => 'Completed',
        TaskStatus.cancelled => 'Cancelled',
      };
}

TaskPriority taskPriorityFromDb(String? value) => switch (value) {
      'low' => TaskPriority.low,
      'high' => TaskPriority.high,
      'urgent' => TaskPriority.urgent,
      _ => TaskPriority.medium,
    };

TaskStatus taskStatusFromDb(String? value) => switch (value) {
      'in_progress' => TaskStatus.inProgress,
      'completed' => TaskStatus.completed,
      'cancelled' => TaskStatus.cancelled,
      _ => TaskStatus.pending,
    };

/// Task (tabel `tasks`).
class Task {
  const Task({
    required this.id,
    required this.userId,
    required this.title,
    this.categoryId,
    this.description,
    this.deadline,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.pending,
    this.progress = 0,
    this.reminderAt,
    this.completedAt,
  });

  final String id;
  final String userId;
  final String? categoryId;
  final String title;
  final String? description;
  final DateTime? deadline;
  final TaskPriority priority;
  final TaskStatus status;
  final int progress;
  final DateTime? reminderAt;
  final DateTime? completedAt;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        categoryId: json['category_id'] as String?,
        title: json['title'] as String,
        description: json['description'] as String?,
        deadline: json['deadline'] == null
            ? null
            : DateTime.parse(json['deadline'] as String),
        priority: taskPriorityFromDb(json['priority'] as String?),
        status: taskStatusFromDb(json['status'] as String?),
        progress: json['progress'] as int? ?? 0,
        reminderAt: json['reminder_at'] == null
            ? null
            : DateTime.parse(json['reminder_at'] as String),
        completedAt: json['completed_at'] == null
            ? null
            : DateTime.parse(json['completed_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'category_id': categoryId,
        'title': title,
        'description': description,
        'deadline': deadline?.toUtc().toIso8601String(),
        'priority': priority.dbValue,
        'status': status.dbValue,
        'progress': progress,
        'reminder_at': reminderAt?.toUtc().toIso8601String(),
        'completed_at': completedAt?.toUtc().toIso8601String(),
      };
}
