import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:serena/controllers/mood_controller.dart';

class MoodPage extends StatelessWidget {
  const MoodPage({super.key});

  static const _emojis = ['😞', '😕', '😐', '🙂', '😄'];

  @override
  Widget build(BuildContext context) {
    final c = Get.find<MoodController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Mood')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAdd(context),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (c.isLoading.value && c.moods.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (c.moods.isEmpty) {
          return const Center(child: Text('Belum ada catatan mood.'));
        }
        return ListView.builder(
          itemCount: c.moods.length,
          itemBuilder: (context, i) {
            final m = c.moods[i];
            return ListTile(
              leading: Text(
                _emojis[m.moodScore - 1],
                style: const TextStyle(fontSize: 24),
              ),
              title: Text('${m.moodScore}/5'),
              subtitle: m.note == null ? null : Text(m.note!),
              trailing: Text(DateFormat('dd MMM').format(m.loggedAt)),
            );
          },
        );
      }),
    );
  }

  void _showAdd(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _MoodSheet(),
    );
  }
}

class _MoodSheet extends StatefulWidget {
  const _MoodSheet();

  @override
  State<_MoodSheet> createState() => _MoodSheetState();
}

class _MoodSheetState extends State<_MoodSheet> {
  int _score = 3;
  final _note = TextEditingController();

  static const _emojis = ['😞', '😕', '😐', '🙂', '😄'];

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final ok = await Get.find<MoodController>().addMood(
      _score,
      _note.text.trim().isEmpty ? null : _note.text.trim(),
    );
    if (ok) {
      Get.back();
      Get.snackbar('Berhasil', 'Mood tercatat.');
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Bagaimana perasaanmu?', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Row(
            children: List.generate(5, (i) {
              final value = i + 1;
              return Expanded(
                child: InkWell(
                  onTap: () => setState(() => _score = value),
                  child: Column(
                    children: [
                      Text(
                        _emojis[i],
                        style: TextStyle(
                          fontSize: 28,
                          color: _score == value ? null : Colors.grey.shade300,
                        ),
                      ),
                      Text('$value'),
                    ],
                  ),
                ),
              );
            }),
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
    );
  }
}
