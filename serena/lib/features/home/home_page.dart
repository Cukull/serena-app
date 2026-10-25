import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:serena/controllers/auth_controller.dart';
import 'package:serena/controllers/main_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final name = auth.user.value?.displayName ?? 'Pengguna';
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Halo, $name 👋',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'Apa yang ingin kamu kerjakan hari ini?',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              _QuickCard(
                icon: LucideIcons.calendarDays,
                title: 'Planner',
                subtitle: 'Atur task & deadline',
                onTap: () => MainController.to.goTab(1),
              ),
              _QuickCard(
                icon: LucideIcons.timer,
                title: 'Focus',
                subtitle: 'Mulai sesi fokus',
                onTap: () => MainController.to.goTab(2),
              ),
              _QuickCard(
                icon: LucideIcons.heartPulse,
                title: 'Wellness',
                subtitle: 'Catat mood, habit & tidur',
                onTap: () => MainController.to.goTab(3),
              ),
              _QuickCard(
                icon: LucideIcons.user,
                title: 'Profil',
                subtitle: 'Lihat profil & pengaturan',
                onTap: () => MainController.to.goTab(4),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  const _QuickCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
