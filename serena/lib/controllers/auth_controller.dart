import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

  bool _isLoggingIn = false;
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
    if (_isLoggingIn) return;

    // Deep link konfirmasi email / user update dari luar flow login biasa:
    if (state.event == AuthChangeEvent.signedIn ||
        state.event == AuthChangeEvent.userUpdated) {
      if (state.session != null) {
        final target = onboardingDone.value ? Routes.main : Routes.onboarding;
        if (Get.currentRoute != target) {
          Get.snackbar(
            'Email Terkonfirmasi',
            'Selamat datang di Serena!',
            backgroundColor: const Color(0xFF10B981),
            colorText: Colors.white,
          );
          await Get.offAllNamed<void>(target);
        }
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
    final store = GetStorage();
    final localOnboarded =
        store.read<bool>('onboarding_completed_${session.user.id}') ?? false;
    onboardingDone.value = localOnboarded;

    try {
      final profile = await profileRepo
          .fetchProfile(session.user.id)
          .timeout(const Duration(seconds: 4));
      if (profile != null) {
        user.value = profile;
        onboardingDone.value = profile.onboardingCompleted || localOnboarded;
        await store.write(
          'onboarding_completed_${session.user.id}',
          onboardingDone.value,
        );
      }
    } on Object catch (e) {
      // Jaringan putus saat ambil profil: pertahankan status terakhir agar
      // user tidak dipaksa onboarding ulang / crash saat cold start.
      debugPrint('PROFILE_FETCH_FAIL: $e');
    }
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
    final store = GetStorage();
    await store.write('pending_email', _pendingEmail);
    await store.write('pending_password', _pendingPassword);
    try {
      await authRepo
          .signUp(
            email: email,
            password: password,
            fullName: fullName,
          )
          .timeout(const Duration(seconds: 6));
      await Get.offAllNamed<void>(Routes.verify);
    } on AuthError catch (e) {
      errorMessage.value = e.message;
    } on TimeoutException {
      errorMessage.value = 'Waktu pendaftaran habis. Periksa jaringan Anda.';
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
    _isLoggingIn = true;
    try {
      await authRepo
          .signIn(email: email, password: password)
          .timeout(const Duration(seconds: 5));
      final id = authRepo.currentUserId;
      if (id == null) return;
      await _applySession(authRepo.currentSession);

      final target = onboardingDone.value ? Routes.main : Routes.onboarding;
      await Get.offAllNamed<void>(target);
    } on AuthError catch (e) {
      errorMessage.value = e.message;
    } on TimeoutException {
      errorMessage.value = 'Koneksi ke server timeout. Periksa internet Anda.';
    } on Object {
      errorMessage.value = 'Terjadi kesalahan. Coba lagi.';
    } finally {
      _isLoggingIn = false;
      isLoading.value = false;
    }
  }

  Future<void> forgotPassword(String email) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      await authRepo.resetPassword(email).timeout(const Duration(seconds: 5));
      Get.back<void>();
      Get.snackbar(
        'Terkirim',
        'Link reset password sudah dikirim ke email Anda.',
      );
    } on AuthError catch (e) {
      errorMessage.value = e.message;
    } on TimeoutException {
      errorMessage.value = 'Waktu permintaan habis. Coba lagi.';
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
      final store = GetStorage();
      final pendingEmail =
          _pendingEmail ?? store.read<String>('pending_email');
      final pendingPass =
          _pendingPassword ?? store.read<String>('pending_password');

      // 1. Coba refresh sesi aktif
      if (authRepo.currentSession != null) {
        try {
          await authRepo.refreshSession().timeout(const Duration(seconds: 3));
        } on Object catch (e) {
          debugPrint('refreshSession error: $e');
        }
      }

      // 2. Jika sesi belum ada tapi ada email & password, coba login
      if (authRepo.currentSession == null &&
          pendingEmail != null &&
          pendingPass != null) {
        try {
          await authRepo
              .signIn(email: pendingEmail, password: pendingPass)
              .timeout(const Duration(seconds: 3));
        } on Object catch (e) {
          debugPrint('auto signIn error: $e');
        }
      }

      final id = authRepo.currentUserId;
      if (id != null) {
        await _applySession(authRepo.currentSession);
        await store.remove('pending_email');
        await store.remove('pending_password');

        Get.snackbar(
          'Email Terkonfirmasi',
          'Selamat datang di Serena!',
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
        );
        final target = onboardingDone.value ? Routes.main : Routes.onboarding;
        await Get.offAllNamed<void>(target);
        return;
      }

      Get.snackbar(
        'Belum terverifikasi',
        'Email belum terkonfirmasi. Buka email Anda lalu klik link konfirmasi.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> completeOnboarding({
    required String goal,
  }) async {
    isLoading.value = true;
    errorMessage.value = null;

    final id = authRepo.currentUserId ?? 'guest';
    final trimmedGoal = goal.trim();
    final store = GetStorage();
    await store.write('onboarding_completed_$id', true);
    await store.write('onboarding_completed', true);
    if (trimmedGoal.isNotEmpty) {
      await store.write('user_goal_$id', trimmedGoal);
      await store.write('user_goal', trimmedGoal);
    }
    onboardingDone.value = true;
    if (user.value != null) {
      user.value = user.value!.copyWith(onboardingCompleted: true);
    }

    // Sync remote di latar belakang tanpa menahan tombol UI
    if (id != 'guest') {
      unawaited(
        _syncOnboardingRemote(id: id, goal: trimmedGoal),
      );
    }

    isLoading.value = false;
    await Get.offAllNamed<void>(Routes.main);
  }

  Future<void> _syncOnboardingRemote({
    required String id,
    required String goal,
  }) async {
    try {
      if (goal.isNotEmpty) {
        await profileRepo
            .insertGoal(id, goal)
            .timeout(const Duration(seconds: 4));
      }
      await profileRepo
          .setOnboardingCompleted(id)
          .timeout(const Duration(seconds: 4));
    } on Object catch (e) {
      debugPrint('ONBOARDING_REMOTE_SYNC_FAIL (saved locally): $e');
    }
  }

  Future<void> logout() async {
    await authRepo.signOut();
    markSession(loggedIn: false, onboarded: false);
    user.value = null;
    await Get.offAllNamed<void>(Routes.login);
  }
}
