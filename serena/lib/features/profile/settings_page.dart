import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:serena/controllers/auth_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _box = GetStorage();
  late bool _notifications = _box.read<bool>('notifications_enabled') ?? true;

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SwitchListTile(
            title: const Text('Pengingat'),
            subtitle: const Text('Aktifkan notifikasi pengingat'),
            value: _notifications,
            onChanged: (v) {
              setState(() => _notifications = v);
              _box.write('notifications_enabled', v);
            },
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: auth.logout,
            icon: const Icon(Icons.logout),
            label: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
