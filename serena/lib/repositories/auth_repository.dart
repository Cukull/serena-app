import 'package:flutter/foundation.dart';
import 'package:serena/services/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Kesalahan auth yang pesannya sudah ramah untuk ditampilkan ke user.
class AuthError implements Exception {
  const AuthError(this.message);

  final String message;

  @override
  String toString() => message;
}

String _friendly(String? raw) {
  final m = raw?.toLowerCase() ?? '';
  if (m.contains('invalid login credentials')) {
    return 'Email atau password salah.';
  }
  if (m.contains('email not confirmed')) {
    return 'Email belum diverifikasi. Cek inbox Anda.';
  }
  if (m.contains('already registered') ||
      m.contains('already been registered')) {
    return 'Email sudah terdaftar.';
  }
  if (m.contains('password should be at least')) {
    return 'Password minimal 8 karakter.';
  }
  if (m.contains('failed host lookup') ||
      m.contains('socketexception') ||
      m.contains('clientexception') ||
      m.contains('timed out') ||
      m.contains('connection')) {
    return 'Tidak ada koneksi internet. Periksa jaringan lalu coba lagi.';
  }
  return raw ?? 'Terjadi kesalahan. Coba lagi.';
}

/// Wrapper Auth Supabase. Controller tidak menyentuh client langsung.
class AuthRepository {
  GoTrueClient get _auth => Supa.client.auth;

  Stream<AuthState> get authStateChanges => _auth.onAuthStateChange;

  String? get currentUserId => _auth.currentUser?.id;

  Session? get currentSession => _auth.currentSession;

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final redirectUrl =
          kIsWeb ? 'http://localhost:5000' : 'serena://login-callback';
      await _auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
        emailRedirectTo: redirectUrl,
      );
    } on AuthException catch (e) {
      throw AuthError(_friendly(e.message));
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      throw AuthError(_friendly(e.message));
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      final redirectUrl =
          kIsWeb ? 'http://localhost:5000' : 'serena://login-callback';
      await _auth.resetPasswordForEmail(
        email,
        redirectTo: redirectUrl,
      );
    } on AuthException catch (e) {
      throw AuthError(_friendly(e.message));
    }
  }

  Future<void> refreshSession() async {
    await _auth.refreshSession();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
