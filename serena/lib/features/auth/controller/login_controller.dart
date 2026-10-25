import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:serena/app/app_routes.dart';
import 'package:serena/controllers/auth_controller.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailC = TextEditingController();
  final passC = TextEditingController();

  final isLoading = false.obs;

  /// Validasi baru aktif setelah user pertama kali menekan Sign In.
  final autoValidate = false.obs;

  AuthController get auth => Get.find<AuthController>();

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
      await auth.login(email: emailC.text.trim(), password: passC.text);
      final err = auth.errorMessage.value;
      if (err != null && err.isNotEmpty) {
        Get.snackbar('Login gagal', err);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    Get.snackbar('Belum tersedia', 'Login dengan Google belum diaktifkan.');
  }

  void goToSignUp() => Get.toNamed<void>(Routes.register);

  void goToForgotPassword() => Get.toNamed<void>(Routes.forgotPassword);

  @override
  void onClose() {
    emailC.dispose();
    passC.dispose();
    super.onClose();
  }
}
