import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:serena/controllers/auth_controller.dart';
import 'package:serena/controllers/focus_controller.dart';
import 'package:serena/controllers/main_controller.dart';
import 'package:serena/controllers/task_controller.dart';
import 'package:serena/features/home/home_page.dart';
import 'package:serena/models/profile.dart';
import 'package:serena/models/task.dart';
import 'package:serena/repositories/auth_repository.dart';
import 'package:serena/repositories/focus_repository.dart';
import 'package:serena/repositories/profile_repository.dart';
import 'package:serena/repositories/task_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _FakeAuthRepo extends AuthRepository {
  @override
  Stream<AuthState> get authStateChanges => const Stream.empty();
  @override
  String? get currentUserId => 'test_user';
  @override
  Session? get currentSession => null;
}

class _FakeProfileRepo extends ProfileRepository {
  @override
  Future<Profile?> fetchProfile(String userId) async => const Profile(
        id: 'test_user',
        fullName: 'Test User',
      );
}

class _FakeTaskRepo extends TaskRepository {
  final List<Task> _inMemory = [];

  @override
  List<Task> getLocalTasks(String userId) => List<Task>.from(_inMemory);

  @override
  void saveLocalTasks(String userId, List<Task> tasks) {
    _inMemory
      ..clear()
      ..addAll(tasks);
  }

  @override
  Future<List<Task>> fetchTasks(String userId) async =>
      List<Task>.from(_inMemory);

  @override
  Future<Task> createTask(Task task) async {
    _inMemory.insert(0, task);
    return task;
  }
}

class _FakeFocusRepo extends FocusRepository {
  @override
  Future<List<dynamic>> fetchRecentSessions(String userId) async => [];
}

void main() {
  tearDown(Get.reset);

  testWidgets(
      'Agenda Hari Ini menampilkan placeholder kosong saat tidak ada tugas '
      'dan tidak memunculkan data dummy', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    final fakeTasks = _FakeTaskRepo();
    Get.put(
      AuthController(
        authRepo: _FakeAuthRepo(),
        profileRepo: _FakeProfileRepo(),
      ),
    );
    Get.put(MainController());
    Get.put(TaskController(repo: fakeTasks));
    Get.put(FocusController(repo: _FakeFocusRepo()));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: Scaffold(
          body: HomePage(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // 1. Pastikan placeholder muncul saat tidak ada tugas hari ini
    expect(find.text('Belum ada tugas hari ini 🎉'), findsOneWidget);
    expect(find.text('Ketuk untuk melihat agenda lainnya di Jadwal'),
        findsOneWidget);

    // 2. Pastikan data dummy TIDAK pernah muncul lagi
    expect(find.text('Kuliah UI/UX Design'), findsNothing);
    expect(find.text('Kumpulkan Tugas Web Development'), findsNothing);

    // 3. Tambahkan tugas untuk hari ini
    final now = DateTime.now();
    final todayTask = Task(
      id: 'task_today_1',
      userId: 'test_user',
      title: 'Presentasi Proyek Capstone',
      priority: TaskPriority.urgent,
      deadline: DateTime(now.year, now.month, now.day, 14, 30),
    );
    await fakeTasks.createTask(todayTask);
    await Get.find<TaskController>().fetchTasks();

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // 4. Pastikan tugas hari ini muncul di timeline dan placeholder hilang
    // Muncul di Tenggat Terdekat dan di Agenda Hari Ini (2 widget)
    expect(find.text('Presentasi Proyek Capstone'), findsNWidgets(2));
    expect(find.text('Belum ada tugas hari ini 🎉'), findsNothing);
  });
}
