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

class VerifyPage extends StatelessWidget {
  const VerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      body: AppGradientBackground(
        gradient: AppColors.webPageBg,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthBrandHeader(
                  onBack: () => Get.offNamed<void>(Routes.login),
                ),
                const SizedBox(height: 28),
                Center(
                  child: Container(
                    width: 92,
                    height: 92,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE0F2FE),
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      width: 54,
                      height: 54,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1F2563EB),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        LucideIcons.mail,
                        size: 26,
                        color: AppColors.webLink,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Cek Email Kamu',
                  textAlign: TextAlign.center,
                  style: AppTypography.serif(25),
                ),
                const SizedBox(height: 8),
                Text(
                  'Kami mengirim link verifikasi ke email yang kamu daftarkan. '
                  'Klik link tersebut, lalu kembali ke sini dan tekan tombol '
                  'di bawah.',
                  textAlign: TextAlign.center,
                  style: AppTypography.body.copyWith(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.webSlate,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 28),
                Obx(
                  () => AppFillButton(
                    label: 'Saya sudah verifikasi',
                    onPressed:
                        auth.isLoading.value ? null : auth.confirmEmailVerified,
                    isLoading: auth.isLoading.value,
                    trailing: const Icon(
                      LucideIcons.arrowRight,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Center(
                  child: TextButton(
                    onPressed: () => Get.offNamed<void>(Routes.login),
                    child: Text(
                      'Kembali ke Masuk',
                      style: AppTypography.body.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
