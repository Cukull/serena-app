import 'package:get/get.dart';

import 'package:serena/controllers/auth_controller.dart';
import 'package:serena/models/sleep_log.dart';
import 'package:serena/repositories/sleep_repository.dart';

/// Catat + tampilkan tidur.
class SleepController extends GetxController {
  SleepController({required this.repo});

  final SleepRepository repo;

  final logs = <SleepLog>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  String? get _uid => Get.find<AuthController>().user.value?.id;

  @override
  void onInit() {
    super.onInit();
    fetchLogs();
  }

  Future<void> fetchLogs() async {
    final uid = _uid;
    if (uid == null) return;
    isLoading.value = true;
    errorMessage.value = null;
    try {
      logs.value = await repo.fetchSleepLogs(uid);
    } on Object {
      errorMessage.value = 'Gagal memuat data tidur.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addSleep({
    required DateTime sleepDate,
    DateTime? bedtime,
    DateTime? wakeTime,
    int? quality,
    String? note,
  }) async {
    final uid = _uid;
    if (uid == null) return false;
    isLoading.value = true;
    try {
      await repo.insertSleep(
        userId: uid,
        sleepDate: sleepDate,
        bedtime: bedtime,
        wakeTime: wakeTime,
        quality: quality,
        note: note,
      );
      await fetchLogs();
      return true;
    } on Object {
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
