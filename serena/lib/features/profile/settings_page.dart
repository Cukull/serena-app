import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_typography.dart';
import 'package:serena/core/widgets/app_ui.dart';

/// Keamanan & Privasi — mengikuti `referensi/keamanan-privasi.html`.
///
/// shortcut: skor keamanan dihitung dari state lokal halaman; sambungkan ke
/// data akun Supabase (2FA, biometrik, sesi) saat fitur backend tersedia.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _currentPass = TextEditingController();
  final _newPass = TextEditingController();
  final _repeatPass = TextEditingController();

  bool _biometric = true;
  bool _twoFactor = false;

  /// 25 kata sandi + 25 email + 20 biometrik + 15 dua langkah + 15 privasi.
  int get _score =>
      25 + 25 + (_biometric ? 20 : 0) + (_twoFactor ? 15 : 0) + 15;

  @override
  void dispose() {
    _currentPass.dispose();
    _newPass.dispose();
    _repeatPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SerenaBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _header(),
                _hero(),
                _summary(),
                const AppSectionHeader(label: 'KEAMANAN AKUN'),
                _accountList(),
                const AppSectionHeader(label: 'ZONA BAHAYA', danger: true),
                _dangerList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        AppCircleButton(
          icon: Icons.arrow_back_ios_new_rounded,
          iconSize: 18,
          semanticLabel: 'Kembali',
          onTap: () => Get.back<void>(),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text('Keamanan & Privasi', style: AppTypography.pageTitle),
        ),
      ],
    );
  }

  Widget _hero() {
    final safe = _score >= 75;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 16),
      child: Column(
        children: [
          Container(
            width: 78,
            height: 78,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFDDEBFB),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 4),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x404F9BE8),
                  blurRadius: 18,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              LucideIcons.shieldCheck,
              size: 38,
              color: AppColors.textStrong,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            safe ? 'Akunmu aman 🔒' : 'Perlu perhatian ⚠️',
            style: AppTypography.fieldValue.copyWith(fontSize: 19),
          ),
          const SizedBox(height: 4),
          Text(
            safe
                ? 'Pemeriksaan utama lolos. Datamu tersimpan dengan aman.'
                : 'Lengkapi pemeriksaan keamanan di bawah ini.',
            textAlign: TextAlign.center,
            style: AppTypography.subtitle,
          ),
          const SizedBox(height: 12),
          AppStatusPill(label: 'Skor keamanan: $_score/100', ok: safe),
        ],
      ),
    );
  }

  Widget _summary() {
    final checks = <(bool, String, String)>[
      (true, 'Kata sandi kuat', 'Kata sandi lemah'),
      (true, 'Email terverifikasi', 'Email belum terverifikasi'),
      (_biometric, 'Login biometrik aktif', 'Login biometrik nonaktif'),
      (
        _twoFactor,
        'Verifikasi dua langkah aktif',
        'Verifikasi dua langkah belum diatur',
      ),
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(
                  'Ringkasan keamanan',
                  style: AppTypography.fieldValue,
                ),
              ),
              Text(
                '$_score',
                style: AppTypography.statBig.copyWith(
                  fontSize: 28,
                  color: AppColors.secondary,
                ),
              ),
              Text(
                '/100',
                style: AppTypography.subtitle.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 8,
              child: ColoredBox(
                color: AppColors.progressTrack,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _score / 100,
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: AppColors.progressGradient,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          for (final (ok, labelOn, labelOff) in checks)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            ok ? AppColors.okPillText : const Color(0xFFE8924F),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      ok ? '✓' : '!',
                      style: AppTypography.badgeLabel.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: ok ? AppColors.okPillText : AppColors.warnText,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      ok ? labelOn : labelOff,
                      style: AppTypography.chipLabel.copyWith(
                        fontSize: 14,
                        color: ok ? AppColors.textPrimary : AppColors.warnText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _accountList() {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      child: Column(
        children: [
          AppCardRow(
            leading: const AppIconTile(
              background: AppColors.tileBlue,
              child: Text('🔑', style: TextStyle(fontSize: 18)),
            ),
            title: 'Ubah kata sandi',
            subtitle: 'Terakhir diubah 30 hari lalu',
            onTap: _openPasswordSheet,
          ),
          AppCardRow(
            leading: const AppIconTile(
              background: AppColors.tilePeach,
              child: Text('🛡️', style: TextStyle(fontSize: 18)),
            ),
            title: 'Verifikasi dua langkah',
            subtitle: 'Tambah lapisan keamanan saat masuk',
            trailing: _Badge(active: _twoFactor),
            onTap: _openTwoFactorSheet,
          ),
          AppCardRow(
            leading: const AppIconTile(
              background: AppColors.tileGreen,
              child: Text('👆', style: TextStyle(fontSize: 18)),
            ),
            title: 'Login biometrik',
            subtitle: 'Face ID / sidik jari',
            trailing: AppSwitch(
              value: _biometric,
              semanticLabel: 'Login biometrik',
              onChanged: (value) {
                setState(() => _biometric = value);
                showAppToast(
                  context,
                  value ? 'Login biometrik aktif' : 'Login biometrik nonaktif',
                );
              },
            ),
          ),
          AppCardRow(
            leading: const AppIconTile(
              background: AppColors.tileViolet,
              child: Text('📱', style: TextStyle(fontSize: 18)),
            ),
            title: 'Sesi aktif',
            subtitle: '2 perangkat masuk',
            showDivider: false,
            onTap: _openSessionsSheet,
          ),
        ],
      ),
    );
  }

  Widget _dangerList() {
    return AppCard(
      color: const Color(0xFFFFF6F6),
      border: AppColors.dangerListBorder,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      child: Column(
        children: [
          AppCardRow(
            leading: const AppIconTile(
              background: AppColors.tileRed,
              child: Text('⏸️', style: TextStyle(fontSize: 18)),
            ),
            title: 'Nonaktifkan akun',
            subtitle: 'Jeda akunmu untuk sementara',
            titleColor: AppColors.dangerDark,
            trailing: const SizedBox.shrink(),
            onTap: () => _confirmDanger(
              title: 'Nonaktifkan akun?',
              message: 'Akunmu disembunyikan dan notifikasi dihentikan sampai '
                  'kamu masuk lagi.',
              action: 'Ya, nonaktifkan',
              toast: 'Akun dinonaktifkan',
            ),
          ),
          AppCardRow(
            leading: const AppIconTile(
              background: AppColors.tileRed,
              child: Text('🗑️', style: TextStyle(fontSize: 18)),
            ),
            title: 'Hapus akun',
            subtitle: 'Hapus semua datamu secara permanen',
            titleColor: AppColors.dangerDark,
            showDivider: false,
            trailing: const SizedBox.shrink(),
            onTap: () => _confirmDanger(
              title: 'Hapus akun?',
              message: 'Semua tugas, sesi fokus, dan data wellbeingmu akan '
                  'hilang dan tidak bisa dikembalikan.',
              action: 'Ya, hapus permanen',
              toast: 'Permintaan hapus akun dikirim',
            ),
          ),
        ],
      ),
    );
  }

  void _openPasswordSheet() {
    var obscureCurrent = true;
    var obscureNew = true;
    var obscureRepeat = true;
    String? error;

    String eyeLabel(bool obscure) => obscure ? 'Lihat' : 'Sembunyi';

    showAppSheet(
      context,
      title: 'Ubah kata sandi',
      child: StatefulBuilder(
        builder: (sheetContext, setSheetState) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppField(
              label: 'Kata sandi saat ini',
              controller: _currentPass,
              obscure: obscureCurrent,
              suffix: TextButton(
                onPressed: () => setSheetState(
                  () => obscureCurrent = !obscureCurrent,
                ),
                child: Text(eyeLabel(obscureCurrent)),
              ),
            ),
            AppField(
              label: 'Kata sandi baru',
              controller: _newPass,
              obscure: obscureNew,
              hint: 'Minimal 8 karakter.',
              suffix: TextButton(
                onPressed: () => setSheetState(() => obscureNew = !obscureNew),
                child: Text(eyeLabel(obscureNew)),
              ),
            ),
            AppField(
              label: 'Ulangi kata sandi baru',
              controller: _repeatPass,
              obscure: obscureRepeat,
              error: error,
              suffix: TextButton(
                onPressed: () =>
                    setSheetState(() => obscureRepeat = !obscureRepeat),
                child: Text(eyeLabel(obscureRepeat)),
              ),
            ),
            AppFilledButton(
              label: 'Perbarui kata sandi',
              onTap: () {
                final message = _validatePasswords();
                if (message != null) {
                  setSheetState(() => error = message);
                  return;
                }
                _currentPass.clear();
                _newPass.clear();
                _repeatPass.clear();
                Navigator.of(sheetContext).pop();
                showAppToast(context, 'Kata sandi diperbarui ✓');
              },
            ),
            const SizedBox(height: 10),
            AppFilledButton(
              label: 'Batal',
              style: AppButtonStyle.ghost,
              onTap: () => Navigator.of(sheetContext).pop(),
            ),
          ],
        ),
      ),
    );
  }

  String? _validatePasswords() {
    if (_currentPass.text.isEmpty) {
      return 'Isi kata sandi saat ini dulu.';
    }
    if (_newPass.text.length < 8) {
      return 'Kata sandi baru minimal 8 karakter.';
    }
    if (_repeatPass.text != _newPass.text) {
      return 'Ulangi kata sandi belum sama.';
    }
    return null;
  }

  void _openTwoFactorSheet() {
    showAppSheet(
      context,
      title: 'Verifikasi dua langkah',
      child: StatefulBuilder(
        builder: (sheetContext, setSheetState) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Saat masuk di perangkat baru, kamu akan diminta kode tambahan. '
              'Akunmu tetap aman walau kata sandi bocor.',
              style: AppTypography.lead,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Aktifkan verifikasi dua langkah',
                    style: AppTypography.fieldValue,
                  ),
                ),
                AppSwitch(
                  value: _twoFactor,
                  semanticLabel: 'Verifikasi dua langkah',
                  onChanged: (value) {
                    setSheetState(() {});
                    setState(() => _twoFactor = value);
                    showAppToast(
                      context,
                      value
                          ? 'Verifikasi dua langkah aktif'
                          : 'Verifikasi dua langkah nonaktif',
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            AppFilledButton(
              label: 'Selesai',
              style: AppButtonStyle.ghost,
              onTap: () => Navigator.of(sheetContext).pop(),
            ),
          ],
        ),
      ),
    );
  }

  void _openSessionsSheet() {
    showAppSheet(
      context,
      title: 'Sesi aktif',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _device(
            'Pixel 8',
            'Bandung, Indonesia · Perangkat ini',
            current: true,
          ),
          const Divider(height: 1),
          _device('Chrome · Windows', 'Jakarta, Indonesia · 2 hari lalu'),
          const SizedBox(height: 20),
          AppFilledButton(
            label: 'Tutup',
            style: AppButtonStyle.ghost,
            onTap: () => Get.back<void>(),
          ),
        ],
      ),
    );
  }

  Widget _device(String name, String meta, {bool current = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const AppIconTile(
            background: AppColors.tileViolet,
            child: Icon(
              LucideIcons.smartphone,
              size: 18,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.fieldValue.copyWith(fontSize: 14.5),
                ),
                Text(meta, style: AppTypography.subtitle),
              ],
            ),
          ),
          if (current)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.okPill,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Ini',
                style: AppTypography.chipLabel.copyWith(
                  fontSize: 12,
                  color: AppColors.okPillText,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _confirmDanger({
    required String title,
    required String message,
    required String action,
    required String toast,
  }) {
    showAppSheet(
      context,
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(message, style: AppTypography.lead),
          const SizedBox(height: 18),
          AppFilledButton(
            label: action,
            style: AppButtonStyle.danger,
            onTap: () {
              Navigator.of(context).pop();
              showAppToast(context, toast);
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
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: active ? AppColors.okPill : AppColors.warnPill,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        active ? 'Aktif' : 'Atur',
        style: AppTypography.chipLabel.copyWith(
          fontSize: 12,
          color: active ? AppColors.okPillText : AppColors.warnText,
        ),
      ),
    );
  }
}
