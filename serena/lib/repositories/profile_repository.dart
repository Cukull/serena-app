import 'package:serena/models/profile.dart';
import 'package:serena/services/supabase_client.dart';

/// Query `profiles` + `user_goals`.
class ProfileRepository {
  Future<Profile?> fetchProfile(String userId) async {
    final row = await Supa.client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    return row == null ? null : Profile.fromJson(row);
  }

  Future<void> updateProfile(
    String userId, {
    String? fullName,
    String? avatarUrl,
  }) async {
    await Supa.client.from('profiles').update({
      if (fullName != null) 'full_name': fullName,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
    }).eq('id', userId);
  }

  Future<void> setOnboardingCompleted(String userId) async {
    await Supa.client
        .from('profiles')
        .update({'onboarding_completed': true}).eq('id', userId);
  }

  Future<void> insertGoal(String userId, String title) async {
    await Supa.client
        .from('user_goals')
        .insert({'user_id': userId, 'title': title});
  }
}
