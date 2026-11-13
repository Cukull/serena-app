import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:serena/app/app_routes.dart';
import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_typography.dart';
import 'package:serena/core/widgets/app_ui.dart';

/// Tab Profil — mengikuti `referensi/profile (1).html`.
///
/// shortcut: data profil masih statis (belum baca Supabase); ganti ke
/// ProfileRepository/AuthController saat modul itu tersedia.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const _name = 'Yusup Arief Fauzi';
  static const _email = 'yusup.arief@gmail.com';

  @override
  Widget build(BuildContext context) {
    return SerenaBackground(
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
          children: [
            _greeting(),
            const SizedBox(height: 20),
            _heroCard(),
            const AppSectionHeader(label: 'Pengaturan'),
            _menuTile(
              icon: LucideIcons.userCog,
              gradient: const LinearGradient(
                colors: [Color(0xFF6FA8F5), Color(0xFFA66BF0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              title: 'Pengaturan profil',
              subtitle: 'Ubah nama, email, dan foto',
              route: Routes.editProfile,
            ),
            const SizedBox(height: 12),
            _menuTile(
              icon: LucideIcons.shieldCheck,
              gradient: const LinearGradient(
                colors: [Color(0xFF6C8CF0), Color(0xFF34C3A8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              title: 'Keamanan & privasi',
              subtitle: 'Kata sandi dan siapa yang bisa melihat profilmu',
              route: Routes.settings,
            ),
            const SizedBox(height: 20),
            _logoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _greeting() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profil', style: AppTypography.h1),
              const SizedBox(height: 4),
              Text(
                'Atur akun dan keamananmu di sini.',
                style: AppTypography.subtitle.copyWith(fontSize: 14),
              ),
            ],
          ),
        ),
        AppCircleButton(
          icon: LucideIcons.pencil,
          semanticLabel: 'Ubah profil',
          onTap: () => Get.toNamed<void>(Routes.editProfile),
        ),
      ],
    );
  }

  Widget _heroCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 28),
      decoration: const BoxDecoration(
        gradient: AppColors.profileGradient,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(44),
          topRight: Radius.circular(18),
          bottomRight: Radius.circular(44),
          bottomLeft: Radius.circular(18),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x595B8DEF),
            blurRadius: 32,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -50,
            top: -50,
            child: IgnorePointer(
              child: Container(
                width: 170,
                height: 170,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Color(0x80FFFFFF), Color(0x00FFFFFF)],
                    stops: [0, 0.7],
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: AppColors.avatarGradient,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 3),
                    ),
                    child: Text(
                      'YA',
                      style: AppTypography.pageTitle.copyWith(
                        color: AppColors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Positioned(
                    right: -4,
                    bottom: -2,
                    child: AppCircleButton(
                      icon: LucideIcons.camera,
                      size: 30,
                      iconSize: 16,
                      color: AppColors.primary,
                      semanticLabel: 'Ganti foto profil',
                      onTap: () => Get.toNamed<void>(Routes.editProfile),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _name,
                textAlign: TextAlign.center,
                style: AppTypography.h3.copyWith(
                  fontSize: 21,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _email,
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(
                  fontSize: 14,
                  color: AppColors.white.withValues(alpha: 0.92),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _miniStat('12', 'Tugas selesai'),
                  const SizedBox(width: 10),
                  _miniStat('14j', 'Waktu fokus'),
                  const SizedBox(width: 10),
                  _miniStat('12', 'Hari beruntun'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTypography.label.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(
                fontSize: 11.5,
                color: AppColors.white.withValues(alpha: 0.92),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required LinearGradient gradient,
    required String title,
    required String subtitle,
    required String route,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 72),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x143C4682),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Get.toNamed<void>(route),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icon, size: 22, color: AppColors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTypography.cardTitle),
                      const SizedBox(height: 3),
                      Text(subtitle, style: AppTypography.subtitle),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: () => showAppSheet(
          context,
          title: 'Keluar dari Serena?',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Kamu perlu masuk lagi untuk melihat jadwal dan tugasmu.',
                textAlign: TextAlign.center,
                style: AppTypography.lead,
              ),
              const SizedBox(height: 18),
              AppFilledButton(
                label: 'Ya, keluar',
                style: AppButtonStyle.danger,
                onTap: () {
                  Navigator.of(context).pop();
                  Get.offAllNamed<void>(Routes.welcome);
                },
              ),
              const SizedBox(height: 10),
              AppFilledButton(
                label: 'Tetap di sini',
                style: AppButtonStyle.ghost,
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.dangerTint,
          side: const BorderSide(color: AppColors.dangerBorder, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: AppTypography.button.copyWith(
            color: AppColors.dangerDark,
          ),
        ),
        child: const Text('Keluar dari akun'),
      ),
    );
  }
}
