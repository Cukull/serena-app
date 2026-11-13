import 'package:get/get.dart';

import 'package:serena/controllers/auth_controller.dart';
import 'package:serena/models/habit.dart';
import 'package:serena/repositories/habit_repository.dart';

/// Habit + log harian.
class HabitController extends GetxController {
  HabitController({required this.repo});

  final HabitRepository repo;

  final habits = <Habit>[].obs;
  final completedToday = <String>{}.obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  String? get _uid => Get.find<AuthController>().user.value?.id;

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  Future<void> fetchAll() async {
    final uid = _uid;
    if (uid == null) return;
    isLoading.value = true;
    errorMessage.value = null;
    try {
      habits.value = await repo.fetchHabits(uid);
      final logs = await repo.fetchLogsForDate(uid, DateTime.now());
      completedToday.assignAll(logs.map((l) => l.habitId));
    } on Object {
      errorMessage.value = 'Gagal memuat habit.';
    } finally {
      isLoading.value = false;
    }
  }

  bool isDone(Habit habit) => completedToday.contains(habit.id);

  Future<bool> createHabit(String title) async {
    final uid = _uid;
    if (uid == null) return false;
    isLoading.value = true;
    try {
      final habit = Habit(id: '', userId: uid, title: title);
      await repo.createHabit(habit);
      await fetchAll();
      return true;
    } on Object {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggle(Habit habit) async {
    final uid = _uid;
    if (uid == null) return;
    await repo.toggleLog(habitId: habit.id, userId: uid, date: DateTime.now());
    await fetchAll();
  }

  Future<bool> deleteHabit(String id) async {
    isLoading.value = true;
    try {
      await repo.deleteHabit(id);
      await fetchAll();
      return true;
    } on Object {
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
