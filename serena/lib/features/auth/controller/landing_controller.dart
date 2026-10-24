import 'package:get/get.dart';
import 'package:serena/app/app_routes.dart';

class LandingController extends GetxController {
  void onGetStarted() => Get.toNamed<void>(AppRoutes.register);
  void onSignIn() => Get.toNamed<void>(AppRoutes.login);
}
