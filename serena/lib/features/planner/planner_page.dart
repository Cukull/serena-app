// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:serena/app/app_routes.dart';
import 'package:serena/controllers/task_controller.dart';
import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_typography.dart';
import 'package:serena/core/widgets/agenda_item.dart';
import 'package:serena/core/widgets/app_ui.dart';
import 'package:serena/models/task.dart';

String _safeFormatMonth(DateTime date) {
  try {
    return DateFormat('MMMM yyyy', 'id').format(date);
  } catch (_) {
    try {
      return DateFormat('MMMM yyyy', 'id_ID').format(date);
    } catch (_) {
      return DateFormat('MMMM yyyy').format(date);
    }
  }
}

class PlannerPage extends StatefulWidget {
  const PlannerPage({super.key});

  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  DateTime _focusedMonth = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  int _filter = 0; // 0=semua, 1=aktif, 2=selesai

  static const _weekdays = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TaskController>();
    return SerenaBackground(
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton(
            onPressed: () => Get.toNamed<void>(Routes.plannerCreate),
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add_rounded, color: Colors.white),
          ),
          body: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: Obx(() => _buildBody(c)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final c = Get.find<TaskController>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Obx(() {
              final total = c.tasks.length;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dasbor Perencana',
                      style: AppTypography.h2.copyWith(fontSize: 20)),
                  Text(
                    '${_safeFormatMonth(_focusedMonth)} · $total tugas',
                    style: AppTypography.subtitle,
                  ),
                ],
              );
            }),
          ),
          AppCircleButton(
            icon: LucideIcons.plus,
            onTap: () => Get.toNamed<void>(Routes.plannerCreate),
            semanticLabel: 'Tambah tugas',
            background: AppColors.primary,
            color: AppColors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildBody(TaskController c) {
    final taskList = c.tasks.toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      children: [
        _CalendarCard(
          focusedMonth: _focusedMonth,
          selectedDay: _selectedDay,
          tasks: taskList,
          weekdays: _weekdays,
          onMonthChanged: (m) => setState(() => _focusedMonth = m),
          onDaySelected: (d) => setState(() => _selectedDay = d),
        ),
        const SizedBox(height: 20),
        _FilterRow(
          filter: _filter,
          onFilterChanged: (v) => setState(() => _filter = v),
        ),
        const SizedBox(height: 12),
        _AgendaList(
          tasks: taskList,
          selectedDay: _selectedDay,
          filter: _filter,
        ),
      ],
    );
  }
}

// ── Calendar Card ─────────────────────────────────────────────────────────────

class _CalendarCard extends StatelessWidget {
  const _CalendarCard({
    required this.focusedMonth,
    required this.selectedDay,
    required this.tasks,
    required this.weekdays,
    required this.onMonthChanged,
    required this.onDaySelected,
  });

  final DateTime focusedMonth;
  final DateTime selectedDay;
  final List<Task> tasks;
  final List<String> weekdays;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime> onDaySelected;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          // Month navigation
          Row(
            children: [
              AppCircleButton(
                icon: Icons.chevron_left_rounded,
                size: 36,
                onTap: () => onMonthChanged(
                  DateTime(focusedMonth.year, focusedMonth.month - 1),
                ),
                semanticLabel: 'Bulan sebelumnya',
              ),
              Expanded(
                child: Text(
                  _safeFormatMonth(focusedMonth),
                  textAlign: TextAlign.center,
                  style: AppTypography.label.copyWith(fontSize: 15),
                ),
              ),
              AppCircleButton(
                icon: Icons.chevron_right_rounded,
                size: 36,
                onTap: () => onMonthChanged(
                  DateTime(focusedMonth.year, focusedMonth.month + 1),
                ),
                semanticLabel: 'Bulan berikutnya',
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Weekday headers
          Row(
            children: weekdays
                .map(
                  (d) => Expanded(
                    child: Text(
                      d,
                      textAlign: TextAlign.center,
                      style: AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          // Calendar grid
          _buildGrid(),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    final firstDay = DateTime(focusedMonth.year, focusedMonth.month);
    final lastDay = DateTime(focusedMonth.year, focusedMonth.month + 1, 0);
    final startOffset = firstDay.weekday % 7; // Sun=0
    final totalCells = startOffset + lastDay.day;
    final rows = (totalCells / 7).ceil();

    // Collect days with tasks
    final taskDays = <int>{};
    for (final t in tasks) {
      final d = t.deadline?.toLocal();
      if (d != null &&
          d.year == focusedMonth.year &&
          d.month == focusedMonth.month) {
        taskDays.add(d.day);
      }
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: rows * 7,
      itemBuilder: (context, i) {
        final dayNum = i - startOffset + 1;
        if (dayNum < 1 || dayNum > lastDay.day) {
          return const SizedBox();
        }
        final date = DateTime(focusedMonth.year, focusedMonth.month, dayNum);
        final isSelected = date.year == selectedDay.year &&
            date.month == selectedDay.month &&
            date.day == selectedDay.day;
        final isToday = _isToday(date);
        final hasTasks = taskDays.contains(dayNum);

        return GestureDetector(
          onTap: () => onDaySelected(date),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: isSelected ? AppColors.primaryGradient : null,
              color: isToday && !isSelected ? AppColors.primaryTint : null,
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$dayNum',
                  style: AppTypography.label.copyWith(
                    fontSize: 13,
                    color: isSelected
                        ? Colors.white
                        : isToday
                            ? AppColors.primary
                            : AppColors.textPrimary,
                    fontWeight: isSelected || isToday
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
                if (hasTasks)
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }
}

// ── Filter Row ────────────────────────────────────────────────────────────────

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.filter,
    required this.onFilterChanged,
  });

  final int filter;
  final ValueChanged<int> onFilterChanged;

  static const _labels = ['Semua', 'Aktif', 'Selesai'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < _labels.length; i++) ...[
          GestureDetector(
            onTap: () => onFilterChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: filter == i ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: filter == i
                      ? AppColors.primary
                      : AppColors.glassBorderCard,
                ),
              ),
              child: Text(
                _labels[i],
                style: AppTypography.chipLabel.copyWith(
                  color: filter == i ? Colors.white : AppColors.textMuted,
                ),
              ),
            ),
          ),
          if (i < _labels.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

// ── Agenda List ───────────────────────────────────────────────────────────────

class _AgendaList extends StatelessWidget {
  const _AgendaList({
    required this.tasks,
    required this.selectedDay,
    required this.filter,
  });

  final List<Task> tasks;
  final DateTime selectedDay;
  final int filter;

  @override
  Widget build(BuildContext context) {
    var dayTasks = tasks.where((t) {
      final d = t.deadline?.toLocal();
      if (d == null) return false;
      return d.year == selectedDay.year &&
          d.month == selectedDay.month &&
          d.day == selectedDay.day;
    }).toList();

    if (filter == 1) {
      dayTasks = dayTasks
          .where(
            (t) =>
                t.status == TaskStatus.pending ||
                t.status == TaskStatus.inProgress,
          )
          .toList();
    } else if (filter == 2) {
      dayTasks =
          dayTasks.where((t) => t.status == TaskStatus.completed).toList();
    }

    if (dayTasks.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorderCard),
        ),
        child: Column(
          children: [
            const Icon(LucideIcons.calendarX2,
                size: 36, color: AppColors.textFaint),
            const SizedBox(height: 8),
            Text(
              'Tidak ada tugas pada hari ini',
              style: AppTypography.subtitle,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (final task in dayTasks) ...[
          AgendaItem(
            task: task,
            onTap: () => Get.toNamed<void>(
              Routes.plannerDetail.replaceFirst(':id', task.id),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
