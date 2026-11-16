import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:serena/models/profile.dart';
import 'package:serena/services/supabase_client.dart';

/// Query `profiles` + `user_goals` dengan dukungan offline GetStorage.
class ProfileRepository {
  Future<Profile?> fetchProfile(String userId) async {
    try {
      final row = await Supa.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle()
          .timeout(const Duration(seconds: 4));
      if (row != null) {
        final profile = Profile.fromJson(row);
        await GetStorage().write('cached_profile_$userId', profile.toJson());
        await GetStorage().write(
          'onboarding_completed_$userId',
          profile.onboardingCompleted,
        );
        return profile;
      }
    } on Object catch (e) {
      debugPrint('fetchProfile network error: $e');
      final cached =
          GetStorage().read<Map<String, dynamic>>('cached_profile_$userId');
      if (cached != null) {
        return Profile.fromJson(cached);
      }
    }
    return null;
  }

  Future<void> updateProfile(
    String userId, {
    String? fullName,
    String? avatarUrl,
  }) async {
    try {
      await Supa.client.from('profiles').update({
        if (fullName != null) 'full_name': fullName,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
      }).eq('id', userId).timeout(const Duration(seconds: 4));
    } on Object catch (e) {
      debugPrint('updateProfile error: $e');
    }
  }

  Future<void> setOnboardingCompleted(String userId) async {
    final store = GetStorage();
    await store.write('onboarding_completed_$userId', true);
    final cached = store.read<Map<String, dynamic>>('cached_profile_$userId');
    if (cached != null) {
      final updated = Map<String, dynamic>.from(cached);
      updated['onboarding_completed'] = true;
      await store.write('cached_profile_$userId', updated);
    }
    try {
      await Supa.client
          .from('profiles')
          .update({'onboarding_completed': true})
          .eq('id', userId)
          .timeout(const Duration(seconds: 4));
    } on Object catch (e) {
      debugPrint('setOnboardingCompleted remote error (saved locally): $e');
    }
  }

  Future<void> insertGoal(String userId, String title) async {
    await GetStorage().write('user_goal_$userId', title);
    try {
      await Supa.client
          .from('user_goals')
          .insert({'user_id': userId, 'title': title})
          .timeout(const Duration(seconds: 4));
    } on Object catch (e) {
      debugPrint('insertGoal remote error (saved locally): $e');
    }
  }
}
