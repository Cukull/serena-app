import 'package:flutter/material.dart';

import 'package:serena/models/focus_session.dart';
import 'package:serena/widgets/focus_timer_view.dart';

class PomodoroPage extends StatelessWidget {
  const PomodoroPage({super.key});

  @override
  Widget build(BuildContext context) => const FocusTimerView(
        mode: FocusMode.pomodoro,
        initialMinutes: 25,
      );
}
