import 'package:get/get.dart';
import 'package:serena/controllers/focus_controller.dart';
import 'package:serena/controllers/main_controller.dart';
import 'package:serena/controllers/task_controller.dart';
import 'package:serena/controllers/user_controller.dart';
import 'package:serena/repositories/auth_repository.dart';
import 'package:serena/repositories/focus_repository.dart';
import 'package:serena/repositories/profile_repository.dart';
import 'package:serena/repositories/task_repository.dart';

/// Binding khusus untuk Route Main (/main) agar saat navigasi via Get.offAllNamed,
/// semua controller yang dibutuhkan shell dan tab tidak pernah null.
class MainBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthRepository>()) {
      Get.lazyPut<AuthRepository>(AuthRepository.new, fenix: true);
    }
    if (!Get.isRegistered<ProfileRepository>()) {
      Get.lazyPut<ProfileRepository>(ProfileRepository.new, fenix: true);
    }
    if (!Get.isRegistered<TaskRepository>()) {
      Get.lazyPut<TaskRepository>(TaskRepository.new, fenix: true);
    }
    if (!Get.isRegistered<FocusRepository>()) {
      Get.lazyPut<FocusRepository>(FocusRepository.new, fenix: true);
    }

    if (!Get.isRegistered<MainController>()) {
      Get.put<MainController>(MainController(), permanent: true);
    }
    if (!Get.isRegistered<TaskController>()) {
      Get.put<TaskController>(TaskController(repo: Get.find()), permanent: true);
    }
    if (!Get.isRegistered<FocusController>()) {
      Get.put<FocusController>(FocusController(repo: Get.find()), permanent: true);
    }
    if (!Get.isRegistered<UserController>()) {
      Get.put<UserController>(UserController(repo: Get.find()), permanent: true);
    }
  }
}
