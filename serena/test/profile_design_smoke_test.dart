import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:serena/core/theme/app_theme.dart';
import 'package:serena/core/widgets/app_ui.dart';
import 'package:serena/features/profile/edit_profile_page.dart';
import 'package:serena/features/profile/profile_page.dart';
import 'package:serena/features/profile/settings_page.dart';

/// Smoke test layar desain baru: render tanpa overflow + teks kunci tampil.
void main() {
  Future<void> pumpPage(WidgetTester tester, Widget page) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      GetMaterialApp(theme: AppTheme.light, home: page),
    );
    await tester.pump(const Duration(milliseconds: 300));
  }

  void expectNoException(WidgetTester tester) {
    final errors = <Object>[];
    Object? error = tester.takeException();
    while (error != null) {
      errors.add(error);
      error = tester.takeException();
    }
    expect(errors, isEmpty, reason: errors.join('\n---\n'));
  }

  testWidgets('tab Profil tampil sesuai referensi', (tester) async {
    await pumpPage(tester, const ProfilePage());

    expect(find.text('Profil'), findsOneWidget);
    expect(find.text('Pengaturan profil'), findsOneWidget);
    expect(find.text('Keamanan & privasi'), findsOneWidget);
    expect(find.text('Keluar dari akun'), findsOneWidget);
    expectNoException(tester);
  });

  testWidgets('Info Pribadi tampil dan bisa masuk mode edit', (tester) async {
    await pumpPage(tester, const EditProfilePage());

    expect(find.text('Info Pribadi'), findsOneWidget);
    expect(find.text('INFO AKADEMIK'), findsOneWidget);
    expect(find.text('MINAT & VIBES'), findsOneWidget);

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    expect(find.text('Simpan perubahan'), findsOneWidget);
    expectNoException(tester);
  });

  testWidgets('Keamanan & Privasi menampilkan skor 85', (tester) async {
    await pumpPage(tester, const SettingsPage());

    expect(find.text('Keamanan & Privasi'), findsOneWidget);
    expect(find.text('Skor keamanan: 85/100'), findsOneWidget);
    expect(find.text('ZONA BAHAYA'), findsOneWidget);
    expectNoException(tester);
  });

  testWidgets('mematikan biometrik menurunkan skor keamanan', (tester) async {
    await pumpPage(tester, const SettingsPage());

    final biometricSwitch = find.byType(AppSwitch).first;
    await tester.ensureVisible(biometricSwitch);
    await tester.pumpAndSettle();
    await tester.tap(biometricSwitch);
    await tester.pumpAndSettle();

    expect(find.text('Skor keamanan: 65/100'), findsOneWidget);
    expect(find.text('Login biometrik nonaktif'), findsWidgets);
    expectNoException(tester);
  });
}
