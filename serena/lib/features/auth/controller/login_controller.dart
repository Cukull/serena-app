import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:serena/app/app_routes.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailC = TextEditingController();
  final passC = TextEditingController();

  final isLoading = false.obs;

  /// Validasi baru aktif setelah user pertama kali menekan Sign In.
  final autoValidate = false.obs;

  String? validateEmail(String v) =>
      GetUtils.isEmail(v.trim()) ? null : 'Email tidak valid';

  String? validatePassword(String v) =>
      v.length >= 6 ? null : 'Minimal 6 karakter';

  Future<void> submit() async {
    if (isLoading.value) return;

    autoValidate.value = true;
    if (!(formKey.currentState?.validate() ?? false)) return;

    FocusManager.instance.primaryFocus?.unfocus();
    isLoading.value = true;
    try {
      final email = emailC.text.trim();
      final password = passC.text;

      // TODO: ganti dengan pemanggilan auth service (mis. Supabase/Firebase).
      await Future<void>.delayed(const Duration(seconds: 1));
      debugPrint('Login: $email (${password.length} karakter)');

      // TODO: Get.offAllNamed<void>(AppRoutes.home);
    } catch (e) {
      Get.snackbar('Login gagal', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    // TODO: implementasi Google Sign-In.
  }

  void goToSignUp() => Get.toNamed<void>(AppRoutes.register);

  @override
  void onClose() {
    emailC.dispose();
    passC.dispose();
    super.onClose();
  }
}
