import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';

import 'package:serena/app/app.dart';
import 'package:serena/app/app_routes.dart';
import 'package:serena/controllers/auth_controller.dart';
import 'package:serena/services/supabase_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await dotenv.load();

  final url = dotenv.env['SUPABASE_URL'] ?? '';
  final anonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  await initSupabase(url: url, anonKey: anonKey);

  // Bootstrap status auth secara sinkron agar AuthMiddleware punya
  // nilai yang benar saat route awal (main/onboarding) di-resolve.
  final session = Supa.client.auth.currentSession;
  if (session == null) {
    AuthController.bootLoggedIn = false;
    AuthController.bootOnboarded = false;
    runApp(const SerenaApp(initialRoute: Routes.landing));
    return;
  }

  final onboarded = await _isOnboarded(session.user.id);
  AuthController.bootLoggedIn = true;
  AuthController.bootOnboarded = onboarded;
  runApp(
    SerenaApp(initialRoute: onboarded ? Routes.main : Routes.onboarding),
  );
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
