import 'package:get/get.dart';

import 'package:serena/controllers/auth_controller.dart';
import 'package:serena/controllers/focus_controller.dart';
import 'package:serena/controllers/habit_controller.dart';
import 'package:serena/controllers/main_controller.dart';
import 'package:serena/controllers/mood_controller.dart';
import 'package:serena/controllers/sleep_controller.dart';
import 'package:serena/controllers/task_controller.dart';
import 'package:serena/controllers/user_controller.dart';
import 'package:serena/repositories/auth_repository.dart';
import 'package:serena/repositories/focus_repository.dart';
import 'package:serena/repositories/habit_repository.dart';
import 'package:serena/repositories/mood_repository.dart';
import 'package:serena/repositories/profile_repository.dart';
import 'package:serena/repositories/sleep_repository.dart';
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
    Get.lazyPut<MoodRepository>(MoodRepository.new);
    Get.lazyPut<HabitRepository>(HabitRepository.new);
    Get.lazyPut<SleepRepository>(SleepRepository.new);
    Get.lazyPut<FocusRepository>(FocusRepository.new);

    // Controllers.
    Get.put<AuthController>(
      AuthController(
        authRepo: Get.find(),
        profileRepo: Get.find(),
        moodRepo: Get.find(),
      ),
      permanent: true,
    );
    Get.lazyPut<UserController>(() => UserController(repo: Get.find()));
    Get.lazyPut<TaskController>(() => TaskController(repo: Get.find()));
    Get.lazyPut<MoodController>(() => MoodController(repo: Get.find()));
    Get.lazyPut<HabitController>(() => HabitController(repo: Get.find()));
    Get.lazyPut<SleepController>(() => SleepController(repo: Get.find()));
    Get.lazyPut<FocusController>(() => FocusController(repo: Get.find()));
    Get.lazyPut<MainController>(MainController.new);
  }
}
