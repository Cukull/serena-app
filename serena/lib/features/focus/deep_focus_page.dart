import 'package:flutter/material.dart';

import 'package:serena/models/focus_session.dart';
import 'package:serena/widgets/focus_timer_view.dart';

class DeepFocusPage extends StatelessWidget {
  const DeepFocusPage({super.key});

  @override
  Widget build(BuildContext context) => const FocusTimerView(
        mode: FocusMode.deepFocus,
        initialMinutes: 45,
        allowAdjust: true,
      );
}
