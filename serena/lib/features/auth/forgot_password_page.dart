import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:serena/app/app_routes.dart';
import 'package:serena/controllers/auth_controller.dart';
import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_typography.dart';
import 'package:serena/core/widgets/app_auth_brand.dart';
import 'package:serena/core/widgets/app_fill_button.dart';
import 'package:serena/core/widgets/app_gradient_background.dart';
import 'package:serena/core/widgets/app_pill_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  AuthController get _auth => Get.find<AuthController>();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await _auth.forgotPassword(_email.text.trim());
    final err = _auth.errorMessage.value;
    if (err != null && err.isNotEmpty) {
      Get.snackbar('Gagal mengirim', err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppGradientBackground(
        gradient: AppColors.webPageBg,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthBrandHeader(onBack: () => Get.back<void>()),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x1F5B8DEF),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: const Color(0x385B8DEF)),
                      ),
                      child: Text(
                        'PULIHKAN AKUN KAMU',
                        style: AppTypography.badgeLabel.copyWith(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.2,
                          color: const Color(0xFF5B8DEF),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('Lupa Kata Sandi?', style: AppTypography.serif(26)),
                  const SizedBox(height: 6),
                  Text(
                    'Masukkan email terdaftarmu di bawah ini, dan kami akan '
                    'mengirimkan link untuk mengatur ulang kata sandi.',
                    style: AppTypography.body.copyWith(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.webSlate,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
                    decoration: BoxDecoration(
                      color: const Color(0xF2FFFFFF),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: AppColors.webFieldBorder,
                        width: 1.5,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A1E293B),
                          blurRadius: 24,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'ALAMAT EMAIL',
                          style: AppTypography.sectionLabel.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: AppColors.textFaint,
                          ),
                        ),
                        const SizedBox(height: 10),
                        AppPillField(
                          controller: _email,
                          hint: 'nama@email.com',
                          validator: (v) {
                            final value = (v ?? '').trim();
                            if (value.isEmpty) return 'Email wajib diisi';
                            return GetUtils.isEmail(value)
                                ? null
                                : 'Email tidak valid';
                          },
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.email],
                          onSubmitted: (_) => _submit(),
                        ),
                        const SizedBox(height: 14),
                        Obx(
                          () => AppFillButton(
                            label: 'Kirim Link Reset',
                            onPressed: _submit,
                            isLoading: _auth.isLoading.value,
                            trailing: const Icon(
                              LucideIcons.arrowRight,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Ingat kata sandi Anda? ',
                        style: AppTypography.body.copyWith(
                          fontSize: 13,
                          color: AppColors.webSlate,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (Navigator.of(context).canPop()) {
                            Get.back<void>();
                          } else {
                            Get.offNamed<void>(Routes.login);
                          }
                        },
                        child: Text(
                          'Masuk',
                          style: AppTypography.body.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
