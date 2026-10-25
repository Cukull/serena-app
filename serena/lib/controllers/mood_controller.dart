import 'package:get/get.dart';

import 'package:serena/controllers/auth_controller.dart';
import 'package:serena/models/mood_log.dart';
import 'package:serena/repositories/mood_repository.dart';

/// Catat + tampilkan mood.
class MoodController extends GetxController {
  MoodController({required this.repo});

  final MoodRepository repo;

  final moods = <MoodLog>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  String? get _uid => Get.find<AuthController>().user.value?.id;

  @override
  void onInit() {
    super.onInit();
    fetchMoods();
  }

  Future<void> fetchMoods() async {
    final uid = _uid;
    if (uid == null) return;
    isLoading.value = true;
    errorMessage.value = null;
    try {
      moods.value = await repo.fetchMoods(uid);
    } on Object {
      errorMessage.value = 'Gagal memuat mood.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addMood(int score, String? note) async {
    final uid = _uid;
    if (uid == null) return false;
    isLoading.value = true;
    try {
      await repo.insertMood(userId: uid, score: score, note: note);
      await fetchMoods();
      return true;
    } on Object {
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
