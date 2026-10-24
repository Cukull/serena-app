// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:serena/core/theme/app_spacing.dart';
import 'package:serena/core/widgets/app_glass.dart';

class AppFormCard extends StatelessWidget {
  const AppFormCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.cardPadding),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return AppGlass(
      borderRadius: AppRadius.cardRadius,
      shadows: AppShadows.card,
      padding: padding,
      width: double.infinity,
      child: child,
    );
  }
}
