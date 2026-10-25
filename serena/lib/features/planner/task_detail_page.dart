import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:serena/app/app_routes.dart';
import 'package:serena/controllers/task_controller.dart';
import 'package:serena/models/task.dart';

class TaskDetailPage extends StatelessWidget {
  const TaskDetailPage({super.key});

  Task? _find(String id) {
    final tasks = Get.find<TaskController>().tasks;
    for (final t in tasks) {
      if (t.id == id) return t;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final id = Get.parameters['id'] ?? '';
    final task = _find(id);
    if (task == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Task')),
        body: const Center(child: Text('Task tidak ditemukan.')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Task'),
        actions: [
          IconButton(
            onPressed: () =>
                Get.toNamed(Routes.plannerEdit.replaceFirst(':id', task.id)),
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () => _delete(task),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            _InfoRow(label: 'Status', value: task.status.label),
            _InfoRow(label: 'Prioritas', value: task.priority.label),
            _InfoRow(
              label: 'Deadline',
              value: task.deadline == null
                  ? 'Tanpa deadline'
                  : DateFormat('dd MMM yyyy').format(task.deadline!.toLocal()),
            ),
            if (task.description != null && task.description!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Deskripsi',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(task.description!),
            ],
            const SizedBox(height: 32),
            if (task.status != TaskStatus.completed)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _markComplete(task),
                  child: const Text('Tandai Selesai'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _markComplete(Task task) async {
    final ok = await Get.find<TaskController>()
        .setStatus(task, TaskStatus.completed);
    if (ok) {
      Get.back();
      Get.snackbar('Berhasil', 'Task selesai 🎉');
    }
  }

  Future<void> _delete(Task task) async {
    final ok = await Get.find<TaskController>().deleteTask(task.id);
    if (ok) {
      Get.back();
      Get.snackbar('Terhapus', 'Task dihapus.');
    }
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
