import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:serena/app/app_routes.dart';
import 'package:serena/core/theme/app_colors.dart';

/// Welcome Serena — susunan persis contoh:
/// logo besar → nama SERENA → deskripsi → pills
/// (Wellness, Focus, Sleep, Progress) → ilustrasi
/// (Streak, Mood, figur di meja) → Get Started → Sign in.
/// - Hanya 2 warna brand: Soft Blue + Soft Purple (+ netral).
/// - 100% ikon Lucide, font Plus Jakarta Sans, tanpa gap kosong.
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  // --- Token 2-warna (tint dari 2 hue brand) ---
  static const _blueBg = Color(0xFFEAF6FC);
  static const _blueText = Color(0xFF2596C9);
  static const _purpleBg = Color(0xFFEFEDFF);
  static const _purpleText = Color(0xFF6B7CF8);

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.gradientBackground,
        ),
        child: Stack(
          children: [
            // Blob dekoratif — hanya 2 hue brand.
            Positioned(
              top: -screenW * 0.26,
              left: -screenW * 0.22,
              child: _blob(screenW * 0.62, const Color(0xFFD9EFFF)),
            ),
            Positioned(
              top: screenW * 0.06,
              right: -screenW * 0.24,
              child: _blob(screenW * 0.56, const Color(0xFFE2DCFF)),
            ),
            SafeArea(
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 14),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Ruang napas atas: mendorong logo turun agar
                          // tidak menempel status bar sekaligus mengisi
                          // void di layar jangkung (bukan di tengah konten).
                          const Spacer(flex: 2),
                          // 1) Logo besar di atas
                          const _SerenaMarkBig()
                              .animate()
                              .fadeIn(duration: 400.ms)
                              .slideY(begin: -0.15),
                          const SizedBox(height: 10),
                          // 2) Nama Serena
                          Text(
                            'SERENA',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              height: 1.0,
                              color: AppColors.ink,
                            ),
                          ).animate().fadeIn(delay: 80.ms),
                          const SizedBox(height: 4),
                          Text(
                            'Balance Your Mind, Study & Life.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.mutedGray,
                            ),
                          ).animate().fadeIn(delay: 120.ms),
                          const SizedBox(height: 10),
                          // 3) Description
                          Text(
                            'Your safe space to stay productive\nwhile taking care of your mental well-being.',
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              height: 1.55,
                              color: AppColors.bodyGray,
                            ),
                          ).animate().fadeIn(delay: 160.ms),
                          const SizedBox(height: 14),
                          // 4) Pills: satu gaya (bg putih, border struktural,
// ikon aksen bergantian biru/ungu). Wrap rata tengah.
                          const Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _Pill(
                                icon: LucideIcons.sprout,
                                label: 'Wellness',
                                accent: _blueText,
                              ),
                              _Pill(
                                icon: LucideIcons.timer,
                                label: 'Focus',
                                accent: _purpleText,
                              ),
                              _Pill(
                                icon: LucideIcons.moon,
                                label: 'Sleep',
                                accent: _blueText,
                              ),
                              _Pill(
                                icon: LucideIcons.trendingUp,
                                label: 'Progress',
                                accent: _purpleText,
                              ),
                            ],
                          ).animate().fadeIn(delay: 220.ms),
                          const SizedBox(height: 12),
                          // 5) Ilustrasi menempel tepat di bawah pills
                          // (jarak 12px, tidak ada void tengah).
                          const _StudyScene(),
                          // Sisa ruang layar jangkung ditampung di sini —
                          // di atas CTA (tempat yang wajar), bukan di
                          // tengah konten.
                          const Spacer(flex: 3),
                          // 6) Get Started
                          _GetStartedButton(
                            onPressed: () => Get.toNamed(Routes.register),
                          ).animate().fadeIn(delay: 380.ms),
                          // 7) Daftar / masuk (satu Text.rich agar wrap aman
                          // di layar sempit; hit area >= 44px).
                          GestureDetector(
                            onTap: () => Get.toNamed(Routes.login),
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 11,
                              ),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Already have an account? ',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        color: AppColors.mutedGray,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Sign in',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: _purpleText,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.65),
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Logo besar Serena — versi jumbo dari contoh (kotak gradien + "S").
/// Outer 32 = inner halo 24 + padding 8 (concentric).
class _SerenaMarkBig extends StatelessWidget {
  const _SerenaMarkBig();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        shape: BoxShape.circle,
      ),
      child: Container(
        width: 104,
        height: 104,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFCDE9FD), Color(0xFFDDD8FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.softPurple.withValues(alpha: 0.28),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: AppColors.softBlue.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.softBlue, AppColors.softPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            'S',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
              height: 1.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accent;

  const _Pill({
    required this.icon,
    required this.label,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 36),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        // Stadium + border struktural 1px (bukan untuk elevasi).
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE2E8F5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.softPurple.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: accent),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

/// CTA — press scale selalu 0.96, hit area 56px.
class _GetStartedButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _GetStartedButton({required this.onPressed});

  @override
  State<_GetStartedButton> createState() => _GetStartedButtonState();
}

class _GetStartedButtonState extends State<_GetStartedButton> {
  double _scale = 1.0;

  void _set(bool pressed) => setState(() => _scale = pressed ? 0.96 : 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: AppColors.gradientPrimary,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.softPurple.withValues(alpha: 0.38),
                blurRadius: 22,
                offset: const Offset(0, 12),
              ),
              BoxShadow(
                color: AppColors.softBlue.withValues(alpha: 0.22),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              borderRadius: BorderRadius.circular(18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Get Started',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.28),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      LucideIcons.arrowRight,
                      size: 15,
                      color: Colors.white,
                    ),
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

// ---------------------------------------------------------------------------
// Preview dashboard aplikasi: Streak + Mood sejajar, lalu satu kartu
// "Today's Tasks" (header + 3 tile stat + week bars + progress).
// Satu bahasa visual (kartu data), tanpa figur rakitan.
// ---------------------------------------------------------------------------

class _StudyScene extends StatelessWidget {
  const _StudyScene();

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final w = (screenW - 48).clamp(300.0, 360.0);

    return SizedBox(
      width: w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Streak + Mood: IntrinsicHeight + stretch agar tingginya
          // selalu sama. (stretch langsung di dalam Column tak
          // terbatas melempar "forces an infinite height".)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                Expanded(child: _StreakCard()),
                SizedBox(width: 12),
                Expanded(child: _MoodCard()),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const _DashPreview(),
        ],
      ),
    );
  }
}

/// Miniatur dashboard Serena: header tugas + chip timer,
/// 3 tile stat, week bars, progress. Hanya 2 hue + netral.
class _DashPreview extends StatelessWidget {
  const _DashPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.softPurple.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: AppColors.softBlue.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _TintIcon(
                icon: LucideIcons.clipboardCheck,
                bg: WelcomePage._blueBg,
                fg: WelcomePage._blueText,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Today's Tasks",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    Text(
                      '3 of 5 done',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.mutedGray,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: WelcomePage._purpleBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      LucideIcons.timer,
                      size: 13,
                      color: WelcomePage._purpleText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '25:00',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: WelcomePage._purpleText,
                        fontFeatures: const [
                          FontFeature.tabularFigures(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                child: _StatTile(
                  icon: LucideIcons.clipboardList,
                  value: '12/15',
                  label: 'Tasks',
                  bg: WelcomePage._blueBg,
                  fg: WelcomePage._blueText,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _StatTile(
                  icon: LucideIcons.timer,
                  value: '2h 30m',
                  label: 'Focus',
                  bg: WelcomePage._purpleBg,
                  fg: WelcomePage._purpleText,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _StatTile(
                  icon: LucideIcons.heart,
                  value: '4.2/5',
                  label: 'Mood',
                  bg: WelcomePage._blueBg,
                  fg: WelcomePage._blueText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const SizedBox(
            height: 34,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Bar(12, AppColors.softBlue),
                _Bar(20, AppColors.softPurple),
                _Bar(28, AppColors.softBlue),
                _Bar(17, AppColors.softPurple),
                _Bar(24, AppColors.softBlue),
                _Bar(14, AppColors.softPurple),
                _Bar(22, AppColors.softBlue),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 7,
            decoration: BoxDecoration(
              color: WelcomePage._blueBg,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.65,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.gradientPrimary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tile stat kecil di dalam preview: tint 2 hue, teks ink.
class _StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color bg;
  final Color fg;

  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.bg,
    required this.fg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        // Konsentris: 20 (kartu) = 12 + 8 padding.
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              color: AppColors.mutedGray,
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const _Card({
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        // Skala radius terkunci: kartu 20, isi dalam 12.
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.softPurple.withValues(alpha: 0.1),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppColors.softBlue.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CardLabel extends StatelessWidget {
  final String text;
  const _CardLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        color: AppColors.mutedGray,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _TintIcon extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color fg;
  const _TintIcon({required this.icon, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        // Konsentris: 20 (kartu) = 12 + 8 padding.
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 16, color: fg),
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _TintIcon(
                icon: LucideIcons.flame,
                bg: WelcomePage._purpleBg,
                fg: WelcomePage._purpleText,
              ),
              SizedBox(width: 6),
              _CardLabel('Streak'),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '14 days',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          Text(
            'consistent',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: AppColors.mutedGray,
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodCard extends StatelessWidget {
  const _MoodCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _TintIcon(
                icon: LucideIcons.sun,
                bg: WelcomePage._blueBg,
                fg: WelcomePage._blueText,
              ),
              SizedBox(width: 6),
              _CardLabel('Mood'),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '8.4',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: AppColors.softBlue,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  'Feeling good',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppColors.mutedGray,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double h;
  final Color c;
  const _Bar(this.h, this.c);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: h,
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
