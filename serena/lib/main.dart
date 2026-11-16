import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:serena/app/app.dart';
import 'package:serena/app/app_routes.dart';
import 'package:serena/controllers/auth_controller.dart';
import 'package:serena/services/supabase_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  await initializeDateFormatting('id');
  await GetStorage.init();
  try {
    await dotenv.load();
  } on Object catch (e) {
    debugPrint('dotenv.load() error: $e');
  }

  const defaultUrl = 'https://gkotywekltthwyobxuqj.supabase.co';
  const defaultKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdrb3R5d2VrbHR0aHd5b2J4dXFqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTI5MjQ0MjgsImV4cCI6MjEwODUwMDQyOH0.icQ5QsE9ReLtY3ZVhn0Qfy3WTeuY0vW5oB9LC9_ogEY';

  // Onboarding penuh hanya pada buka pertama kali; setelah itu langsung login.
  final store = GetStorage();
  final seenOnboarding = store.read<bool>('onboarding_seen') ?? false;
  if (!seenOnboarding) await store.write('onboarding_seen', true);

  final url = (dotenv.env['SUPABASE_URL']?.isNotEmpty ?? false)
      ? dotenv.env['SUPABASE_URL']!
      : defaultUrl;
  final anonKey = (dotenv.env['SUPABASE_ANON_KEY']?.isNotEmpty ?? false)
      ? dotenv.env['SUPABASE_ANON_KEY']!
      : defaultKey;
  await initSupabase(url: url, anonKey: anonKey);

  final session = Supa.client.auth.currentSession;
  final String initialRoute;
  if (session == null) {
    initialRoute = seenOnboarding ? Routes.login : Routes.landing;
  } else {
    final onboarded = await _isOnboarded(session.user.id);
    AuthController.bootLoggedIn = true;
    AuthController.bootOnboarded = onboarded;
    initialRoute = onboarded ? Routes.main : Routes.onboarding;
  }

  runApp(SerenaApp(initialRoute: initialRoute));
}

Future<bool> _isOnboarded(String userId) async {
  final store = GetStorage();
  final local = store.read<bool>('onboarding_completed_$userId');
  if (local != null) return local;

  try {
    final row = await Supa.client
        .from('profiles')
        .select('onboarding_completed')
        .eq('id', userId)
        .maybeSingle();
    final val = (row?['onboarding_completed'] as bool?) ?? false;
    await store.write('onboarding_completed_$userId', val);
    return val;
  } on Object {
    return false;
  }
}
