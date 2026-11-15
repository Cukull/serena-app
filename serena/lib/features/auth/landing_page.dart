import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:serena/app/app_assets.dart';
import 'package:serena/app/app_routes.dart';
import 'package:serena/core/theme/app_colors.dart';
import 'package:serena/core/theme/app_typography.dart';
import 'package:serena/core/widgets/app_fill_button.dart';
import 'package:serena/core/widgets/app_gradient_background.dart';

/// Onboarding 3 slide (jadwal → fokus → tugas) + slider "Geser untuk Mulai".
/// Hanya tampil pada buka pertama kali; splash brand ada di [SplashGate].
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  static const _slides = [
    _SlideSpec(
      badge: 'PERENCANAAN JADWAL',
      headline: 'Atur Jadwal Belajarmu',
      body: 'Susun jadwal kuliah, agenda harian, dan tenggat waktu secara rapi '
          'agar alur belajarmu lebih terencana dan tenang.',
      art: AppAssets.onboardSchedule,
      badgeBg: Color(0xFFE0F5FE),
      badgeFg: Color(0xFF0284C7),
      badgeBorder: Color(0xFFBAE6FD),
    ),
    _SlideSpec(
      badge: 'SESI FOKUS',
      headline: 'Fokus Belajar Tanpa Distraksi',
      body: 'Gunakan timer Pomodoro untuk menyelesaikan tugas kuliah dengan '
          'ritme teratur: 25 menit fokus penuh, 5 menit jeda istirahat.',
      art: AppAssets.onboardFocus,
      badgeBg: Color(0xFFEEF2FF),
      badgeFg: Color(0xFF4F46E5),
      badgeBorder: Color(0xFFE0E7FF),
    ),
    _SlideSpec(
      badge: 'KELOLA TUGAS & STATISTIK',
      headline: 'Pantau Tugas & Tenggat Waktu',
      body:
          'Catat setiap tugas kuliah, prioritaskan yang mendesak, dan evaluasi '
          'capaian produktivitas belajarmu setiap minggu.',
      art: AppAssets.onboardTasks,
      badgeBg: Color(0xFFECFDF5),
      badgeFg: Color(0xFF059669),
      badgeBorder: Color(0xFFA7F3D0),
    ),
  ];

  final _pages = PageController();

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _go(int index) {
    if (!mounted) return;
    if (_pages.hasClients) {
      _pages.animateToPage(
        index,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _start() {
    Get.toNamed<void>(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppGradientBackground(
        gradient: AppColors.webPageBg,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 52,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: TextButton(
                      onPressed: _start,
                      child: Text(
                        'Lewati',
                        style: AppTypography.body.copyWith(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pages,
                  children: [
                    for (var i = 0; i < _slides.length; i++)
                      _InfoSlide(
                        spec: _slides[i],
                        index: i,
                        onNext:
                            i == _slides.length - 1 ? _start : () => _go(i + 1),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlideSpec {
  const _SlideSpec({
    required this.badge,
    required this.headline,
    required this.body,
    required this.art,
    required this.badgeBg,
    required this.badgeFg,
    required this.badgeBorder,
  });

  final String badge;
  final String headline;
  final String body;
  final String art;
  final Color badgeBg;
  final Color badgeFg;
  final Color badgeBorder;
}

class _InfoSlide extends StatelessWidget {
  const _InfoSlide({
    required this.spec,
    required this.index,
    required this.onNext,
  });

  final _SlideSpec spec;
  final int index;
  final VoidCallback onNext;

  bool get _last => index == 2;

  /// Animasi melayang khas tiap slide (kartu bergoyang, karakter bernapas,
  /// lalu daftar tugas mengambang).
  Widget _floatingArt() {
    final art = SvgPicture.asset(spec.art).animate(
      onPlay: (c) => c.repeat(reverse: true),
      delay: (index * 150).ms,
    );
    switch (index) {
      case 0:
        return art
            .rotate(
              begin: -0.015,
              end: 0.005,
              duration: 1900.ms,
              curve: Curves.easeInOut,
            )
            .moveY(
              begin: 0,
              end: -6,
              duration: 1900.ms,
              curve: Curves.easeInOut,
            );
      case 1:
        return art
            .scaleXY(
              begin: 1,
              end: 1.02,
              duration: 1500.ms,
              curve: Curves.easeInOut,
            )
            .moveY(
              begin: 0,
              end: -2,
              duration: 1500.ms,
              curve: Curves.easeInOut,
            );
      default:
        return art
            .rotate(
              begin: 0.01,
              end: -0.01,
              duration: 2100.ms,
              curve: Curves.easeInOut,
            )
            .moveY(
              begin: 0,
              end: -7,
              duration: 2100.ms,
              curve: Curves.easeInOut,
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
      child: Column(
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: _floatingArt(),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: spec.badgeBg,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: spec.badgeBorder),
            ),
            child: Text(
              spec.badge,
              style: AppTypography.badgeLabel.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.8,
                color: spec.badgeFg,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            spec.headline,
            textAlign: TextAlign.center,
            style: AppTypography.serif(21).copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Text(
              spec.body,
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(
                height: 1.5,
                color: AppColors.textMuted,
              ),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              final active = i == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                width: active ? 22 : 7,
                height: 7,
                margin: const EdgeInsets.symmetric(horizontal: 3.5),
                decoration: BoxDecoration(
                  gradient: active ? AppColors.webPrimary : null,
                  color: active ? null : const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(999),
                ),
              );
            }),
          ),
          const SizedBox(height: 14),
          if (!_last)
            AppFillButton(
              label: 'Lanjut',
              onPressed: onNext,
              trailing: const Icon(
                LucideIcons.arrowRight,
                size: 18,
                color: Colors.white,
              ),
            )
          else ...[
            Text(
              'Geser tombol untuk mulai merencanakan',
              style: AppTypography.caption.copyWith(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textFaint,
              ),
            ),
            const SizedBox(height: 10),
            _SwipeToStart(onCompleted: onNext),
            const SizedBox(height: 12),
            Text.rich(
              const TextSpan(
                text: 'Dengan melanjutkan, kamu menyetujui ',
                children: [
                  TextSpan(
                    text: 'Syarat & Privasi',
                    style: TextStyle(color: AppColors.primary),
                  ),
                  TextSpan(text: ' Serena.'),
                ],
              ),
              textAlign: TextAlign.center,
              style: AppTypography.caption.copyWith(height: 1.5),
            ),
          ],
        ],
      ),
    );
  }
}

class _SwipeToStart extends StatefulWidget {
  const _SwipeToStart({required this.onCompleted});

  final VoidCallback onCompleted;

  @override
  State<_SwipeToStart> createState() => _SwipeToStartState();
}

class _SwipeToStartState extends State<_SwipeToStart>
    with SingleTickerProviderStateMixin {
  static const _trackHeight = 52.0;
  static const _padding = 4.0;
  static const _knob = 44.0;

  double _offset = 0;
  double _from = 0;
  double _maxOffset = 0;

  late final AnimationController _snap = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  )..addListener(() => setState(() => _offset = _from * (1 - _snap.value)));

  @override
  void dispose() {
    _snap.dispose();
    super.dispose();
  }

  void _update(double dx, double max) {
    setState(() => _offset = dx.clamp(0, max));
  }

  void _release() {
    if (_offset >= _maxOffset * 0.72) {
      widget.onCompleted();
      return;
    }
    _from = _offset;
    _snap.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _maxOffset = constraints.maxWidth - (_padding * 2) - _knob;
        return Semantics(
          button: true,
          label: 'Geser untuk mulai merencanakan',
          onTap: widget.onCompleted,
          child: GestureDetector(
            onHorizontalDragUpdate: (d) =>
                _update(_offset + d.delta.dx, _maxOffset),
            onHorizontalDragEnd: (_) => _release(),
            child: Container(
              height: _trackHeight,
              decoration: BoxDecoration(
                color: const Color(0xD9FFFFFF),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: const Color(0xE6E1E6F5), width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x143C4682),
                    blurRadius: 18,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 28),
                      child: Opacity(
                        opacity:
                            (1 - _offset / (_maxOffset == 0 ? 1 : _maxOffset))
                                .clamp(0, 1),
                        child: Text(
                          'Geser untuk Mulai',
                          style: AppTypography.body.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: _padding + _offset,
                    top: _padding,
                    child: Container(
                      width: _knob,
                      height: _knob,
                      decoration: const BoxDecoration(
                        gradient: AppColors.webPrimary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x668B6CF0),
                            blurRadius: 14,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        LucideIcons.arrowRight,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
