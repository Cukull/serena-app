import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:serena/app/app_routes.dart';
import 'package:serena/controllers/task_controller.dart';
import 'package:serena/models/task.dart';

class PlannerPage extends StatelessWidget {
  const PlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TaskController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Planner')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.plannerCreate),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (c.isLoading.value && c.tasks.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (c.errorMessage.value != null && c.tasks.isEmpty) {
          return _ErrorRetry(
            message: c.errorMessage.value!,
            onRetry: c.fetchTasks,
          );
        }
        final tasks = c.visibleTasks;
        if (tasks.isEmpty) {
          return const Center(child: Text('Tidak ada task.'));
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: _FilterBar(controller: c),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, i) {
                  final t = tasks[i];
                  return ListTile(
                    title: Text(
                      t.title,
                      style: TextStyle(
                        decoration: t.status == TaskStatus.completed
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Text(_subtitle(t)),
                    leading: _StatusDot(status: t.status),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Get.toNamed(
                      Routes.plannerDetail.replaceFirst(':id', t.id),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  String _subtitle(Task t) {
    final deadline = t.deadline;
    final deadlineText = deadline == null
        ? 'Tanpa deadline'
        : DateFormat('dd MMM yyyy').format(deadline.toLocal());
    return '$deadlineText · ${t.priority.label}';
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.controller});

  final TaskController controller;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Wrap(
      spacing: 8,
      children: [
        ChoiceChip(
          label: const Text('Semua'),
          selected: c.filter.value == null,
          onSelected: (_) {
            c.filter.value = null;
          },
        ),
        ChoiceChip(
          label: const Text('Upcoming'),
          selected: c.filter.value == TaskStatus.pending,
          onSelected: (_) {
            c.filter.value = TaskStatus.pending;
          },
        ),
        ChoiceChip(
          label: const Text('In Progress'),
          selected: c.filter.value == TaskStatus.inProgress,
          onSelected: (_) {
            c.filter.value = TaskStatus.inProgress;
          },
        ),
        ChoiceChip(
          label: const Text('Completed'),
          selected: c.filter.value == TaskStatus.completed,
          onSelected: (_) {
            c.filter.value = TaskStatus.completed;
          },
        ),
      ],
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.status});

  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      TaskStatus.completed => Colors.green,
      TaskStatus.inProgress => Colors.orange,
      TaskStatus.cancelled => Colors.grey,
      TaskStatus.pending => Colors.blue,
    };
    return CircleAvatar(radius: 5, backgroundColor: color);
  }
}

class _ErrorRetry extends StatelessWidget {
  const _ErrorRetry({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: onRetry, child: const Text('Coba lagi')),
        ],
      ),
    );
  }
}
