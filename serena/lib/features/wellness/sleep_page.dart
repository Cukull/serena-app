import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:serena/controllers/sleep_controller.dart';
import 'package:serena/models/sleep_log.dart';

class SleepPage extends StatelessWidget {
  const SleepPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SleepController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Tidur')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAdd(context),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (c.isLoading.value && c.logs.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (c.logs.isEmpty) {
          return const Center(child: Text('Belum ada catatan tidur.'));
        }
        return ListView.builder(
          itemCount: c.logs.length,
          itemBuilder: (context, i) {
            final s = c.logs[i];
            return ListTile(
              leading: const Icon(Icons.bedtime_outlined),
              title: Text(DateFormat('dd MMM yyyy').format(s.sleepDate)),
              subtitle: Text(_durationText(s)),
              trailing: s.quality == null
                  ? null
                  : Text('Kualitas ${s.quality}/5'),
            );
          },
        );
      }),
    );
  }

  String _durationText(SleepLog s) {
    if (s.bedtime == null || s.wakeTime == null) return 'Tanpa detail';
    final diff = s.wakeTime!.difference(s.bedtime!);
    final h = diff.inHours;
    final m = diff.inMinutes % 60;
    return '${h}j ${m}m';
  }

  void _showAdd(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _SleepSheet(),
    );
  }
}

class _SleepSheet extends StatefulWidget {
  const _SleepSheet();

  @override
  State<_SleepSheet> createState() => _SleepSheetState();
}

class _SleepSheetState extends State<_SleepSheet> {
  DateTime _date = DateTime.now();
  TimeOfDay? _bedtime;
  TimeOfDay? _wakeTime;
  int _quality = 3;
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime(bool isBedtime) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => isBedtime ? _bedtime = picked : _wakeTime = picked);
    }
  }

  DateTime? _combine(TimeOfDay? t) {
    if (t == null) return null;
    return DateTime(_date.year, _date.month, _date.day, t.hour, t.minute);
  }

  Future<void> _save() async {
    final ok = await Get.find<SleepController>().addSleep(
      sleepDate: _date,
      bedtime: _combine(_bedtime),
      wakeTime: _combine(_wakeTime),
      quality: _quality,
      note: _note.text.trim().isEmpty ? null : _note.text.trim(),
    );
    if (ok) {
      Get.back();
      Get.snackbar('Berhasil', 'Catatan tidur tersimpan.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Catat tidur', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today),
              label: Text(DateFormat('dd MMM yyyy').format(_date)),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pickTime(true),
                    child: Text(
                      _bedtime == null
                          ? 'Jam tidur'
                          : 'Tidur: ${_bedtime!.format(context)}',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pickTime(false),
                    child: Text(
                      _wakeTime == null
                          ? 'Jam bangun'
                          : 'Bangun: ${_wakeTime!.format(context)}',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Kualitas tidur', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (var q = 1; q <= 5; q++)
                  ChoiceChip(
                    label: Text('$q'),
                    selected: _quality == q,
                    onSelected: (_) => setState(() => _quality = q),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _note,
              decoration: const InputDecoration(
                labelText: 'Catatan (opsional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _save,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
