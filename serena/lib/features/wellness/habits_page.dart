import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:serena/controllers/habit_controller.dart';
import 'package:serena/models/habit.dart';

class HabitsPage extends StatelessWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HabitController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Habit')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAdd(context),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (c.isLoading.value && c.habits.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (c.habits.isEmpty) {
          return const Center(child: Text('Belum ada habit.'));
        }
        return ListView.builder(
          itemCount: c.habits.length,
          itemBuilder: (context, i) {
            final h = c.habits[i];
            return ListTile(
              leading: Checkbox(
                value: c.isDone(h),
                onChanged: (_) => c.toggle(h),
              ),
              title: Text(h.title),
              subtitle: Text(h.frequency.label),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => c.deleteHabit(h.id),
              ),
            );
          },
        );
      }),
    );
  }

  void _showAdd(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => const _AddHabitDialog(),
    );
  }
}

class _AddHabitDialog extends StatefulWidget {
  const _AddHabitDialog();

  @override
  State<_AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<_AddHabitDialog> {
  final _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final ok = await Get.find<HabitController>().createHabit(_title.text.trim());
    if (ok) {
      Get.back();
      Get.snackbar('Berhasil', 'Habit ditambahkan.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Habit baru'),
      content: TextField(
        controller: _title,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Nama habit',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
        ElevatedButton(onPressed: _save, child: const Text('Simpan')),
      ],
    );
  }
}
