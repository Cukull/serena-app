import 'package:get/get.dart';

import 'package:serena/controllers/auth_controller.dart';
import 'package:serena/models/task.dart';
import 'package:serena/repositories/task_repository.dart';

/// CRUD task + filter status lokal.
class TaskController extends GetxController {
  TaskController({required this.repo});

  final TaskRepository repo;

  final tasks = <Task>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final filter = Rxn<TaskStatus>();

  String? get _uid => Get.find<AuthController>().user.value?.id;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  List<Task> get visibleTasks {
    final f = filter.value;
    if (f == null) return tasks;
    return tasks.where((t) => t.status == f).toList();
  }

  Future<void> fetchTasks() async {
    final uid = _uid;
    if (uid == null) return;
    isLoading.value = true;
    errorMessage.value = null;
    try {
      tasks.value = await repo.fetchTasks(uid);
    } on Object {
      errorMessage.value = 'Gagal memuat task.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createTask({
    required String title,
    String? description,
    DateTime? deadline,
    TaskPriority priority = TaskPriority.medium,
  }) async {
    final uid = _uid;
    if (uid == null) return false;
    isLoading.value = true;
    try {
      final task = Task(
        id: '',
        userId: uid,
        title: title,
        description: description,
        deadline: deadline,
        priority: priority,
      );
      await repo.createTask(task);
      await fetchTasks();
      return true;
    } on Object {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateTask(Task task) async {
    isLoading.value = true;
    try {
      await repo.updateTask(task);
      await fetchTasks();
      return true;
    } on Object {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> setStatus(Task task, TaskStatus status) async {
    final completedAt = status == TaskStatus.completed
        ? DateTime.now().toUtc()
        : (task.status == TaskStatus.completed ? task.completedAt : null);
    final updated = Task(
      id: task.id,
      userId: task.userId,
      categoryId: task.categoryId,
      title: task.title,
      description: task.description,
      deadline: task.deadline,
      priority: task.priority,
      status: status,
      progress: status == TaskStatus.completed ? 100 : task.progress,
      reminderAt: task.reminderAt,
      completedAt: completedAt,
    );
    return updateTask(updated);
  }

  Future<bool> deleteTask(String id) async {
    isLoading.value = true;
    try {
      await repo.deleteTask(id);
      tasks.removeWhere((t) => t.id == id);
      return true;
    } on Object {
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
