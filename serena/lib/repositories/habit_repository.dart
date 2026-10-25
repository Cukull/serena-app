import 'package:serena/models/habit.dart';
import 'package:serena/services/supabase_client.dart';

/// Query `habits` + `habit_logs`.
class HabitRepository {
  Future<List<Habit>> fetchHabits(String userId) async {
    final rows = await Supa.client
        .from('habits')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: true);
    return rows.map(Habit.fromJson).toList();
  }

  Future<Habit> createHabit(Habit habit) async {
    final map = habit.toJson()..remove('id');
    final row = await Supa.client
        .from('habits')
        .insert(map)
        .select()
        .single();
    return Habit.fromJson(row);
  }

  Future<void> deleteHabit(String id) async {
    await Supa.client.from('habits').delete().eq('id', id);
  }

  Future<List<HabitLog>> fetchLogsForDate(
    String userId,
    DateTime date,
  ) async {
    final rows = await Supa.client
        .from('habit_logs')
        .select()
        .eq('user_id', userId)
        .eq('logged_date', date.toIso8601String().substring(0, 10));
    return rows.map(HabitLog.fromJson).toList();
  }

  /// Toggle log harian: belum ada → insert, sudah ada → hapus.
  Future<void> toggleLog({
    required String habitId,
    required String userId,
    required DateTime date,
  }) async {
    final dateStr = date.toIso8601String().substring(0, 10);
    final existing = await Supa.client
        .from('habit_logs')
        .select('id')
        .eq('habit_id', habitId)
        .eq('logged_date', dateStr)
        .maybeSingle();
    if (existing == null) {
      await Supa.client.from('habit_logs').insert({
        'habit_id': habitId,
        'user_id': userId,
        'logged_date': dateStr,
      });
    } else {
      await Supa.client
          .from('habit_logs')
          .delete()
          .eq('id', existing['id'] as String);
    }
  }
}
