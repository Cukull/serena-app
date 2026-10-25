import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:serena/app/app_routes.dart';

class FocusPage extends StatelessWidget {
  const FocusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Focus')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Pilih mode fokusmu',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          _ModeCard(
            icon: LucideIcons.timer,
            title: 'Pomodoro',
            subtitle: '25 menit fokus · 5 menit istirahat',
            onTap: () => Get.toNamed(Routes.pomodoro),
          ),
          _ModeCard(
            icon: LucideIcons.brain,
            title: 'Deep Focus',
            subtitle: 'Durasi bebas, tanpa interupsi',
            onTap: () => Get.toNamed(Routes.deepFocus),
          ),
          _ModeCard(
            icon: LucideIcons.shield,
            title: 'Exam Mode',
            subtitle: 'Sesi panjang + blokir gangguan',
            onTap: () => Get.toNamed(Routes.examMode),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => Get.toNamed(Routes.focusHistory),
            icon: const Icon(Icons.history),
            label: const Text('Riwayat Fokus'),
          ),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
