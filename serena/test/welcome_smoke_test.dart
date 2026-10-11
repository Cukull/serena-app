import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:serena/features/auth/welcome_page.dart';

void main() {
  for (final size in const [Size(440, 956), Size(360, 740)]) {
    testWidgets('welcome renders without layout exception at $size',
        (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const GetMaterialApp(home: WelcomePage()));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('SERENA'), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);
      expect(find.text("Today's Tasks"), findsOneWidget);

      // Kumpulkan SEMUA exception (overflow dsb), bukan cuma yang pertama.
      final errors = <Object>[];
      Object? e = tester.takeException();
      while (e != null) {
        errors.add(e);
        e = tester.takeException();
      }
      expect(errors, isEmpty, reason: errors.join('\n---\n'));
    });
  }
}
