import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:serena/app/app_routes.dart';
import 'package:serena/controllers/auth_controller.dart';
import 'package:serena/core/theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Obx(() {
        final p = auth.user.value;
        final name = p?.displayName ?? 'Pengguna';
        final email = p?.email ?? '-';
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.secondary,
                  child: Text(
                    name.isEmpty ? '?' : name[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: Theme.of(context).textTheme.headlineMedium),
                      Text(email, style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Edit Profil'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Get.toNamed(Routes.editProfile),
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: const Text('Pengaturan'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Get.toNamed(Routes.settings),
                  ),
                  ListTile(
                    leading: const Icon(Icons.emoji_events_outlined),
                    title: const Text('Pencapaian'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Get.toNamed(Routes.achievements),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: auth.logout,
              icon: const Icon(Icons.logout),
              label: const Text('Keluar'),
            ),
          ],
        );
      }),
    );
  }
}
