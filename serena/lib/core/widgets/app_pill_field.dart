import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_typography.dart';

/// Input pil putih layar auth (radius 26, ikon kiri, aksi kanan opsional).
class AppPillField extends StatefulWidget {
  const AppPillField({
    required this.hint,
    super.key,
    this.controller,
    this.icon = LucideIcons.mail,
    this.obscure = false,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.suffix,
    this.onChanged,
    this.onSubmitted,
  });

  final String hint;
  final TextEditingController? controller;
  final IconData icon;

  /// Menampilkan tombol mata untuk sembunyikan/tampilkan isi.
  final bool obscure;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  State<AppPillField> createState() => _AppPillFieldState();
}

class _AppPillFieldState extends State<AppPillField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(26),
      borderSide: const BorderSide(color: AppColors.webFieldBorder, width: 1.5),
    );

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscure && _hidden,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      textAlignVertical: TextAlignVertical.center,
      cursorColor: AppColors.primary,
      style: AppTypography.lead.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: AppTypography.lead.copyWith(color: AppColors.textFaint),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        prefixIcon: Icon(widget.icon, size: 18, color: AppColors.textFaint),
        prefixIconConstraints: const BoxConstraints(minWidth: 46),
        suffixIcon: widget.obscure
            ? IconButton(
                onPressed: () => setState(() => _hidden = !_hidden),
                icon: Icon(
                  _hidden ? LucideIcons.eye : LucideIcons.eyeOff,
                  size: 19,
                  color: AppColors.textMuted,
                ),
                tooltip: _hidden ? 'Tampilkan sandi' : 'Sembunyikan sandi',
              )
            : widget.suffix,
        suffixIconConstraints: const BoxConstraints(minWidth: 46),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: border.copyWith(
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
        focusedErrorBorder: border.copyWith(
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
        errorStyle: AppTypography.caption.copyWith(color: AppColors.danger),
        errorMaxLines: 2,
      ),
    );
  }
}
