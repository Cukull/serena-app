import 'package:serena/models/focus_session.dart';
import 'package:serena/services/supabase_client.dart';

/// Query `focus_sessions`.
class FocusRepository {
  Future<List<FocusSession>> fetchSessions(
    String userId, {
    int limit = 30,
  }) async {
    final rows = await Supa.client
        .from('focus_sessions')
        .select()
        .eq('user_id', userId)
        .order('started_at', ascending: false)
        .limit(limit);
    return rows.map(FocusSession.fromJson).toList();
  }

  Future<FocusSession> insertSession(FocusSession session) async {
    final map = session.toJson()..remove('id');
    final row = await Supa.client
        .from('focus_sessions')
        .insert(map)
        .select()
        .single();
    return FocusSession.fromJson(row);
  }
}
