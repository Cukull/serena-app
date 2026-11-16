import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:serena/app/app.dart';
import 'package:serena/app/app_routes.dart';
import 'package:serena/controllers/auth_controller.dart';
import 'package:serena/services/supabase_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await dotenv.load();

  // Onboarding penuh hanya pada buka pertama kali; setelah itu langsung login.
  final store = GetStorage();
  final seenOnboarding = store.read<bool>('onboarding_seen') ?? false;
  if (!seenOnboarding) await store.write('onboarding_seen', true);

  final url = dotenv.env['SUPABASE_URL'] ?? '';
  final anonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  await initSupabase(url: url, anonKey: anonKey);

  var session = Supa.client.auth.currentSession;
  if (session != null) {
    try {
      await Supa.client.auth.getUser();
    } on AuthException {
      await Supa.client.auth.signOut();
      session = null;
    } on Object {}
  }

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
  try {
    final row = await Supa.client
        .from('profiles')
        .select('onboarding_completed')
        .eq('id', userId)
        .maybeSingle();
    return (row?['onboarding_completed'] as bool?) ?? false;
  } on Object {
    return false;
  }
}
