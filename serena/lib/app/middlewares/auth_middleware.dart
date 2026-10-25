import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:serena/app/app_routes.dart';
import 'package:serena/controllers/auth_controller.dart';

/// Guard auth untuk route protected. Ditempel via `middlewares`
/// di tiap GetPage (lihat app_pages.dart).
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (!Get.isRegistered<AuthController>()) return null;
    final auth = Get.find<AuthController>();

    final isPublic = route == Routes.landing ||
        route == Routes.login ||
        route == Routes.register ||
        route == Routes.forgotPassword ||
        route == Routes.verify;

    if (auth.isLoggedIn.value) {
      if (!auth.onboardingDone.value && route != Routes.onboarding) {
        return const RouteSettings(name: Routes.onboarding);
      }
      if (auth.onboardingDone.value && isPublic) {
        return const RouteSettings(name: Routes.main);
      }
      return null;
    }

    if (!isPublic) {
      return const RouteSettings(name: Routes.login);
    }
    return null;
  }
}
