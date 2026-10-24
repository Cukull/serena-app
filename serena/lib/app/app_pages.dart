// ignore_for_file: strict_raw_type, public_member_api_docs

import 'package:get/get.dart';
import 'package:serena/app/app_routes.dart';
import 'package:serena/app/main_shell.dart';
import 'package:serena/app/middlewares/auth_middleware.dart';
import 'package:serena/features/auth/bindings/landing_binding.dart';
import 'package:serena/features/auth/bindings/login_binding.dart';
import 'package:serena/features/auth/forgot_password_page.dart';
import 'package:serena/features/auth/landing_page.dart';
import 'package:serena/features/auth/login_page.dart';
import 'package:serena/features/auth/onboarding_page.dart';
import 'package:serena/features/auth/register_page.dart';
import 'package:serena/features/auth/verify_page.dart';
import 'package:serena/features/focus/deep_focus_page.dart';
import 'package:serena/features/focus/exam_mode_page.dart';
import 'package:serena/features/focus/focus_history_page.dart';
import 'package:serena/features/focus/pomodoro_page.dart';
import 'package:serena/features/planner/create_task_page.dart';
import 'package:serena/features/planner/edit_task_page.dart';
import 'package:serena/features/planner/task_detail_page.dart';
import 'package:serena/features/profile/achievements_page.dart';
import 'package:serena/features/profile/edit_profile_page.dart';
import 'package:serena/features/profile/settings_page.dart';
import 'package:serena/features/wellness/habits_page.dart';
import 'package:serena/features/wellness/mood_page.dart';
import 'package:serena/features/wellness/sleep_page.dart';

/// Daftar GetPage. AuthMiddleware menjaga route protected.
/// Jangan pecah list ini per fitur untuk MVP.
abstract class AppPages {
  static final routes = <GetPage>[
    GetPage(
        name: AppRoutes.landing,
        page: () => const LandingPage(),
        binding: LandingBinding()),
    GetPage(
        name: AppRoutes.login,
        page: () => const LoginPage(),
        binding: LoginBinding()),
    GetPage(name: AppRoutes.register, page: () => const RegisterPage()),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordPage(),
    ),
    GetPage(name: AppRoutes.verify, page: () => const VerifyPage()),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainShell(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.plannerCreate,
      page: () => const CreateTaskPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.plannerDetail,
      page: () => const TaskDetailPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.plannerEdit,
      page: () => const EditTaskPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.pomodoro,
      page: () => const PomodoroPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.deepFocus,
      page: () => const DeepFocusPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.examMode,
      page: () => const ExamModePage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.focusHistory,
      page: () => const FocusHistoryPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.mood,
      page: () => const MoodPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.habits,
      page: () => const HabitsPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.sleep,
      page: () => const SleepPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfilePage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.achievements,
      page: () => const AchievementsPage(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
