import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:serena/controllers/task_controller.dart';
import 'package:serena/core/validators/validators.dart';
import 'package:serena/models/task.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  TaskPriority _priority = TaskPriority.medium;
  DateTime? _deadline;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() => _deadline = picked);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final ok = await Get.find<TaskController>().createTask(
      title: _title.text.trim(),
      description: _description.text.trim().isEmpty
          ? null
          : _description.text.trim(),
      deadline: _deadline,
      priority: _priority,
    );
    if (ok) {
      Get.back();
      Get.snackbar('Berhasil', 'Task ditambahkan.');
    } else {
      Get.snackbar('Gagal', 'Task tidak tersimpan.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TaskController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Task')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(
                    labelText: 'Judul task',
                    border: OutlineInputBorder(),
                  ),
                  validator: AppValidators.required,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _description,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi (opsional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Prioritas', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final p in TaskPriority.values)
                      ChoiceChip(
                        label: Text(p.label),
                        selected: _priority == p,
                        onSelected: (_) => setState(() => _priority = p),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _deadline == null
                            ? 'Tanpa deadline'
                            : 'Deadline: ${DateFormat('dd MMM yyyy').format(_deadline!)}',
                      ),
                    ),
                    TextButton(
                      onPressed: _pickDeadline,
                      child: const Text('Pilih tanggal'),
                    ),
                    if (_deadline != null)
                      IconButton(
                        onPressed: () => setState(() => _deadline = null),
                        icon: const Icon(Icons.close),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                Obx(
                  () => ElevatedButton(
                    onPressed: c.isLoading.value ? null : _submit,
                    child: c.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Simpan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
