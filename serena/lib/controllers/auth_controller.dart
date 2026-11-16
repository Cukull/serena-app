import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:serena/app/app_routes.dart';
import 'package:serena/models/profile.dart';
import 'package:serena/repositories/auth_repository.dart';
import 'package:serena/repositories/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Session + onboarding state. Didaftarkan permanent di AppBindings.
/// Mendengarkan `onAuthStateChange` dan jadi satu-satunya sumber
/// kebenaran status login/onboarding untuk AuthMiddleware.
class AuthController extends GetxController {
  AuthController({
    required this.authRepo,
    required this.profileRepo,
  });

  /// Diisi oleh `main()` sebelum runApp, dipakai sebagai status sinkron
  /// pertama agar AuthMiddleware langsung benar saat cold start.
  static bool bootLoggedIn = false;
  static bool bootOnboarded = false;

  final AuthRepository authRepo;
  final ProfileRepository profileRepo;

  final isLoggedIn = false.obs;
  final onboardingDone = false.obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final user = Rxn<Profile>();

  String? _pendingEmail;
  String? _pendingPassword;

  StreamSubscription<AuthState>? _sub;

  @override
  void onInit() {
    super.onInit();
    markSession(loggedIn: bootLoggedIn, onboarded: bootOnboarded);
    _sub = authRepo.authStateChanges.listen(
      (state) => unawaited(_onAuthState(state)),
    );
    _restore();
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  void markSession({required bool loggedIn, required bool onboarded}) {
    isLoggedIn.value = loggedIn;
    onboardingDone.value = onboarded;
  }

  Future<void> _restore() async {
    await _applySession(authRepo.currentSession);
  }

  Future<void> _onAuthState(AuthState state) async {
    await _applySession(state.session);
    // Deep link konfirmasi email / login sukses: sesi sudah ada, arahkan keluar
    // dari halaman auth. Login manual juga lewat sini supaya tidak dobel.
    if (state.event == AuthChangeEvent.signedIn ||
        state.event == AuthChangeEvent.userUpdated) {
      if (state.session != null) {
        Get.snackbar(
          'Email Terkonfirmasi',
          'Selamat datang di Serena!',
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
        );
        await Get.offAllNamed<void>(
          onboardingDone.value ? Routes.main : Routes.onboarding,
        );
      }
    }
  }

  Future<void> _applySession(Session? session) async {
    if (session == null) {
      markSession(loggedIn: false, onboarded: false);
      user.value = null;
      return;
    }
    isLoggedIn.value = true;
    final profile = await profileRepo.fetchProfile(session.user.id);
    user.value = profile;
    onboardingDone.value = profile?.onboardingCompleted ?? false;
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    errorMessage.value = null;
    _pendingEmail = email.trim();
    _pendingPassword = password;
    try {
      await authRepo.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );
      await Get.offAllNamed<void>(Routes.verify);
    } on AuthError catch (e) {
      errorMessage.value = e.message;
    } on Object {
      errorMessage.value = 'Terjadi kesalahan. Coba lagi.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      await authRepo.signIn(email: email, password: password);
      final id = authRepo.currentUserId;
      if (id == null) return;
      final profile = await profileRepo.fetchProfile(id);
      user.value = profile;
      onboardingDone.value = profile?.onboardingCompleted ?? false;
      // Navigasi dilakukan oleh listener signedIn di _onAuthState.
    } on AuthError catch (e) {
      errorMessage.value = e.message;
    } on Object {
      errorMessage.value = 'Terjadi kesalahan. Coba lagi.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgotPassword(String email) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      await authRepo.resetPassword(email);
      Get.back<void>();
      Get.snackbar(
        'Terkirim',
        'Link reset password sudah dikirim ke email Anda.',
      );
    } on AuthError catch (e) {
      errorMessage.value = e.message;
    } on Object {
      errorMessage.value = 'Terjadi kesalahan. Coba lagi.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Dipanggil user dari /verify setelah klik link di email.
  Future<void> confirmEmailVerified() async {
    isLoading.value = true;
    try {
      if (authRepo.currentSession != null) {
        await authRepo.refreshSession();
      } else if (_pendingEmail != null && _pendingPassword != null) {
        // Coba login dengan kredensial pendaftaran yang baru dibuat
        await authRepo.signIn(
          email: _pendingEmail!,
          password: _pendingPassword!,
        );
      } else {
        throw const AuthError('Sesi tidak ditemukan.');
      }

      final id = authRepo.currentUserId;
      if (id == null) return;
      final profile = await profileRepo.fetchProfile(id);
      user.value = profile;
      onboardingDone.value = profile?.onboardingCompleted ?? false;
      isLoggedIn.value = true;
      Get.snackbar(
        'Email Terkonfirmasi',
        'Selamat datang di Serena!',
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
      );
      await Get.offAllNamed<void>(
        onboardingDone.value ? Routes.main : Routes.onboarding,
      );
    } on AuthError catch (e) {
      Get.snackbar(
        'Belum terverifikasi',
        e.message.contains('Email not confirmed') ||
                e.message.toLowerCase().contains('verifikasi')
            ? 'Klik link verifikasi di email dulu.'
            : e.message,
      );
    } on Object {
      Get.snackbar(
        'Belum terverifikasi',
        'Klik link verifikasi di email dulu.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> completeOnboarding({
    required String goal,
  }) async {
    final id = authRepo.currentUserId;
    if (id == null) return;
    isLoading.value = true;
    errorMessage.value = null;
    try {
      if (goal.trim().isNotEmpty) {
        await profileRepo.insertGoal(id, goal.trim());
      }
      await profileRepo.setOnboardingCompleted(id);
      onboardingDone.value = true;
      await Get.offAllNamed<void>(Routes.main);
    } on Object {
      errorMessage.value = 'Gagal menyimpan data onboarding.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await authRepo.signOut();
    markSession(loggedIn: false, onboarded: false);
    user.value = null;
    await Get.offAllNamed<void>(Routes.login);
  }
}
