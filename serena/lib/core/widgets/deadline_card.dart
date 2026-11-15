// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_typography.dart';
import 'package:serena/models/task.dart';

/// Kartu tenggat dengan progress bar + sisa hari.
/// Matches deadline-card in serena-web home/jadwal pages.
class DeadlineCard extends StatelessWidget {
  const DeadlineCard({
    required this.task,
    this.onTap,
    super.key,
  });

  final Task task;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final deadline = task.deadline;
    final now = DateTime.now();
    final daysLeft = deadline == null
        ? null
        : deadline.difference(DateTime(now.year, now.month, now.day)).inDays;

    final (urgencyColor, urgencyLabel) = _urgency(daysLeft);
    final progress = task.progress / 100.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.glassBorderCard),
          boxShadow: const [
            BoxShadow(
              color: Color(0x123C4682),
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: urgencyColor.withAlpha(25),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: urgencyColor.withAlpha(40),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'DEADLINE ${urgencyLabel.toUpperCase()}',
                      style: AppTypography.caption.copyWith(
                        color: urgencyColor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.alarm_rounded, size: 16, color: urgencyColor),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: AppTypography.label.copyWith(fontSize: 15),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deadline == null
                        ? 'Tanpa deadline'
                        : 'Batas: ${DateFormat('d MMM yyyy', 'id').format(deadline.toLocal())}',
                    style: AppTypography.caption,
                  ),
                  const SizedBox(height: 10),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: AppColors.progressTrack,
                      valueColor: AlwaysStoppedAnimation<Color>(urgencyColor),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${task.progress}% selesai',
                        style: AppTypography.caption,
                      ),
                      if (daysLeft != null)
                        Text(
                          daysLeft < 0
                              ? 'Terlambat ${-daysLeft}h'
                              : daysLeft == 0
                                  ? 'Hari ini!'
                                  : '$daysLeft hari lagi',
                          style: AppTypography.caption.copyWith(
                            color: urgencyColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  (Color, String) _urgency(int? daysLeft) {
    if (daysLeft == null) return (AppColors.textFaint, 'mendekati');
    if (daysLeft < 0) return (AppColors.danger, 'terlewat');
    if (daysLeft == 0) return (AppColors.danger, 'hari ini');
    if (daysLeft <= 3) return (AppColors.warnText, 'mendekat');
    return (AppColors.success, 'aman');
  }
}
