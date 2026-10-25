import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:serena/controllers/auth_controller.dart';

class VerifyPage extends StatelessWidget {
  const VerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Verifikasi')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.mark_email_read_outlined, size: 64),
              const SizedBox(height: 16),
              Text(
                'Cek email kamu',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'Kami mengirim link verifikasi ke emailmu. '
                'Klik link tersebut, lalu kembali ke sini dan tekan tombol di bawah.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              Obx(
                () => ElevatedButton(
                  onPressed: auth.isLoading.value
                      ? null
                      : auth.confirmEmailVerified,
                  child: auth.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Saya sudah verifikasi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
