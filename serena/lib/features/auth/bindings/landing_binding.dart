import 'package:get/get.dart';
import 'package:serena/features/auth/controller/landing_controller.dart';

class LandingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LandingController>(LandingController.new);
  }
}
