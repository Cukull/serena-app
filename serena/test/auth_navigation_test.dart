import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:serena/app/app_routes.dart';
import 'package:serena/controllers/auth_controller.dart';
import 'package:serena/features/auth/bindings/login_binding.dart';
import 'package:serena/features/auth/forgot_password_page.dart';
import 'package:serena/features/auth/login_page.dart';
import 'package:serena/features/auth/register_page.dart';
import 'package:serena/models/profile.dart';
import 'package:serena/repositories/auth_repository.dart';
import 'package:serena/repositories/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _FakeAuthRepo extends AuthRepository {
  @override
  Stream<AuthState> get authStateChanges => const Stream.empty();
  @override
  String? get currentUserId => null;
  @override
  Session? get currentSession => null;
}

class _FakeProfileRepo extends ProfileRepository {
  @override
  Future<Profile?> fetchProfile(String userId) async => null;
}

void main() {
  tearDown(Get.reset);

  testWidgets(
      'Navigasi Login -> Register -> Login -> Forgot -> Login dan input teks '
      'tanpa error', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    // Register dummy AuthController so pages can read it
    Get.put(
      AuthController(
        authRepo: _FakeAuthRepo(),
        profileRepo: _FakeProfileRepo(),
      ),
    );

    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: Routes.login,
        getPages: [
          GetPage(
            name: Routes.login,
            page: () => const LoginPage(),
            binding: LoginBinding(),
          ),
          GetPage(
            name: Routes.register,
            page: () => const RegisterPage(),
          ),
          GetPage(
            name: Routes.forgotPassword,
            page: () => const ForgotPasswordPage(),
          ),
        ],
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // Pastikan berada di LoginPage
    expect(find.text('Selamat Datang Kembali'), findsOneWidget);

    // 1. Klik Buat Akun Baru -> Pindah ke Register
    final registerLink = find.text('Buat Akun Baru');
    expect(registerLink, findsOneWidget);
    await tester.ensureVisible(registerLink);
    await tester.tap(registerLink);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Sudah punya akun? '), findsOneWidget);

    // 2. Klik Masuk pada RegisterPage -> Kembali ke Login
    final backToLoginFromReg = find.text('Masuk');
    await tester.ensureVisible(backToLoginFromReg);
    await tester.tap(backToLoginFromReg);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Selamat Datang Kembali'), findsOneWidget);

    // 3. Klik Lupa Kata Sandi? -> Pindah ke Forgot Password
    final forgotLink = find.text('Lupa Kata Sandi?');
    await tester.ensureVisible(forgotLink);
    await tester.tap(forgotLink);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('PULIHKAN AKUN KAMU'), findsOneWidget);

    // 4. Klik Masuk pada ForgotPasswordPage -> Kembali ke Login
    final backToLoginFromForgot = find.text('Masuk');
    await tester.ensureVisible(backToLoginFromForgot);
    await tester.tap(backToLoginFromForgot);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Selamat Datang Kembali'), findsOneWidget);

    // 5. Input teks ke field email dan password
    final emailField = find.byType(TextFormField).first;
    await tester.enterText(emailField, 'test@student.edu');
    await tester.pump(const Duration(milliseconds: 300));

    final passField = find.byType(TextFormField).last;
    await tester.enterText(passField, 'password123');
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('test@student.edu'), findsOneWidget);
  });
}
