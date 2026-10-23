// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_spacing.dart';
import 'package:serena/core/theme/app_theme.dart';
import 'package:serena/core/theme/app_typography.dart';
import 'package:serena/core/widgets/app_glass.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.helperText,
    this.isSuccess = false,
    this.enabled = true,
    this.autofillHints,
    this.inputFormatters,
    this.maxLines = 1,
    this.autovalidateMode,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final IconData? prefixIcon;

  /// Widget kustom di kanan (diabaikan jika [obscureText] true).
  final Widget? suffix;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final String? Function(String value)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? helperText;
  final bool isSuccess;
  final bool enabled;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final AutovalidateMode? autovalidateMode;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final bool _ownsController;
  late final bool _ownsFocusNode;

  late bool _obscure;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _ownsFocusNode = widget.focusNode == null;
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _obscure = widget.obscureText;
    _focusNode.addListener(_handleFocus);
  }

  void _handleFocus() {
    if (_focused != _focusNode.hasFocus) {
      setState(() => _focused = _focusNode.hasFocus);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocus);
    if (_ownsController) _controller.dispose();
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  Widget? _buildTrailing(bool hasError) {
    if (widget.obscureText) {
      return IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
        splashRadius: 18,
        onPressed: () => setState(() => _obscure = !_obscure),
        icon: Icon(
          _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          size: AppSizes.iconMd,
          color: AppColors.textMuted,
        ),
      );
    }
    if (widget.suffix != null) return widget.suffix;
    if (widget.isSuccess && !hasError) {
      return const Icon(
        Icons.check_circle_rounded,
        size: AppSizes.iconMd,
        color: AppColors.success,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (_) => widget.validator?.call(_controller.text),
      autovalidateMode: widget.autovalidateMode,
      builder: (state) {
        final hasError = state.hasError;
        final showSuccess = widget.isSuccess && !hasError;

        final Color borderColor;
        if (hasError) {
          borderColor = AppTheme.error;
        } else if (showSuccess) {
          borderColor = AppColors.inputSuccessBorder;
        } else if (_focused) {
          borderColor = AppColors.optionBorderPrimary;
        } else {
          borderColor = AppColors.glassBorder;
        }

        final shadows = showSuccess
            ? <BoxShadow>[
                const BoxShadow(
                  color: AppColors.inputSuccessGlow,
                  spreadRadius: 3,
                ),
                ...AppShadows.input,
              ]
            : AppShadows.input;

        final trailing = _buildTrailing(hasError);
        final singleLine = widget.maxLines == 1 || widget.obscureText;

        return Opacity(
          opacity: widget.enabled ? 1 : 0.6,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.label != null) ...[
                Text(widget.label!, style: AppTypography.label),
                const SizedBox(height: 6),
              ],
              AppGlass(
                blur: AppBlur.input,
                borderRadius: AppRadius.input,
                color: AppColors.glassInput,
                borderColor: borderColor,
                borderWidth: _focused ? 1.5 : 1,
                shadows: shadows,
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(minHeight: AppSizes.inputHeight),
                  child: Row(
                    crossAxisAlignment: singleLine
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    children: [
                      if (widget.prefixIcon != null)
                        Padding(
                          padding: EdgeInsets.only(
                            left: AppSpacing.xl,
                            top: singleLine ? 0 : 17,
                          ),
                          child: Icon(
                            widget.prefixIcon,
                            size: AppSizes.iconMd,
                            color: _focused
                                ? AppColors.primary
                                : AppColors.textMuted,
                          ),
                        ),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          enabled: widget.enabled,
                          obscureText: widget.obscureText && _obscure,
                          keyboardType: widget.keyboardType,
                          textInputAction: widget.textInputAction,
                          textCapitalization: widget.textCapitalization,
                          autofillHints: widget.autofillHints,
                          inputFormatters: widget.inputFormatters,
                          maxLines: widget.obscureText ? 1 : widget.maxLines,
                          style: AppTypography.input,
                          cursorColor: AppColors.primary,
                          onChanged: (value) {
                            state.didChange(value);
                            widget.onChanged?.call(value);
                          },
                          onSubmitted: widget.onSubmitted,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: false,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            hintText: widget.hint,
                            hintStyle: AppTypography.inputHint,
                            contentPadding: EdgeInsets.fromLTRB(
                              widget.prefixIcon == null
                                  ? AppSpacing.xl
                                  : AppSpacing.lg,
                              16,
                              AppSpacing.lg,
                              16,
                            ),
                          ),
                        ),
                      ),
                      if (trailing != null)
                        Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.lg),
                          child: trailing,
                        ),
                    ],
                  ),
                ),
              ),
              if (hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Text(
                    state.errorText!,
                    style: AppTypography.helper.copyWith(color: AppTheme.error),
                  ),
                )
              else if (widget.helperText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Text(
                    widget.helperText!,
                    style: widget.isSuccess
                        ? AppTypography.helper
                        : AppTypography.helper
                            .copyWith(color: AppColors.textMuted),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
