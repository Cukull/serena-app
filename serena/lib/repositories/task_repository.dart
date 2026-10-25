import 'package:serena/models/task.dart';
import 'package:serena/services/supabase_client.dart';

/// CRUD `tasks`.
class TaskRepository {
  Future<List<Task>> fetchTasks(String userId) async {
    final rows = await Supa.client
        .from('tasks')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return rows.map(Task.fromJson).toList();
  }

  Future<Task> createTask(Task task) async {
    final map = task.toJson()..remove('id');
    final row = await Supa.client
        .from('tasks')
        .insert(map)
        .select()
        .single();
    return Task.fromJson(row);
  }

  Future<Task> updateTask(Task task) async {
    final map = task.toJson()..remove('id');
    final row = await Supa.client
        .from('tasks')
        .update(map)
        .eq('id', task.id)
        .select()
        .single();
    return Task.fromJson(row);
  }

  Future<void> deleteTask(String id) async {
    await Supa.client.from('tasks').delete().eq('id', id);
  }
}
