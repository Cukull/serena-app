import 'package:serena/models/sleep_log.dart';
import 'package:serena/services/supabase_client.dart';

/// Query `sleep_logs`.
class SleepRepository {
  Future<List<SleepLog>> fetchSleepLogs(String userId, {int limit = 30}) async {
    final rows = await Supa.client
        .from('sleep_logs')
        .select()
        .eq('user_id', userId)
        .order('sleep_date', ascending: false)
        .limit(limit);
    return rows.map(SleepLog.fromJson).toList();
  }

  Future<SleepLog> insertSleep({
    required String userId,
    required DateTime sleepDate,
    DateTime? bedtime,
    DateTime? wakeTime,
    int? quality,
    String? note,
  }) async {
    final row = await Supa.client
        .from('sleep_logs')
        .insert({
          'user_id': userId,
          'sleep_date': sleepDate.toIso8601String().substring(0, 10),
          'bedtime': bedtime?.toUtc().toIso8601String(),
          'wake_time': wakeTime?.toUtc().toIso8601String(),
          'quality': quality,
          'note': note,
        })
        .select()
        .single();
    return SleepLog.fromJson(row);
  }
}
