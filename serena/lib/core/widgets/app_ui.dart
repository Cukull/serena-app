import 'package:flutter/material.dart';

import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_typography.dart';

/// Komponen permukaan bersama untuk layar bergaya `design.md`:
/// latar gradien, kartu putih, baris kartu, tile ikon, switch, sheet.
class SerenaBackground extends StatelessWidget {
  const SerenaBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.gradientBackground),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const _Blob(
            color: AppColors.blobViolet,
            alignment: const Alignment(1.2, -1.2),
            size: 240,
            opacity: 0.75,
          ),
          const _Blob(
            color: AppColors.blobCyan,
            alignment: const Alignment(-2, 0.38),
            size: 220,
            opacity: 0.6,
          ),
          child,
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({
    required this.color,
    required this.alignment,
    required this.size,
    required this.opacity,
  });

  final Color color;
  final Alignment alignment;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: opacity),
                color.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Tombol bulat putih 44 (kembali, edit, aksi header).
class AppCircleButton extends StatelessWidget {
  const AppCircleButton({
    required this.icon,
    this.onTap,
    this.semanticLabel,
    this.size = 44,
    this.iconSize = 20,
    this.color = AppColors.textPrimary,
    this.background = AppColors.white,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final double size;
  final double iconSize;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: background,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Color(0x143C4682),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Icon(icon, size: iconSize, color: color),
          ),
        ),
      ),
    );
  }
}

/// Kartu putih radius 20 dengan bayangan lembut.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 20,
    this.color = AppColors.white,
    this.border,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color color;
  final Color? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: border == null ? null : Border.all(color: border!),
        boxShadow: const [
          BoxShadow(
            color: Color(0x123C4682),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Judul bagian + tautan aksi opsional ("Ubah", "+ Tambah").
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    required this.label,
    this.action,
    this.onAction,
    this.danger = false,
    super.key,
  });

  final String label;
  final String? action;
  final VoidCallback? onAction;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 22, 4, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTypography.sectionLabel.copyWith(
                color: danger ? AppColors.danger : AppColors.textFaint,
              ),
            ),
          ),
          if (action != null)
            InkWell(
              onTap: onAction,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 4,
                ),
                child: Text(action!, style: AppTypography.actionLink),
              ),
            ),
        ],
      ),
    );
  }
}

/// Tile ikon 42 di kiri baris kartu.
class AppIconTile extends StatelessWidget {
  const AppIconTile({
    required this.child,
    required this.background,
    this.size = 42,
    super.key,
  });

  final Widget child;
  final Color background;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}

/// Baris dalam kartu daftar: tile, judul, subjudul, trailing.
class AppCardRow extends StatelessWidget {
  const AppCardRow({
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.showDivider = true,
    this.titleColor,
    super.key,
  });

  final Widget leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.fieldValue.copyWith(
                    color: titleColor ?? AppColors.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: AppTypography.subtitle),
                ],
              ],
            ),
          ),
          if (trailing != null)
            trailing!
          else if (onTap != null)
            const Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: AppColors.textMuted,
            ),
        ],
      ),
    );

    return Column(
      children: [
        if (onTap == null) row else InkWell(onTap: onTap, child: row),
        if (showDivider) const Divider(height: 1),
      ],
    );
  }
}

/// Switch 52×32 violet sesuai referensi.
class AppSwitch extends StatelessWidget {
  const AppSwitch({
    required this.value,
    required this.onChanged,
    this.semanticLabel,
    super.key,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      label: semanticLabel,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 52,
          height: 32,
          decoration: BoxDecoration(
            color: value ? AppColors.primary : const Color(0xFFCDD2E4),
            borderRadius: BorderRadius.circular(16),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 26,
              height: 26,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tombol lebar penuh 52: primary (gradien), ghost, danger.
class AppFilledButton extends StatelessWidget {
  const AppFilledButton({
    required this.label,
    required this.onTap,
    this.style = AppButtonStyle.primary,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;
  final AppButtonStyle style;

  @override
  Widget build(BuildContext context) {
    final decoration = switch (style) {
      AppButtonStyle.primary => const BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.all(Radius.circular(18)),
          boxShadow: [
            BoxShadow(
              color: Color(0x4D7C6BF0),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
      AppButtonStyle.ghost => BoxDecoration(
          color: AppColors.glassBadge,
          borderRadius: BorderRadius.circular(18),
        ),
      AppButtonStyle.danger => const BoxDecoration(
          color: AppColors.danger,
          borderRadius: BorderRadius.all(Radius.circular(18)),
          boxShadow: [
            BoxShadow(
              color: Color(0x4DE5646B),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
    };

    return SizedBox(
      height: 52,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: decoration,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            child: Center(
              child: Text(
                label,
                style: AppTypography.button.copyWith(
                  color: style == AppButtonStyle.ghost
                      ? AppColors.textPrimary
                      : AppColors.textOnGradient,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum AppButtonStyle { primary, ghost, danger }

/// Pill kecil di header halaman ("Edit", "Simpan").
class AppPillButton extends StatelessWidget {
  const AppPillButton({required this.label, required this.onTap, super.key});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(19),
      child: Container(
        height: 38,
        constraints: const BoxConstraints(minWidth: 64),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.secondaryTint,
          borderRadius: BorderRadius.circular(19),
          border: Border.all(color: AppColors.logoRing),
        ),
        child: Text(
          label,
          style: AppTypography.chipLabel.copyWith(
            color: AppColors.secondaryDark,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

/// Pill status skor ("Skor keamanan: 85/100").
class AppStatusPill extends StatelessWidget {
  const AppStatusPill({
    required this.label,
    this.ok = true,
    super.key,
  });

  final String label;
  final bool ok;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: ok ? AppColors.okPill : AppColors.warnPill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: ok ? AppColors.okPillBorder : AppColors.warnPillBorder,
        ),
      ),
      child: Text(
        label,
        style: AppTypography.chipLabel.copyWith(
          color: ok ? AppColors.okPillText : AppColors.warnText,
        ),
      ),
    );
  }
}

/// Bottom sheet putih 30px atas dengan judul dan tombol tutup.
Future<void> showAppSheet(
  BuildContext context, {
  required String title,
  required Widget child,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    barrierColor: const Color(0x731B2340),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        24 + MediaQuery.viewInsetsOf(sheetContext).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.h3.copyWith(fontSize: 20),
                  ),
                ),
                AppCircleButton(
                  icon: Icons.close_rounded,
                  size: 40,
                  iconSize: 18,
                  background: AppColors.glassBadge,
                  semanticLabel: 'Tutup',
                  onTap: () => Navigator.of(sheetContext).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    ),
  );
}

/// Toast gelap ringkas (pengganti toast di referensi HTML).
void showAppToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 2200),
      ),
    );
}

/// Field berlabel untuk form inline dan sheet.
class AppField extends StatelessWidget {
  const AppField({
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.obscure = false,
    this.suffix,
    this.error,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final bool obscure;
  final Widget? suffix;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label, style: AppTypography.label),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon: suffix,
              errorText: error,
            ),
          ),
        ],
      ),
    );
  }
}
