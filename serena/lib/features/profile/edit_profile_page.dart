import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_typography.dart';
import 'package:serena/core/widgets/app_ui.dart';

/// Info Pribadi — mengikuti `referensi/info-pribadi.html`.
///
/// shortcut: data profil & minat masih lokal di halaman ini; pindahkan ke
/// ProfileRepository saat tabel profil diperluas (telepon, akademik, minat).
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _name = TextEditingController(text: 'Yusup Arief Fauzi');
  final _email = TextEditingController(text: 'yusup.arief@gmail.com');
  final _phone = TextEditingController(text: '+62 812-3456-7890');
  final _dob = TextEditingController(text: '15 Maret 2002');
  final _uni = TextEditingController(text: 'Bandung Tech University');
  final _major = TextEditingController(text: 'Ilmu Komputer');
  final _nim = TextEditingController(text: '2021-CS-0847');
  final _newChip = TextEditingController();

  final _chips = <String>[
    'Desain ✨',
    'Coding 💻',
    'Kesehatan 🌿',
    'Musik 🎵',
    'Membaca 📚',
    'Jurnal ✍️',
    'Yoga 🧘',
  ];
  final _errors = <String, String?>{};
  final _saved = <TextEditingController, String>{};
  bool _editing = false;
  bool _addingChip = false;

  List<TextEditingController> get _controllers => [
        _name,
        _email,
        _phone,
        _dob,
        _uni,
        _major,
        _nim,
      ];

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _newChip.dispose();
    super.dispose();
  }

  void _startEditing() {
    _saved.clear();
    for (final controller in _controllers) {
      _saved[controller] = controller.text;
    }
    setState(() {
      _editing = true;
      _errors.clear();
    });
  }

  void _cancelEditing() {
    _saved.forEach((controller, text) => controller.text = text);
    setState(() {
      _editing = false;
      _errors.clear();
      _addingChip = false;
    });
  }

  void _save() {
    final errors = <String, String?>{};
    if (_name.text.trim().isEmpty) {
      errors['name'] = 'Nama tidak boleh kosong.';
    }
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(_email.text)) {
      errors['email'] = 'Format email belum benar, contoh: nama@email.com';
    }
    if (!RegExp(r'^\+?[0-9\s-]{8,16}$').hasMatch(_phone.text.trim())) {
      errors['phone'] = 'Nomor telepon belum benar, contoh: +62 812-3456-7890';
    }
    if (errors.isNotEmpty) {
      setState(() => _errors.addAll(errors));
      return;
    }
    setState(() {
      _editing = false;
      _errors.clear();
      _addingChip = false;
    });
    showAppToast(context, 'Perubahan tersimpan ✓');
  }

  void _addChip() {
    final value = _newChip.text.trim();
    if (value.isEmpty) {
      return;
    }
    if (_chips.contains(value)) {
      showAppToast(context, 'Minat itu sudah ada');
      return;
    }
    setState(() {
      _chips.add(value);
      _newChip.clear();
    });
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
                _identity(),
                _stats(),
                AppSectionHeader(
                  label: 'INFO DASAR',
                  action: _editing ? null : 'Ubah',
                  onAction: _startEditing,
                ),
                _fieldList(_basicFields),
                AppSectionHeader(
                  label: 'INFO AKADEMIK',
                  action: _editing ? null : 'Ubah',
                  onAction: _startEditing,
                ),
                _fieldList(_academicFields),
                AppSectionHeader(
                  label: 'MINAT & VIBES',
                  action: '+ Tambah',
                  onAction: () => setState(() => _addingChip = !_addingChip),
                ),
                _chipsCard(),
                if (_editing) ...[
                  const SizedBox(height: 22),
                  AppFilledButton(label: 'Simpan perubahan', onTap: _save),
                  const SizedBox(height: 10),
                  AppFilledButton(
                    label: 'Batal',
                    style: AppButtonStyle.ghost,
                    onTap: _cancelEditing,
                  ),
                ],
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
          child: Text('Info Pribadi', style: AppTypography.pageTitle),
        ),
        AppPillButton(
          label: _editing ? 'Simpan' : 'Edit',
          onTap: _editing ? _save : _startEditing,
        ),
      ],
    );
  }

  Widget _identity() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Column(
        children: [
          SizedBox(
            width: 104,
            height: 104,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 104,
                  height: 104,
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.avatarRingGradient,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDDEBFB),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.userRound,
                      size: 52,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                Positioned(
                  right: -2,
                  bottom: 2,
                  child: GestureDetector(
                    onTap: () => showAppToast(
                      context,
                      'Ganti foto belum tersedia',
                    ),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 3),
                      ),
                      child: const Icon(
                        LucideIcons.camera,
                        size: 14,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _name.text,
            style: AppTypography.fieldValue.copyWith(
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Mahasiswa · ${_major.text}',
            style: AppTypography.subtitle,
          ),
          InkWell(
            onTap: () => showAppToast(context, 'Ganti foto belum tersedia'),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Text('Ganti foto', style: AppTypography.actionLink),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stats() {
    return Row(
      children: [
        _stat('✅', '12', 'Tugas selesai'),
        const SizedBox(width: 10),
        _stat('⏳', '14j', 'Waktu fokus'),
        const SizedBox(width: 10),
        _stat('🔥', '12', 'Hari beruntun'),
      ],
    );
  }

  Widget _stat(String emoji, String value, String label) {
    return Expanded(
      child: AppCard(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        radius: 18,
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            Text(value, style: AppTypography.statBig),
            Text(label, style: AppTypography.subtitle.copyWith(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  List<_FieldSpec> get _basicFields => [
        _FieldSpec('name', 'Nama lengkap', '👤', AppColors.tileBlue, _name),
        _FieldSpec('email', 'Email', '✉️', AppColors.tileViolet, _email),
        _FieldSpec('phone', 'Telepon', '📞', AppColors.tilePeach, _phone),
        _FieldSpec('dob', 'Tanggal lahir', '📅', AppColors.tileGreen, _dob),
      ];

  List<_FieldSpec> get _academicFields => [
        _FieldSpec('uni', 'Universitas', '🏫', AppColors.tileBlue, _uni),
        _FieldSpec('major', 'Jurusan', '📘', AppColors.tileViolet, _major),
        _FieldSpec('nim', 'NIM', '🪪', AppColors.tilePeach, _nim),
      ];

  Widget _fieldList(List<_FieldSpec> fields) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      child: Column(
        children: [
          for (var i = 0; i < fields.length; i++)
            _fieldRow(fields[i], last: i == fields.length - 1),
        ],
      ),
    );
  }

  Widget _fieldRow(_FieldSpec spec, {required bool last}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppIconTile(
                background: spec.tint,
                child: Text(spec.emoji, style: const TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(spec.label, style: AppTypography.fieldLabel),
                    const SizedBox(height: 2),
                    if (_editing)
                      TextField(
                        controller: spec.controller,
                        style: AppTypography.fieldValue,
                        decoration: InputDecoration(
                          isDense: true,
                          errorText: _errors[spec.key],
                        ),
                      )
                    else
                      Text(
                        spec.controller.text,
                        style: AppTypography.fieldValue,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!last) const Divider(height: 1),
      ],
    );
  }

  Widget _chipsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          padding: const EdgeInsets.all(14),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < _chips.length; i++) _chip(_chips[i], i % 4),
            ],
          ),
        ),
        if (_addingChip) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _newChip,
                  onSubmitted: (_) => _addChip(),
                  decoration: const InputDecoration(
                    hintText: 'Contoh: Fotografi',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 96,
                height: 52,
                child: AppFilledButton(label: 'Tambah', onTap: _addChip),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _chip(String label, int variant) {
    final (background, border, text) = switch (variant) {
      0 => (
          AppColors.chipBlueBg,
          AppColors.chipBlueBorder,
          AppColors.chipBlueText,
        ),
      1 => (
          AppColors.chipVioletBg,
          AppColors.chipBorderSecondary,
          AppColors.chipVioletText,
        ),
      2 => (
          AppColors.chipGreenBg,
          AppColors.inputSuccessBorder,
          AppColors.chipGreenText,
        ),
      _ => (
          AppColors.chipPeachBg,
          AppColors.chipPeachBorder,
          AppColors.chipPeachText,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.chipLabel.copyWith(color: text),
          ),
          if (_editing) ...[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => setState(() => _chips.remove(label)),
              child: Text(
                '✕',
                style: AppTypography.chipLabel.copyWith(color: text),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FieldSpec {
  const _FieldSpec(
    this.key,
    this.label,
    this.emoji,
    this.tint,
    this.controller,
  );

  final String key;
  final String label;
  final String emoji;
  final Color tint;
  final TextEditingController controller;
}
