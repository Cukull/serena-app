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
    Get.lazyPut<AuthRepository>(AuthRepository.new, fenix: true);
    Get.lazyPut<ProfileRepository>(ProfileRepository.new, fenix: true);
    Get.lazyPut<TaskRepository>(TaskRepository.new, fenix: true);
    Get.lazyPut<FocusRepository>(FocusRepository.new, fenix: true);

    // Controllers.
    Get.put<AuthController>(
      AuthController(
        authRepo: Get.find(),
        profileRepo: Get.find(),
      ),
      permanent: true,
    );
    Get.put<UserController>(
      UserController(repo: Get.find()),
      permanent: true,
    );
    Get.put<TaskController>(
      TaskController(repo: Get.find()),
      permanent: true,
    );
    Get.put<FocusController>(
      FocusController(repo: Get.find()),
      permanent: true,
    );
    Get.put<MainController>(
      MainController(),
      permanent: true,
    );
  }
}
