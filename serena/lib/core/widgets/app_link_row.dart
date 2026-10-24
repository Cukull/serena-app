// ignore_for_file: lines_longer_than_80_chars, public_member_api_docs, always_put_required_named_parameters_first

import 'package:flutter/material.dart';

import 'package:serena/core/theme/app_typography.dart';

class AppLinkRow extends StatelessWidget {
  const AppLinkRow({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
  });

  final String text;
  final String linkText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('$text ', style: AppTypography.body),
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(linkText, style: AppTypography.bodyLink),
          ),
        ),
      ],
    );
  }
}
