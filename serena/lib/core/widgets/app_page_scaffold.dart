// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_spacing.dart';
import 'package:serena/core/widgets/app_gradient_background.dart';

class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    required this.child,
    super.key,
    this.gradient = AppColors.bgLogin,
    this.horizontalPadding = AppSpacing.screenH,
    this.verticalPadding = AppSpacing.xxl,
    this.scrollable = true,
    this.showBlobs = true,
    this.appBar,
    this.bottomBar,
  });

  final Widget child;
  final LinearGradient gradient;
  final double horizontalPadding;
  final double verticalPadding;
  final bool scrollable;
  final bool showBlobs;
  final PreferredSizeWidget? appBar;
  final Widget? bottomBar;

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.symmetric(
      horizontal: horizontalPadding,
      vertical: verticalPadding,
    );

    return AppGradientBackground(
      gradient: gradient,
      showBlobs: showBlobs,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar,
        bottomNavigationBar: bottomBar,
        body: SafeArea(
          child: scrollable
              ? SingleChildScrollView(
                  padding: padding,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: child,
                )
              : Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
