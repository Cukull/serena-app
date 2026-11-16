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

      if (authRepo.currentSession != null) {
        await authRepo.refreshSession().timeout(const Duration(seconds: 4));
      } else if (pendingEmail != null && pendingPass != null) {
        // Coba login dengan kredensial pendaftaran yang baru dibuat
        await authRepo
            .signIn(
              email: pendingEmail,
              password: pendingPass,
            )
            .timeout(const Duration(seconds: 4));
      } else {
        throw const AuthError(
          'Sesi tidak ditemukan. Silakan login kembali di halaman Masuk.',
        );
      }

      final id = authRepo.currentUserId;
      if (id == null) {
        throw const AuthError(
          'Akun belum terverifikasi atau sesi tidak ditemukan.',
        );
      }
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
    } on AuthError catch (e) {
      Get.snackbar(
        'Belum terverifikasi',
        e.message.contains('Email not confirmed') ||
                e.message.toLowerCase().contains('verifikasi')
            ? 'Klik link verifikasi di email dulu.'
            : e.message,
      );
    } on TimeoutException {
      Get.snackbar(
        'Koneksi Lambat',
        'Gagal memverifikasi dalam batas waktu. Periksa jaringan Anda.',
      );
    } on Object catch (e) {
      debugPrint('confirmEmailVerified error: $e');
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

    final trimmedGoal = goal.trim();
    final store = GetStorage();
    await store.write('onboarding_completed_$id', true);
    if (trimmedGoal.isNotEmpty) {
      await store.write('user_goal_$id', trimmedGoal);
    }
    onboardingDone.value = true;
    if (user.value != null) {
      user.value = user.value!.copyWith(onboardingCompleted: true);
    }

    // Sync remote di latar belakang tanpa menahan tombol UI
    unawaited(
      _syncOnboardingRemote(id: id, goal: trimmedGoal),
    );

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
