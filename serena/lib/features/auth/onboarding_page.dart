import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:serena/controllers/auth_controller.dart';
import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_typography.dart';
import 'package:serena/core/widgets/app_fill_button.dart';
import 'package:serena/core/widgets/app_gradient_background.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _formKey = GlobalKey<FormState>();
  final _goal = TextEditingController();

  @override
  void dispose() {
    _goal.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusManager.instance.primaryFocus?.unfocus();
    await Get.find<AuthController>().completeOnboarding(
      goal: _goal.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.webFieldBorder, width: 1.3),
    );
    final inputFocusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.webLink, width: 1.6),
    );

    return Scaffold(
      body: AppGradientBackground(
        gradient: AppColors.webPageBg,
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SizedBox(
                  height: 44,
                  child: Center(
                    child: Text(
                      'Kenalan Dulu',
                      style: AppTypography.cardTitle.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.webHeading,
                      ),
                    ),
                  ),
                ),
              ),

              // Body Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          'Selamat datang di Serena! 🌿',
                          style: AppTypography.serif(26).copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.webHeading,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ceritakan tujuanmu supaya pengalamanmu lebih personal.',
                          style: AppTypography.body.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.webSlate,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          'Apa tujuan utamamu?',
                          style: AppTypography.body.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.webHeading,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _goal,
                          style: AppTypography.body.copyWith(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.webHeading,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText:
                                'Contoh: jaga produktivitas tanpa burnout',
                            hintStyle: AppTypography.body.copyWith(
                              fontSize: 14,
                              color: AppColors.webSlate.withValues(alpha: 0.7),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 16,
                            ),
                            border: inputBorder,
                            enabledBorder: inputBorder,
                            focusedBorder: inputFocusedBorder,
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Tuliskan tujuanmu terlebih dahulu';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Obx(() {
                          final err = auth.errorMessage.value;
                          if (err == null || err.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFFCA5A5),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  LucideIcons.alertCircle,
                                  size: 18,
                                  color: Color(0xFFDC2626),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    err,
                                    style: AppTypography.caption.copyWith(
                                      color: const Color(0xFFDC2626),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 8),
                        Obx(
                          () => AppFillButton(
                            label: 'Selesai',
                            onPressed:
                                auth.isLoading.value ? null : _submit,
                            isLoading: auth.isLoading.value,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
