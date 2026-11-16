import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:serena/models/task.dart';
import 'package:serena/repositories/task_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    // Inisialisasi GetStorage untuk testing memory/temp
    GetStorage.init();
  });

  tearDown(() async {
    final box = GetStorage();
    await box.erase();
  });

  test('TaskRepository menyimpan dan membaca task dari local storage', () async {
    final repo = TaskRepository();
    const userId = 'user_test_123';

    // 1. Awalnya lokal kosong
    expect(repo.getLocalTasks(userId), isEmpty);

    // 2. Simpan task secara manual ke local storage
    final task1 = Task(
      id: 'local_1',
      userId: userId,
      title: 'Tugas Kuliah UI/UX',
      priority: TaskPriority.high,
      deadline: DateTime.now().add(const Duration(days: 1)),
    );
    repo.saveLocalTasks(userId, [task1]);

    // 3. Baca kembali dari local storage
    final loaded = repo.getLocalTasks(userId);
    expect(loaded.length, 1);
    expect(loaded.first.id, 'local_1');
    expect(loaded.first.title, 'Tugas Kuliah UI/UX');
    expect(loaded.first.priority, TaskPriority.high);

    // 4. Hapus task secara lokal
    await repo.deleteTask('local_1', userId: userId);
    expect(repo.getLocalTasks(userId), isEmpty);
  });
}
