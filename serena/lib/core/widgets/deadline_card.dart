// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/models/task.dart';

/// Kartu tenggat terdekat sesuai desain serena-web (upcoming-deadline).
class DeadlineCard extends StatelessWidget {
  const DeadlineCard({
    required this.title,
    required this.subtitle,
    this.tag = 'DEADLINE MENDEKAT',
    this.progress = 0.58,
    this.badges = const [
      (label: 'Segera', isUrgent: true),
      (label: 'LMS', isUrgent: false),
    ],
    this.onTap,
    super.key,
  });

  factory DeadlineCard.fromTask({
    required Task task,
    VoidCallback? onTap,
  }) {
    final deadline = task.deadline;
    final now = DateTime.now();
    final daysLeft = deadline?.difference(
      DateTime(now.year, now.month, now.day),
    ).inDays;

    final String subtitle;
    if (deadline == null) {
      subtitle = 'Tanpa batas waktu';
    } else if (daysLeft == 0) {
      final hour = deadline.toLocal().hour.toString().padLeft(2, '0');
      final minute = deadline.toLocal().minute.toString().padLeft(2, '0');
      subtitle = 'Batas waktu: Hari ini, $hour.$minute WIB';
    } else if (daysLeft != null && daysLeft < 0) {
      subtitle = 'Terlambat ${-daysLeft} hari';
    } else {
      subtitle = 'Batas: $daysLeft hari lagi';
    }

    final isUrgent = daysLeft != null && daysLeft <= 2;
    final badges = <({String label, bool isUrgent})>[
      (label: task.priority.label, isUrgent: isUrgent),
      (label: 'LMS', isUrgent: false),
    ];

    return DeadlineCard(
      title: task.title,
      subtitle: subtitle,
      progress: (task.progress / 100.0).clamp(0.0, 1.0),
      badges: badges,
      onTap: onTap,
    );
  }

  final String title;
  final String subtitle;
  final String tag;
  final double progress;
  final List<({String label, bool isUrgent})> badges;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFF5F5), Color(0xFFFFF0F1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF6CFD2)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1FDE5050),
              blurRadius: 18,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header: Tag + Bell
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                    color: Color(0xFFE5757C),
                  ),
                ),
                const Icon(
                  LucideIcons.alarmClock,
                  size: 20,
                  color: Color(0xFFE5646B),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Body: Info (Left) + Metrics & Badges (Right)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 104,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          height: 7,
                          width: double.infinity,
                          color: const Color(0xFFF1DFE1),
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: progress.clamp(0.05, 1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF8A93),
                                    Color(0xFFE5646B),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Badges Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          for (final b in badges) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 3.5,
                              ),
                              decoration: BoxDecoration(
                                color: b.isUrgent
                                    ? const Color(0xFFFFE4E6)
                                    : const Color(0xFFE0F2FE),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                b.label,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: b.isUrgent
                                      ? const Color(0xFFE5646B)
                                      : const Color(0xFF0284C7),
                                ),
                              ),
                            ),
                            if (b != badges.last) const SizedBox(width: 6),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
