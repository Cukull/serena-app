import 'package:get/get.dart';

import 'package:serena/controllers/auth_controller.dart';
import 'package:serena/models/profile.dart';
import 'package:serena/repositories/profile_repository.dart';

/// Profil pengguna: lihat + edit nama.
class UserController extends GetxController {
  UserController({required this.repo});

  final ProfileRepository repo;
  final isLoading = false.obs;

  Profile? get profile => Get.find<AuthController>().user.value;

  Future<bool> updateName(String fullName) async {
    final id = profile?.id;
    if (id == null) return false;
    isLoading.value = true;
    try {
      await repo.updateProfile(id, fullName: fullName);
      final updated = await repo.fetchProfile(id);
      Get.find<AuthController>().user.value = updated;
      return true;
    } on Object {
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
