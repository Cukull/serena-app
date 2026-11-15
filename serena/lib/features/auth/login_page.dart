import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:serena/app/app_assets.dart';
import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_typography.dart';
import 'package:serena/core/widgets/app_auth_brand.dart';
import 'package:serena/core/widgets/app_fill_button.dart';
import 'package:serena/core/widgets/app_gradient_background.dart';
import 'package:serena/core/widgets/app_pill_field.dart';
import 'package:serena/features/auth/controller/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  static const _divider = Expanded(
    child: Divider(color: AppColors.divider),
  );

  static const _googleLogoSvg = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
  <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/>
  <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/>
  <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.06H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.94l2.85-2.22.81-.63z" fill="#FBBC05"/>
  <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.06l3.66 2.84c.87-2.6 3.3-4.52 6.16-4.52z" fill="#EA4335"/>
</svg>''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppGradientBackground(
        gradient: AppColors.webPageBg,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      child: Obx(
                        () => Form(
                          key: controller.formKey,
                          autovalidateMode: controller.autoValidate.value
                              ? AutovalidateMode.onUserInteraction
                              : AutovalidateMode.disabled,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AuthBrandHeader(onTap: () => Get.back<void>()),
                              const SizedBox(height: 14),
                              Center(
                                child: SvgPicture.asset(
                                  AppAssets.loginHammock,
                                  height: 142,
                                )
                                    .animate(
                                      onPlay: (c) => c.repeat(reverse: true),
                                    )
                                    .rotate(
                                      begin: -0.012,
                                      end: 0.012,
                                      duration: 2200.ms,
                                      curve: Curves.easeInOut,
                                    )
                                    .moveY(
                                      begin: 0,
                                      end: -3,
                                      duration: 2200.ms,
                                      curve: Curves.easeInOut,
                                    ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Selamat Datang Kembali',
                                style: AppTypography.serif(26),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Atur jadwal kuliah, kelola tugas, '
                                'dan raih fokus terbaikmu.',
                                style: AppTypography.body.copyWith(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.webSlate,
                                ),
                              ),
                              const SizedBox(height: 20),
                              AppPillField(
                                controller: controller.emailC,
                                hint: 'nama@student.edu',
                                validator: (v) =>
                                    controller.validateEmail(v ?? ''),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [AutofillHints.email],
                              ),
                              const SizedBox(height: 14),
                              AppPillField(
                                controller: controller.passC,
                                hint: 'Kata sandi',
                                icon: LucideIcons.lock,
                                obscure: true,
                                validator: (v) =>
                                    controller.validatePassword(v ?? ''),
                                textInputAction: TextInputAction.done,
                                autofillHints: const [AutofillHints.password],
                                onSubmitted: (_) => controller.submit(),
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: controller.goToForgotPassword,
                                  behavior: HitTestBehavior.opaque,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                      horizontal: 4,
                                    ),
                                    child: Text(
                                      'Lupa Kata Sandi?',
                                      style: AppTypography.body.copyWith(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              AppFillButton(
                                label: 'Masuk',
                                onPressed: controller.submit,
                                isLoading: controller.isLoading.value,
                                leading: const Icon(
                                  LucideIcons.arrowRight,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  _divider,
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                    ),
                                    child: Text(
                                      'atau lanjutkan dengan',
                                      style: AppTypography.caption.copyWith(
                                        color: AppColors.textFaint,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  _divider,
                                ],
                              ),
                              const SizedBox(height: 16),
                              AppFillButton(
                                label: 'Lanjutkan dengan Google',
                                variant: AppFillVariant.outline,
                                onPressed: controller.signInWithGoogle,
                                leading: SvgPicture.string(
                                  _googleLogoSvg,
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    'Belum punya akun? ',
                                    style: AppTypography.body.copyWith(
                                      fontSize: 13,
                                      color: AppColors.webSlate,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: controller.goToSignUp,
                                    child: Text(
                                      'Buat Akun Baru',
                                      style: AppTypography.body.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 22),
                              const _SocialProof(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SocialProof extends StatelessWidget {
  const _SocialProof();

  static const _people = [
    ('S', Color(0xFFDBEAFE), Color(0xFF2563EB)),
    ('A', Color(0xFFEDE9FE), Color(0xFF7C3AED)),
    ('R', Color(0xFFD1FAE5), Color(0xFF059669)),
    ('M', Color(0xFFFEF3C7), Color(0xFFB45309)),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 70,
          height: 24,
          child: Stack(
            children: [
              for (var i = 0; i < _people.length; i++)
                Positioned(
                  left: i * 16,
                  child: Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _people[i].$2,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Text(
                      _people[i].$1,
                      style: AppTypography.avatarInitial.copyWith(
                        color: _people[i].$3,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            '12rb+ mahasiswa telah berkembang',
            style: AppTypography.caption.copyWith(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.webSlate,
            ),
          ),
        ),
      ],
    );
  }
}
