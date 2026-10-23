import 'package:get/get.dart';

import 'package:serena/controllers/auth_controller.dart';
import 'package:serena/controllers/main_controller.dart';

/// Binding awal aplikasi. Satu-satunya tempat Get.put/lazyPut global.
/// Binding per fitur ditambahkan di sini seiring controller baru lahir.
class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get
      ..put<AuthController>(AuthController(), permanent: true)
      ..lazyPut<MainController>(MainController.new);
  }
}
