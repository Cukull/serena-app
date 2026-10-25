import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:serena/app/app_routes.dart';

class WellnessPage extends StatelessWidget {
  const WellnessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wellness')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Jaga kesejahteraanmu',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          _WellnessCard(
            icon: LucideIcons.sun,
            title: 'Mood',
            subtitle: 'Catat & pantau perasaanmu',
            onTap: () => Get.toNamed(Routes.mood),
          ),
          _WellnessCard(
            icon: LucideIcons.sprout,
            title: 'Habit',
            subtitle: 'Bangun kebiasaan baik',
            onTap: () => Get.toNamed(Routes.habits),
          ),
          _WellnessCard(
            icon: LucideIcons.moon,
            title: 'Tidur',
            subtitle: 'Pantau pola tidurmu',
            onTap: () => Get.toNamed(Routes.sleep),
          ),
        ],
      ),
    );
  }
}

class _WellnessCard extends StatelessWidget {
  const _WellnessCard({
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
