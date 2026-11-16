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
import 'package:serena/core/widgets/app_password_strength.dart';
import 'package:serena/core/widgets/app_pill_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  AuthController get _auth => Get.find<AuthController>();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_password.text != _confirm.text) {
      Get.snackbar('Kata sandi tidak cocok', 'Ulangi konfirmasi kata sandi.');
      return;
    }
    await _auth.register(
      fullName: _name.text.trim(),
      email: _email.text.trim(),
      password: _password.text,
    );
    final err = _auth.errorMessage.value;
    if (err != null && err.isNotEmpty) {
      Get.snackbar('Gagal mendaftar', err);
    }
  }

  @override
  Widget build(BuildContext context) {
    final level = AppPasswordStrength.score(_password.text);
    final matches = _confirm.text.isNotEmpty && _confirm.text == _password.text;

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
                  const SizedBox(height: 18),
                  Text('Buat Akun Baru', style: AppTypography.serif(25)),
                  const SizedBox(height: 4),
                  Text(
                    'Bergabung dengan 12rb+ mahasiswa mengatur jadwal dan '
                    'belajar lebih fokus',
                    style: AppTypography.body.copyWith(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.webSlate,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppPillField(
                    controller: _name,
                    hint: 'Nama Lengkap',
                    icon: LucideIcons.user,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.name],
                    validator: (v) =>
                        (v ?? '').trim().isEmpty ? 'Nama wajib diisi' : null,
                  ),
                  const SizedBox(height: 13),
                  AppPillField(
                    controller: _email,
                    hint: 'Alamat Email',
                    validator: (v) {
                      final value = (v ?? '').trim();
                      if (value.isEmpty) return 'Email wajib diisi';
                      return GetUtils.isEmail(value)
                          ? null
                          : 'Email tidak valid';
                    },
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                  ),
                  const SizedBox(height: 13),
                  AppPillField(
                    controller: _password,
                    hint: 'Kata Sandi',
                    icon: LucideIcons.lock,
                    obscure: true,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.newPassword],
                    onChanged: (_) => setState(() {}),
                    validator: (v) =>
                        (v ?? '').length >= 6 ? null : 'Minimal 6 karakter',
                  ),
                  const SizedBox(height: 6),
                  _StrengthBar(level: level),
                  const SizedBox(height: 13),
                  AppPillField(
                    controller: _confirm,
                    hint: 'Konfirmasi Kata Sandi',
                    icon: LucideIcons.lock,
                    obscure: true,
                    textInputAction: TextInputAction.done,
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _submit(),
                    suffix: matches
                        ? const Icon(
                            LucideIcons.check,
                            size: 19,
                            color: Color(0xFF10B981),
                          )
                        : null,
                    validator: (v) =>
                        (v ?? '').isEmpty ? 'Konfirmasi kata sandi' : null,
                  ),
                  const SizedBox(height: 14),
                  Obx(
                    () => AppFillButton(
                      label: 'Buat Akun',
                      variant: AppFillVariant.emerald,
                      onPressed: _submit,
                      isLoading: _auth.isLoading.value,
                      leading: const Icon(
                        LucideIcons.check,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text.rich(
                    const TextSpan(
                      text: 'Dengan mendaftar, kamu menyetujui ',
                      children: [
                        TextSpan(
                          text: 'Ketentuan Layanan',
                          style: TextStyle(color: AppColors.primary),
                        ),
                        TextSpan(text: ' dan '),
                        TextSpan(
                          text: 'Kebijakan Privasi',
                          style: TextStyle(color: AppColors.primary),
                        ),
                        TextSpan(text: ' kami.'),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: AppTypography.caption.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Sudah punya akun? ',
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

class _StrengthBar extends StatelessWidget {
  const _StrengthBar({required this.level});

  final int level;

  static const _labels = [
    '',
    'Kekuatan kata sandi lemah — tambahkan 8 karakter',
    'Kekuatan kata sandi cukup — tambahkan angka',
    'Kekuatan kata sandi baik — coba tambahkan simbol',
    'Kekuatan kata sandi kuat',
  ];
  static const _colors = [
    AppColors.progressTrack,
    AppColors.danger,
    Color(0xFFF59E0B),
    Color(0xFF3B82F6),
    Color(0xFF10B981),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (i) {
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                height: 4,
                margin: EdgeInsets.only(right: i == 3 ? 0 : 5),
                decoration: BoxDecoration(
                  color: i < level ? _colors[level] : AppColors.progressTrack,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        if (level > 0) ...[
          const SizedBox(height: 6),
          Text(
            _labels[level],
            style: AppTypography.caption.copyWith(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: _colors[level],
            ),
          ),
        ],
      ],
    );
  }
}
