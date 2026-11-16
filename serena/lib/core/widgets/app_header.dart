// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:serena/app/app_assets.dart';
import 'package:serena/controllers/auth_controller.dart';
import 'package:serena/controllers/main_controller.dart';
import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_typography.dart';

/// App-wide header: logo Serena + notif bell (gradient badge dot) + avatar initials.
/// Matches serena-web/pages/home/index.html app-header component.
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Brand section: icon + wordmark
          _LogoIcon(),
          const SizedBox(width: 10),
          _Wordmark(),
          const Spacer(),
          // Notification bell with badge dot
          _NotifBell(),
          const SizedBox(width: 10),
          // Avatar initials
          Obx(() {
            final name = auth.user.value?.displayName ?? 'U';
            final initials = _initials(name);
            return GestureDetector(
              onTap: () => MainController.to.goTab(3),
              child: _AvatarBadge(initials: initials),
            );
          }),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }
}

class _LogoIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0x3863C7F7), Color(0x388B7CF8)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x6163C7F7)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2463C7F7),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Image.asset(
        AppAssets.logo,
        fit: BoxFit.contain,
      ),
    );
  }
}

class _Wordmark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.wordmark,
      height: 22,
      fit: BoxFit.contain,
    );
  }
}

class _NotifBell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x143C4682),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            LucideIcons.bell,
            size: 20,
            color: AppColors.textPrimary,
          ),
        ),
        // Gradient badge dot
        Positioned(
          right: 2,
          top: 2,
          child: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              gradient: AppColors.webPrimary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Color(0x447C6BF0), blurRadius: 4),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AvatarBadge extends StatelessWidget {
  const _AvatarBadge({required this.initials});
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: AppColors.avatarGradient,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(50),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        initials,
        style: AppTypography.avatarInitial.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
      ),
    );
  }
}
