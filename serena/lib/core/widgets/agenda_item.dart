// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';

import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_typography.dart';
import 'package:serena/models/task.dart';

/// Baris tugas: dot status berwarna, judul, waktu/meta, chip prioritas.
/// Matches agenda timeline-item in serena-web home/jadwal pages.
class AgendaItem extends StatelessWidget {
  const AgendaItem({
    required this.task,
    this.timeLabel,
    this.onTap,
    super.key,
  });

  final Task task;
  final String? timeLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorderCard),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F3C4682),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _dotColor(task.status),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: AppTypography.label.copyWith(
                      decoration: task.status == TaskStatus.completed
                          ? TextDecoration.lineThrough
                          : null,
                      color: task.status == TaskStatus.completed
                          ? AppColors.textMuted
                          : AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (timeLabel != null) ...[
                    const SizedBox(height: 2),
                    Text(timeLabel!, style: AppTypography.caption),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            _PriorityChip(priority: task.priority),
          ],
        ),
      ),
    );
  }

  Color _dotColor(TaskStatus status) => switch (status) {
        TaskStatus.completed => AppColors.success,
        TaskStatus.inProgress => AppColors.secondary,
        TaskStatus.cancelled => AppColors.textFaint,
        TaskStatus.pending => AppColors.primary,
      };
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        priority.label,
        style: AppTypography.caption.copyWith(
          color: text,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
