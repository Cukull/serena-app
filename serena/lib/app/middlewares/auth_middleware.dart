import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:serena/controllers/auth_controller.dart';
import 'package:serena/app/app_routes.dart';

/// Guard auth untuk route protected. Ditempel via `middlewares`
/// di tiap GetPage (lihat app_pages.dart).
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (!Get.isRegistered<AuthController>()) return null;
    final auth = Get.find<AuthController>();
    final goingAuth = route == AppRoutes.login || route == AppRoutes.register;
    if (!auth.isLoggedIn.value &&
        !goingAuth &&
        route != AppRoutes.forgotPassword &&
        route != AppRoutes.verify) {
      return const RouteSettings(name: AppRoutes.login);
    }
    if (auth.isLoggedIn.value &&
        !auth.onboardingDone.value &&
        route != AppRoutes.onboarding) {
      return const RouteSettings(name: AppRoutes.onboarding);
    }
    if (auth.isLoggedIn.value &&
        auth.onboardingDone.value &&
        (goingAuth || route == AppRoutes.onboarding)) {
      return const RouteSettings(name: AppRoutes.main);
    }
    return null;
  }
}
