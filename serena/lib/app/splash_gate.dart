import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:serena/app/app_assets.dart';
import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_typography.dart';
import 'package:serena/core/widgets/app_gradient_background.dart';

/// Splash brand di atas halaman tujuan (login/onboarding/main). Halaman di
/// belakangnya sudah dibangun lebih dulu, jadi saat splash memudar tidak ada
/// layar kosong atau lompatan.
class SplashGate extends StatefulWidget {
  const SplashGate({required this.child, super.key});

  final Widget child;

  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate> {
  static const _hold = Duration(milliseconds: 1800);
  static const _fade = Duration(milliseconds: 450);

  Timer? _timer;
  bool _fading = false;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(_hold, () {
      if (mounted) setState(() => _fading = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (!_done)
          IgnorePointer(
            ignoring: _fading,
            child: AnimatedOpacity(
              opacity: _fading ? 0 : 1,
              duration: _fade,
              curve: Curves.easeOut,
              onEnd: () {
                if (_fading && mounted) setState(() => _done = true);
              },
              child: AnimatedScale(
                scale: _fading ? 1.03 : 1,
                duration: _fade,
                curve: Curves.easeOut,
                child: const _SplashView(),
              ),
            ),
          ),
      ],
    );
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    return AppGradientBackground(
      gradient: AppColors.webPageBg,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0x4063C7F7), Color(0x408B7CF8)],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: const Color(0x7363C7F7),
                      width: 1.5,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3D5B8DEF),
                        blurRadius: 40,
                        offset: Offset(0, 18),
                      ),
                    ],
                  ),
                  child: Image.asset(AppAssets.logo),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveY(
                      begin: 0,
                      end: -6,
                      duration: 1800.ms,
                      curve: Curves.easeInOut,
                    )
                    .scaleXY(
                      begin: 1,
                      end: 1.03,
                      duration: 1800.ms,
                      curve: Curves.easeInOut,
                    ),
                const SizedBox(height: 14),
                Image.asset(AppAssets.wordmark, height: 32),
                const SizedBox(height: 14),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0x1F5B8DEF),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0x385B8DEF)),
                  ),
                  child: Text(
                    'BALANCE YOUR MIND, STUDY & LIFE',
                    style: AppTypography.badgeLabel.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.5,
                      color: const Color(0xFF5B8DEF),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 270),
                  child: Text(
                    '\u201CRencanakan jadwal perkuliahan, tuntaskan tugas, dan '
                    'capai fokus belajar terbaikmu.\u201D',
                    textAlign: TextAlign.center,
                    style: AppTypography.serif(15).copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400,
                      height: 1.6,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    return Container(
                      width: 7,
                      height: 7,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFA5B4FC),
                        shape: BoxShape.circle,
                      ),
                    )
                        .animate(
                          onPlay: (c) => c.repeat(reverse: true),
                          delay: (i * 220).ms,
                        )
                        .fadeIn(
                          begin: 0.4,
                          duration: 700.ms,
                          curve: Curves.easeInOut,
                        )
                        .scaleXY(
                          begin: 0.9,
                          end: 1.35,
                          duration: 700.ms,
                          curve: Curves.easeInOut,
                        );
                  }),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms, curve: Curves.easeOut),
          ),
        ),
      ),
    );
  }
}
