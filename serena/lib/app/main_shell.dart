import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:serena/controllers/main_controller.dart';
import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_typography.dart';
import 'package:serena/features/focus/focus_page.dart';
import 'package:serena/features/home/home_page.dart';
import 'package:serena/features/planner/planner_page.dart';
import 'package:serena/features/profile/profile_page.dart';
import 'package:serena/features/wellness/wellness_page.dart';

/// Shell bottom-tab. Tab diganti via MainController (IndexedStack),
/// bukan route terpisah — state tiap tab terjaga.
/// Navigasi mengikuti `design.md`: pill putih mengambang, item aktif gradien.
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const _tabs = <(IconData, String)>[
    (LucideIcons.home, 'Beranda'),
    (LucideIcons.calendarDays, 'Jadwal'),
    (LucideIcons.timer, 'Fokus'),
    (LucideIcons.heartPulse, 'Kesehatan'),
    (LucideIcons.user, 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();
    return Obx(
      () => Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: controller.tabIndex.value,
          children: const [
            HomePage(),
            PlannerPage(),
            FocusPage(),
            WellnessPage(),
            ProfilePage(),
          ],
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x243C4682),
                  blurRadius: 28,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                for (var i = 0; i < _tabs.length; i++)
                  Expanded(
                    child: _NavItem(
                      icon: _tabs[i].$1,
                      label: _tabs[i].$2,
                      active: controller.tabIndex.value == i,
                      onTap: () => controller.switchTab(i),
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

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: active,
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            gradient: active ? AppColors.primaryGradient : null,
            borderRadius: BorderRadius.circular(20),
            boxShadow: active
                ? const [
                    BoxShadow(
                      color: Color(0x597C6BF0),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: active ? AppColors.white : AppColors.textMuted,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.badgeLabel.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: active ? AppColors.white : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
