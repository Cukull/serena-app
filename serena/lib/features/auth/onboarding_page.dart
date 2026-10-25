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
  int _mood = 3;

  static const _moodEmojis = ['😞', '😕', '😐', '🙂', '😄'];

  @override
  void dispose() {
    _goal.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await Get.find<AuthController>().completeOnboarding(
      goal: _goal.text.trim(),
      moodScore: _mood,
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
                'Jawab dua hal singkat ini supaya pengalamanmu lebih personal.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Text('Apa tujuan utamamu?', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _goal,
                decoration: const InputDecoration(
                  hintText: 'Contoh: jaga produktivitas tanpa burnout',
                  border: OutlineInputBorder(),
                ),
                validator: AppValidators.required,
              ),
              const SizedBox(height: 24),
              Text('Bagaimana perasaanmu sekarang?', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (i) {
                  final value = i + 1;
                  final selected = _mood == value;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => setState(() => _mood = value),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: selected
                                ? Theme.of(context).colorScheme.primaryContainer
                                : null,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(_moodEmojis[i], style: const TextStyle(fontSize: 22)),
                              const SizedBox(height: 4),
                              Text('$value'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
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
