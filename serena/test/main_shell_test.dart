import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:serena/app/bindings/main_binding.dart';
import 'package:serena/app/main_shell.dart';
import 'package:serena/controllers/auth_controller.dart';
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
  String? get currentUserId => 'test_user_id';
  @override
  Session? get currentSession => null;
}

class _FakeProfileRepo extends ProfileRepository {
  @override
  Future<Profile?> fetchProfile(String userId) async => const Profile(
        id: 'test_user_id',
        email: 'test@example.com',
        fullName: 'Test User',
        onboardingCompleted: true,
      );
}

class _FakeTaskRepo extends TaskRepository {
  @override
  List<Task> getLocalTasks(String userId) => [];
  @override
  void saveLocalTasks(String userId, List<Task> tasks) {}
  @override
  Future<List<Task>> fetchTasks(String userId) async => [];
}

class _FakeFocusRepo extends FocusRepository {
  Future<List<dynamic>> fetchRecentSessions(String userId) async => [];
}

void main() {
  tearDown(Get.reset);

  testWidgets('MainShell renders all tabs with MainBinding without exception', (tester) async {
    Get.lazyPut<AuthRepository>(() => _FakeAuthRepo(), fenix: true);
    Get.lazyPut<ProfileRepository>(() => _FakeProfileRepo(), fenix: true);
    Get.lazyPut<TaskRepository>(() => _FakeTaskRepo(), fenix: true);
    Get.lazyPut<FocusRepository>(() => _FakeFocusRepo(), fenix: true);

    final authCtrl = AuthController(
      authRepo: Get.find(),
      profileRepo: Get.find(),
    );
    authCtrl.user.value = const Profile(
      id: 'test_user_id',
      email: 'test@example.com',
      fullName: 'Test User',
      onboardingCompleted: true,
    );
    Get.put<AuthController>(authCtrl, permanent: true);

    MainBinding().dependencies();

    await tester.pumpWidget(
      const GetMaterialApp(
        home: MainShell(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(MainShell), findsOneWidget);
  });
}
