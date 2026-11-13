import 'package:serena/models/mood_log.dart';
import 'package:serena/services/supabase_client.dart';

/// Query `mood_logs`.
class MoodRepository {
  Future<List<MoodLog>> fetchMoods(String userId, {int limit = 30}) async {
    final rows = await Supa.client
        .from('mood_logs')
        .select()
        .eq('user_id', userId)
        .order('logged_at', ascending: false)
        .limit(limit);
    return rows.map(MoodLog.fromJson).toList();
  }

  Future<MoodLog> insertMood({
    required String userId,
    required int score,
    String? note,
    DateTime? loggedAt,
  }) async {
    final row = await Supa.client
        .from('mood_logs')
        .insert({
          'user_id': userId,
          'mood_score': score,
          'note': note,
          'logged_at':
              (loggedAt ?? DateTime.now()).toUtc().toIso8601String(),
        })
        .select()
        .single();
    return MoodLog.fromJson(row);
  }
}
