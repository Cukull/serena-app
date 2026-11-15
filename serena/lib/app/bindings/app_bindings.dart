import 'package:get/get.dart';

import 'package:serena/controllers/auth_controller.dart';
import 'package:serena/controllers/focus_controller.dart';
import 'package:serena/controllers/main_controller.dart';
import 'package:serena/controllers/task_controller.dart';
import 'package:serena/controllers/user_controller.dart';
import 'package:serena/repositories/auth_repository.dart';
import 'package:serena/repositories/focus_repository.dart';
import 'package:serena/repositories/profile_repository.dart';
import 'package:serena/repositories/task_repository.dart';

/// Binding awal aplikasi. Satu-satunya tempat Get.put/lazyPut global.
/// Repositori didaftarkan lebih dulu, lalu controller meng-inject repo.
class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Repositories (plain class, tidak perlu GetxController).
    Get.lazyPut<AuthRepository>(AuthRepository.new);
    Get.lazyPut<ProfileRepository>(ProfileRepository.new);
    Get.lazyPut<TaskRepository>(TaskRepository.new);
    Get.lazyPut<FocusRepository>(FocusRepository.new);

    // Controllers.
    Get.put<AuthController>(
      AuthController(
        authRepo: Get.find(),
        profileRepo: Get.find(),
      ),
      permanent: true,
    );
    Get.lazyPut<UserController>(() => UserController(repo: Get.find()));
    Get.lazyPut<TaskController>(() => TaskController(repo: Get.find()));
    Get.lazyPut<FocusController>(() => FocusController(repo: Get.find()));
    Get.lazyPut<MainController>(MainController.new);
  }
}
