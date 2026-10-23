import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_spacing.dart';
import 'package:serena/core/theme/app_typography.dart';
import 'package:serena/core/widgets/app_badges.dart';
import 'package:serena/core/widgets/app_gradient_button.dart';
import 'package:serena/core/widgets/app_link_row.dart';
import 'package:serena/core/widgets/app_logo.dart';
import 'package:serena/core/widgets/app_page_scaffold.dart';
import 'package:serena/core/widgets/app_wellbeing_stat.dart';
import 'package:serena/features/auth/controller/landing_controller.dart';

class LandingPage extends GetView<LandingController> {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      gradient: AppColors.bgOnboarding,
      scrollable: false,
      verticalPadding: AppSpacing.xl,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTop(),
                  _buildBottom(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTop() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xxl),
        const Center(child: AppLogoStacked()),
        const SizedBox(height: AppSpacing.xl),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Text(
            'Your safe space to stay productive while taking care of '
            'your mental well-being.',
            textAlign: TextAlign.center,
            style: AppTypography.lead,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        const Padding(
          padding: EdgeInsets.all(AppSpacing.cardPadding),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              AppTagChip.primary(label: 'Wellness', emoji: '🧘'),
              AppTagChip.secondary(label: 'Focus', emoji: '🎯'),
              AppTagChip.success(label: 'Sleep', emoji: '💤'),
              AppTagChip.primary(label: 'Progress', emoji: '📊'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const StreakMoodDeskCard(),
      ],
    );
  }

  Widget _buildBottom() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        AppGradientButton(
          label: 'Get Started',
          variant: AppButtonVariant.large,
          trailingIcon: Icons.arrow_forward_rounded,
          onPressed: controller.onGetStarted,
        ),
        const SizedBox(height: AppSpacing.xl),
        AppLinkRow(
          text: 'Already have an account?',
          linkText: 'Sign in',
          onTap: controller.onSignIn,
        ),
      ],
    );
  }
}
