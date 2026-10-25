import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:serena/core/theme/app_spacing.dart';
import 'package:serena/core/theme/app_typography.dart';
import 'package:serena/core/widgets/app_divider_label.dart';
import 'package:serena/core/widgets/app_form_card.dart';
import 'package:serena/core/widgets/app_google_button.dart';
import 'package:serena/core/widgets/app_gradient_button.dart';
import 'package:serena/core/widgets/app_link_row.dart';
import 'package:serena/core/widgets/app_logo.dart';
import 'package:serena/core/widgets/app_page_scaffold.dart';
import 'package:serena/core/widgets/app_text_field.dart';
import 'package:serena/core/widgets/app_wellbeing_stat.dart';
import 'package:serena/features/auth/controller/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      horizontalPadding: AppSpacing.screenHLogin,
      child: Column(
        children: [
          const SizedBox(height: 24),
          const AppLogo(showTagline: true),
          const SizedBox(height: 28),
          const FocusHammockCard(),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.cardPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome Back 👋', style: AppTypography.h1),
                  const SizedBox(height: 4),
                  Text('Sign in to continue', style: AppTypography.subtitle),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppFormCard(
            child: AutofillGroup(
              child: Form(
                key: controller.formKey,
                child: Obx(() {
                  final mode = controller.autoValidate.value
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        controller: controller.emailC,
                        hint: 'Email',
                        prefixIcon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                        autovalidateMode: mode,
                        validator: controller.validateEmail,
                      ),
                      const SizedBox(height: AppSpacing.fieldGap),
                      AppTextField(
                        controller: controller.passC,
                        hint: 'Password',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                        autovalidateMode: mode,
                        validator: controller.validatePassword,
                        onSubmitted: (_) => controller.submit(),
                      ),
                      const SizedBox(height: 18),
                      AppGradientButton(
                        label: 'Sign In',
                        isLoading: controller.isLoading.value,
                        onPressed: controller.submit,
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: controller.goToForgotPassword,
                          child: const Text('Forgot password?'),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const AppDividerLabel(),
                      const SizedBox(height: 18),
                      AppGoogleButton(
                        onPressed: controller.signInWithGoogle,
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 20),
          AppLinkRow(
            text: "Don't have an account?",
            linkText: 'Sign Up',
            onTap: controller.goToSignUp,
          ),
        ],
      ),
    );
  }
}
