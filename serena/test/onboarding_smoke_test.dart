import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:serena/app/splash_gate.dart';
import 'package:serena/features/auth/controller/login_controller.dart';
import 'package:serena/features/auth/landing_page.dart';
import 'package:serena/features/auth/login_page.dart';

void main() {
  testWidgets('splash memudar halus ke halaman tujuan', (tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(home: SplashGate(child: Text('TUJUAN'))),
    );
    expect(find.text('BALANCE YOUR MIND, STUDY & LIFE'), findsOneWidget);
    // Halaman tujuan sudah dibangun di belakang splash.
    expect(find.text('TUJUAN'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1800));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('BALANCE YOUR MIND, STUDY & LIFE'), findsNothing);
    expect(find.text('TUJUAN'), findsOneWidget);
  });

  testWidgets('onboarding tampil di 360x740 lalu sampai slider',
      (tester) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const GetMaterialApp(home: LandingPage()));
    expect(find.text('Atur Jadwal Belajarmu'), findsOneWidget);

    await tester.tap(find.text('Lanjut'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Fokus Belajar Tanpa Distraksi'), findsOneWidget);

    await tester.tap(find.text('Lanjut'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Pantau Tugas & Tenggat Waktu'), findsOneWidget);
    expect(find.text('Geser untuk Mulai'), findsOneWidget);

    // Geser sedikit: tidak boleh pindah layar, label tetap ada.
    await tester.drag(find.text('Geser untuk Mulai'), const Offset(40, 0));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Geser untuk Mulai'), findsOneWidget);
  });

  testWidgets('login tampil di 360x740', (tester) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    Get.put(LoginController());
    addTearDown(Get.reset);

    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Selamat Datang Kembali'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Lanjutkan dengan Google'), findsOneWidget);
  });
}
