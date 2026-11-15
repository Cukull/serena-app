// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:serena/controllers/focus_controller.dart';
import 'package:serena/controllers/task_controller.dart';
import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_typography.dart';
import 'package:serena/core/widgets/app_ui.dart';
import 'package:serena/models/focus_session.dart';
import 'package:serena/models/task.dart';

/// Halaman Statistik — tab Harian/Mingguan/Bulanan + bar chart custom.
/// Sesuai serena-web/pages/statistik/index.html
class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  int _filter = 0; // 0=tersisa, 1=fokus, 2=selesai

  static const _filters = ['Tugas tersisa', 'Waktu fokus', 'Selesai'];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _tab.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text('Statistik', style: AppTypography.h2.copyWith(fontSize: 20)),
          bottom: TabBar(
            controller: _tab,
            tabs: const [
              Tab(text: 'Harian'),
              Tab(text: 'Mingguan'),
              Tab(text: 'Bulanan'),
            ],
            labelStyle: AppTypography.label,
            unselectedLabelStyle: AppTypography.subtitle,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textMuted,
            indicatorColor: AppColors.primary,
          ),
        ),
        body: Column(
          children: [
            // Filter chips
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  for (int i = 0; i < _filters.length; i++) ...[
                    GestureDetector(
                      onTap: () => setState(() => _filter = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: _filter == i
                              ? AppColors.primary
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _filter == i
                                ? AppColors.primary
                                : AppColors.glassBorderCard,
                          ),
                        ),
                        child: Text(
                          _filters[i],
                          style: AppTypography.chipLabel.copyWith(
                            color: _filter == i
                                ? AppColors.white
                                : AppColors.textMuted,
                          ),
                        ),
                      ),
                    ),
                    if (i < _filters.length - 1) const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                final taskCtrl = Get.find<TaskController>();
                final focusCtrl = Get.find<FocusController>();
                return TabBarView(
                  controller: _tab,
                  children: [
                    _ChartView(
                      period: _Period.daily,
                      filter: _filter,
                      tasks: taskCtrl.tasks,
                      sessions: focusCtrl.sessions,
                    ),
                    _ChartView(
                      period: _Period.weekly,
                      filter: _filter,
                      tasks: taskCtrl.tasks,
                      sessions: focusCtrl.sessions,
                    ),
                    _ChartView(
                      period: _Period.monthly,
                      filter: _filter,
                      tasks: taskCtrl.tasks,
                      sessions: focusCtrl.sessions,
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

enum _Period { daily, weekly, monthly }

class _ChartView extends StatelessWidget {
  const _ChartView({
    required this.period,
    required this.filter,
    required this.tasks,
    required this.sessions,
  });

  final _Period period;
  final int filter;
  final List<Task> tasks;
  final List<FocusSession> sessions;

  List<_BarData> _buildBars() {
    final now = DateTime.now();
    return switch (period) {
      _Period.daily => List.generate(7, (i) {
          final d = now.subtract(Duration(days: 6 - i));
          final label = _dayLabel(d.weekday);
          return _BarData(label: label, value: _valueFor(d, d));
        }),
      _Period.weekly => List.generate(6, (i) {
          final weekStart = now.subtract(Duration(days: now.weekday - 1 + (5 - i) * 7));
          final weekEnd = weekStart.add(const Duration(days: 6));
          final label = 'W${i + 1}';
          return _BarData(label: label, value: _valueFor(weekStart, weekEnd));
        }),
      _Period.monthly => List.generate(6, (i) {
          final m = DateTime(now.year, now.month - (5 - i));
          final label = _monthLabel(m.month);
          final start = DateTime(m.year, m.month);
          final end = DateTime(m.year, m.month + 1).subtract(const Duration(seconds: 1));
          return _BarData(label: label, value: _valueFor(start, end));
        }),
    };
  }

  double _valueFor(DateTime start, DateTime end) {
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day, 23, 59, 59);
    switch (filter) {
      case 0: // Tugas tersisa
        return tasks
            .where((t) {
              final d = t.deadline?.toLocal();
              if (d == null) return false;
              return !d.isBefore(s) && !d.isAfter(e) &&
                  t.status != TaskStatus.completed &&
                  t.status != TaskStatus.cancelled;
            })
            .length
            .toDouble();
      case 1: // Waktu fokus (minutes)
        return sessions
            .where((s2) {
              final d = s2.startedAt;
              return !d.isBefore(s) && !d.isAfter(e);
            })
            .fold<double>(0, (sum, s2) => sum + (s2.actualMinutes ?? 0));
      case 2: // Selesai
        return tasks
            .where((t) {
              final d = t.completedAt?.toLocal();
              if (d == null) return false;
              return !d.isBefore(s) && !d.isAfter(e);
            })
            .length
            .toDouble();
      default:
        return 0;
    }
  }

  String _dayLabel(int weekday) {
    const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return days[(weekday - 1) % 7];
  }

  String _monthLabel(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return months[(month - 1) % 12];
  }

  @override
  Widget build(BuildContext context) {
    final bars = _buildBars();
    final maxVal = bars.fold<double>(0, (m, b) => b.value > m ? b.value : m);

    final total = bars.fold<double>(0, (s, b) => s + b.value);
    final avg = bars.isEmpty ? 0.0 : total / bars.length;
    final highest = maxVal;

    final unitLabel = filter == 1 ? 'mnt' : 'tugas';

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
      children: [
        // Bar chart
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                filter == 0
                    ? 'Tugas Tersisa'
                    : filter == 1
                        ? 'Waktu Fokus (menit)'
                        : 'Tugas Selesai',
                style: AppTypography.cardTitle,
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 160,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final bar in bars) ...[
                      Expanded(
                        child: _Bar(
                          value: bar.value,
                          maxValue: maxVal == 0 ? 1 : maxVal,
                          label: bar.label,
                        ),
                      ),
                      if (bar != bars.last) const SizedBox(width: 6),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Summary row
        Row(
          children: [
            Expanded(
              child: _SummaryTile(
                icon: LucideIcons.trendingUp,
                label: 'Rata-rata',
                value: avg.toStringAsFixed(1),
                unit: unitLabel,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SummaryTile(
                icon: LucideIcons.award,
                label: 'Tertinggi',
                value: highest.toStringAsFixed(0),
                unit: unitLabel,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SummaryTile(
                icon: LucideIcons.sigma,
                label: 'Total',
                value: total.toStringAsFixed(0),
                unit: unitLabel,
                color: AppColors.success,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BarData {
  _BarData({required this.label, required this.value});
  final String label;
  final double value;
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.value,
    required this.maxValue,
    required this.label,
  });

  final double value;
  final double maxValue;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ratio = (value / maxValue).clamp(0.0, 1.0);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (value > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              value.toStringAsFixed(0),
              style: AppTypography.caption.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        Flexible(
          child: FractionallySizedBox(
            heightFactor: ratio < 0.05 ? 0.05 : ratio,
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: AppTypography.caption),
      ],
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 8),
          Text(
            '$value $unit',
            style: AppTypography.statBig.copyWith(color: color, fontSize: 16),
          ),
          Text(label, style: AppTypography.caption),
        ],
      ),
    );
  }
}
