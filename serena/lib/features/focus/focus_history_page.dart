import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:serena/controllers/focus_controller.dart';
import 'package:serena/models/focus_session.dart';

class FocusHistoryPage extends StatefulWidget {
  const FocusHistoryPage({super.key});

  @override
  State<FocusHistoryPage> createState() => _FocusHistoryPageState();
}

class _FocusHistoryPageState extends State<FocusHistoryPage> {
  @override
  void initState() {
    super.initState();
    Get.find<FocusController>().fetchSessions();
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<FocusController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Fokus')),
      body: Obx(() {
        if (c.isLoading.value && c.sessions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (c.sessions.isEmpty) {
          return const Center(child: Text('Belum ada sesi fokus.'));
        }
        return ListView.builder(
          itemCount: c.sessions.length,
          itemBuilder: (context, i) {
            final s = c.sessions[i];
            return ListTile(
              leading: const Icon(Icons.timer_outlined),
              title: Text(s.mode.label),
              subtitle: Text(
                DateFormat('dd MMM yyyy, HH:mm').format(s.startedAt),
              ),
              trailing: Text('${s.actualMinutes ?? s.plannedMinutes} mnt'),
            );
          },
        );
      }),
    );
  }
}
