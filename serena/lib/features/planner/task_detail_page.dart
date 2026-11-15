// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:serena/app/app_routes.dart';
import 'package:serena/controllers/task_controller.dart';
import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_typography.dart';
import 'package:serena/core/widgets/app_ui.dart';
import 'package:serena/models/task.dart';

class TaskDetailPage extends StatelessWidget {
  const TaskDetailPage({super.key});

  Task? _find(String id) {
    for (final t in Get.find<TaskController>().tasks) {
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
        backgroundColor: AppColors.bgCream,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: AppCircleButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Get.back<void>(),
            semanticLabel: 'Kembali',
          ),
          leadingWidth: 60,
          title: Text('Detail Tugas', style: AppTypography.h2.copyWith(fontSize: 18)),
        ),
        body: const Center(child: Text('Task tidak ditemukan.')),
      );
    }

    return SerenaBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: AppCircleButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Get.back<void>(),
            semanticLabel: 'Kembali',
          ),
          leadingWidth: 60,
          title: Text(
            'Detail Tugas',
            style: AppTypography.h2.copyWith(fontSize: 18),
          ),
          actions: [
            AppCircleButton(
              icon: LucideIcons.pencil,
              onTap: () => Get.toNamed<void>(
                Routes.plannerEdit.replaceFirst(':id', task.id),
              ),
              semanticLabel: 'Edit tugas',
            ),
            const SizedBox(width: 8),
            AppCircleButton(
              icon: LucideIcons.trash2,
              onTap: () => _confirmDelete(context, task),
              semanticLabel: 'Hapus tugas',
              color: AppColors.danger,
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
          children: [
            // Title
            Text(task.title, style: AppTypography.h2),
            const SizedBox(height: 14),
            // Status + Priority chips
            Row(
              children: [
                _StatusChip(status: task.status),
                const SizedBox(width: 8),
                _PriorityChip(priority: task.priority),
              ],
            ),
            const SizedBox(height: 20),
            // Progress
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Progress', style: AppTypography.label),
                      Text(
                        '${task.progress}%',
                        style: AppTypography.label.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: task.progress / 100.0,
                      minHeight: 8,
                      backgroundColor: AppColors.progressTrack,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            // Deadline
            AppCard(
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _deadlineColor(task.deadline).withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      LucideIcons.calendarDays,
                      size: 20,
                      color: _deadlineColor(task.deadline),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Deadline', style: AppTypography.caption),
                        Text(
                          task.deadline == null
                              ? 'Tanpa deadline'
                              : DateFormat('d MMMM yyyy', 'id').format(
                                  task.deadline!.toLocal(),
                                ),
                          style: AppTypography.fieldValue.copyWith(
                            color: _deadlineColor(task.deadline),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (task.deadline != null)
                    _DeadlineIndicator(deadline: task.deadline!),
                ],
              ),
            ),
            const SizedBox(height: 14),
            // Description
            if (task.description != null && task.description!.isNotEmpty) ...[
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Deskripsi', style: AppTypography.label),
                    const SizedBox(height: 8),
                    Text(task.description!, style: AppTypography.body.copyWith(fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],
            // Action buttons
            if (task.status != TaskStatus.completed) ...[
              AppFilledButton(
                label: 'Tandai Selesai ✓',
                onTap: () => _markComplete(task),
              ),
              const SizedBox(height: 10),
            ],
            AppFilledButton(
              label: 'Edit Tugas',
              style: AppButtonStyle.ghost,
              onTap: () => Get.toNamed<void>(
                Routes.plannerEdit.replaceFirst(':id', task.id),
              ),
            ),
            const SizedBox(height: 10),
            AppFilledButton(
              label: 'Hapus Tugas',
              style: AppButtonStyle.danger,
              onTap: () => _confirmDelete(context, task),
            ),
          ],
        ),
      ),
    );
  }

  Color _deadlineColor(DateTime? deadline) {
    if (deadline == null) return AppColors.textFaint;
    final now = DateTime.now();
    final diff = deadline.difference(DateTime(now.year, now.month, now.day)).inDays;
    if (diff < 0) return AppColors.danger;
    if (diff <= 3) return AppColors.warnText;
    return AppColors.success;
  }

  Future<void> _markComplete(Task task) async {
    final ok = await Get.find<TaskController>().setStatus(task, TaskStatus.completed);
    if (ok) {
      Get.back<void>();
      Get.snackbar('Berhasil', 'Task selesai 🎉');
    }
  }

  Future<void> _confirmDelete(BuildContext context, Task task) async {
    await showAppSheet(
      context,
      title: 'Hapus Tugas?',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '"${task.title}" akan dihapus permanen.',
            textAlign: TextAlign.center,
            style: AppTypography.lead,
          ),
          const SizedBox(height: 18),
          AppFilledButton(
            label: 'Ya, hapus',
            style: AppButtonStyle.danger,
            onTap: () async {
              Navigator.of(context).pop();
              final ok =
                  await Get.find<TaskController>().deleteTask(task.id);
              if (ok) {
                Get.back<void>();
                Get.snackbar('Terhapus', 'Task dihapus.');
              }
            },
          ),
          const SizedBox(height: 10),
          AppFilledButton(
            label: 'Batal',
            style: AppButtonStyle.ghost,
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    final (bg, text) = switch (status) {
      TaskStatus.completed => (AppColors.chipGreenBg, AppColors.chipGreenText),
      TaskStatus.inProgress => (AppColors.chipBlueBg, AppColors.chipBlueText),
      TaskStatus.cancelled => (AppColors.glassBadge, AppColors.textMuted),
      TaskStatus.pending => (AppColors.chipVioletBg, AppColors.chipVioletText),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status.label,
        style: AppTypography.chipLabel.copyWith(color: text),
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  const _PriorityChip({required this.priority});
  final TaskPriority priority;

  @override
  Widget build(BuildContext context) {
    final (bg, text) = switch (priority) {
      TaskPriority.urgent => (AppColors.dangerTint, AppColors.danger),
      TaskPriority.high => (AppColors.chipPeachBg, AppColors.chipPeachText),
      TaskPriority.medium => (AppColors.chipBlueBg, AppColors.chipBlueText),
      TaskPriority.low => (AppColors.chipGreenBg, AppColors.chipGreenText),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        priority.label,
        style: AppTypography.chipLabel.copyWith(color: text),
      ),
    );
  }
}

class _DeadlineIndicator extends StatelessWidget {
  const _DeadlineIndicator({required this.deadline});
  final DateTime deadline;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final diff = deadline.difference(DateTime(now.year, now.month, now.day)).inDays;
    final color = diff < 0
        ? AppColors.danger
        : diff <= 3
            ? AppColors.warnText
            : AppColors.success;
    final label = diff < 0
        ? 'Terlambat'
        : diff == 0
            ? 'Hari ini'
            : '$diff hari';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
