import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:serena/controllers/auth_controller.dart';
import 'package:serena/core/validators/validators.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _goal = TextEditingController();

  @override
  void dispose() {
    _goal.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await Get.find<AuthController>().completeOnboarding(
      goal: _goal.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Kenalan Dulu')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Selamat datang di Serena! 🌿',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Ceritakan tujuanmu supaya pengalamanmu lebih personal.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Text(
                'Apa tujuan utamamu?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _goal,
                decoration: const InputDecoration(
                  hintText: 'Contoh: jaga produktivitas tanpa burnout',
                  border: OutlineInputBorder(),
                ),
                validator: AppValidators.required,
              ),
              const SizedBox(height: 32),
              Obx(() {
                final err = auth.errorMessage.value;
                if (err == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    err,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                );
              }),
              Obx(
                () => ElevatedButton(
                  onPressed: auth.isLoading.value ? null : _submit,
                  child: auth.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Selesai'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
