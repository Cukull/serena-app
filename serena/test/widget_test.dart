import 'package:flutter_test/flutter_test.dart';

import 'package:serena/core/validators/validators.dart';
import 'package:serena/models/task.dart';

void main() {
  group('AppValidators', () {
    test('email valid diterima', () {
      expect(AppValidators.email('a@b.co'), isNull);
    });

    test('email tanpa @ ditolak', () {
      expect(AppValidators.email('a-b.co'), isNotNull);
    });

    test('email kosong ditolak', () {
      expect(AppValidators.email(''), isNotNull);
    });

    test('password < 8 karakter ditolak', () {
      expect(AppValidators.password('1234567'), isNotNull);
    });

    test('password >= 8 karakter diterima', () {
      expect(AppValidators.password('12345678'), isNull);
    });
  });

  group('Task serialization', () {
    test('fromJson membaca enum priority/status', () {
      final task = Task.fromJson({
        'id': '1',
        'user_id': 'u1',
        'title': 'Kerjakan laporan',
        'priority': 'urgent',
        'status': 'in_progress',
        'progress': 40,
      });

      expect(task.priority, TaskPriority.urgent);
      expect(task.status, TaskStatus.inProgress);
      expect(task.progress, 40);
    });

    test('toJson menulis nilai enum ke string db', () {
      const task = Task(
        id: '1',
        userId: 'u1',
        title: 'Belajar',
        priority: TaskPriority.high,
        status: TaskStatus.completed,
        progress: 100,
      );

      expect(task.toJson()['priority'], 'high');
      expect(task.toJson()['status'], 'completed');
    });
  });
}
