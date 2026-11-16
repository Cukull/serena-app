import 'package:get_storage/get_storage.dart';
import 'package:serena/models/task.dart';
import 'package:serena/services/supabase_client.dart';

/// CRUD `tasks` dengan penyimpanan lokal (GetStorage) & sinkronisasi Supabase.
class TaskRepository {
  static const _localKeyPrefix = 'cached_tasks_';

  List<Task> getLocalTasks(String userId) {
    try {
      final box = GetStorage();
      final list = box.read<List<dynamic>>('$_localKeyPrefix$userId');
      if (list != null) {
        return list
            .map((e) => Task.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  void saveLocalTasks(String userId, List<Task> tasks) {
    try {
      final box = GetStorage();
      box.write(
        '$_localKeyPrefix$userId',
        tasks.map((t) => t.toJson()).toList(),
      );
    } catch (_) {}
  }

  Future<List<Task>> fetchTasks(String userId) async {
    try {
      final rows = await Supa.client
          .from('tasks')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      final remoteTasks = rows.map(Task.fromJson).toList();
      saveLocalTasks(userId, remoteTasks);
      return remoteTasks;
    } on Object {
      final local = getLocalTasks(userId);
      if (local.isNotEmpty) return local;
      rethrow;
    }
  }

  Future<Task> createTask(Task task) async {
    final localId = task.id.isNotEmpty
        ? task.id
        : 'local_${DateTime.now().microsecondsSinceEpoch}';
    final localTask = Task(
      id: localId,
      userId: task.userId,
      categoryId: task.categoryId,
      title: task.title,
      description: task.description,
      deadline: task.deadline,
      priority: task.priority,
      status: task.status,
      progress: task.progress,
      reminderAt: task.reminderAt,
      completedAt: task.completedAt,
    );

    final currentLocal = getLocalTasks(task.userId);
    currentLocal.insert(0, localTask);
    saveLocalTasks(task.userId, currentLocal);

    try {
      final map = task.toJson()..remove('id');
      final row = await Supa.client
          .from('tasks')
          .insert(map)
          .select()
          .single();
      final createdRemote = Task.fromJson(row);

      final updatedLocal = getLocalTasks(task.userId);
      final idx = updatedLocal.indexWhere((t) => t.id == localId);
      if (idx != -1) {
        updatedLocal[idx] = createdRemote;
      } else {
        updatedLocal.insert(0, createdRemote);
      }
      saveLocalTasks(task.userId, updatedLocal);
      return createdRemote;
    } on Object {
      return localTask;
    }
  }

  Future<Task> updateTask(Task task) async {
    final currentLocal = getLocalTasks(task.userId);
    final idx = currentLocal.indexWhere((t) => t.id == task.id);
    if (idx != -1) {
      currentLocal[idx] = task;
      saveLocalTasks(task.userId, currentLocal);
    }

    try {
      final map = task.toJson()..remove('id');
      final row = await Supa.client
          .from('tasks')
          .update(map)
          .eq('id', task.id)
          .select()
          .single();
      final updated = Task.fromJson(row);
      final list = getLocalTasks(task.userId);
      final i = list.indexWhere((t) => t.id == task.id);
      if (i != -1) {
        list[i] = updated;
        saveLocalTasks(task.userId, list);
      }
      return updated;
    } on Object {
      return task;
    }
  }

  Future<void> deleteTask(String id, {String? userId}) async {
    if (userId != null) {
      final currentLocal = getLocalTasks(userId);
      currentLocal.removeWhere((t) => t.id == id);
      saveLocalTasks(userId, currentLocal);
    }
    try {
      await Supa.client.from('tasks').delete().eq('id', id);
    } on Object {
      // Abaikan error jaringan saat offline, data lokal sudah dihapus.
    }
  }
}
