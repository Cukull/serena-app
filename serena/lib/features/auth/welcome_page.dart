import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:serena/app/app_routes.dart';
import 'package:serena/core/theme/app_colors.dart';

/// Awal screen Florea — Splash / Welcome "Get Started".
/// Meniru contoh `login.png`: logo, tagline, pill fitur,
/// ilustrasi streak+mood, tombol Get Started + Sign in.
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.gradientBackground,
        ),
        child: Stack(
          children: [
            // Decorative soft blobs
            Positioned(
              top: -80,
              left: -60,
              child: _blob(220, const Color(0xFFD6E9FF).withOpacity(0.7)),
            ),
            Positioned(
              top: 40,
              right: -70,
              child: _blob(200, const Color(0xFFE7DEFF).withOpacity(0.8)),
            ),
            Positioned(
              bottom: 120,
              left: -80,
              child: _blob(240, const Color(0xFFE8F4FF).withOpacity(0.6)),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo + name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFDCEEFF), Color(0xFFE7DEFF)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.cardShadow.withOpacity(0.35),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(
                            LucideIcons.flower2,
                            color: Color(0xFF6A8DFF),
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 10),
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.fraunces(
                              fontSize: 32,
                              color: AppColors.ink,
                              fontWeight: FontWeight.w600,
                            ),
                            children: const [
                              TextSpan(text: 'Flor'),
                              TextSpan(
                                text: 'e',
                                style: TextStyle(color: Color(0xFF5AB8FF)),
                              ),
                              TextSpan(text: 'a '),
                              TextSpan(
                                text: '🌸',
                                style: TextStyle(fontSize: 24),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),

                    const SizedBox(height: 12),
                    Text(
                      'Your safe space to stay productive\nwhile taking care of your mental well-being.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(
                        fontSize: 15,
                        height: 1.5,
                        color: AppColors.bodyGray,
                      ),
                    ).animate().fadeIn(delay: 100.ms),

                    const SizedBox(height: 16),
                    // Feature pills
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        _Pill(
                          emoji: '🧘',
                          label: 'Wellness',
                          bg: Color(0xFFE8F4FF),
                          border: Color(0xFFBEE0FF),
                          text: Color(0xFF2D9CDB),
                        ),
                        _Pill(
                          emoji: '📚',
                          label: 'Focus',
                          bg: Color(0xFFF1ECFF),
                          border: Color(0xFFD3C6FF),
                          text: Color(0xFF7C5CFF),
                        ),
                        _Pill(
                          emoji: '💤',
                          label: 'Sleep',
                          bg: Color(0xFFE6F9ED),
                          border: Color(0xFFB8E8C8),
                          text: Color(0xFF22A55B),
                        ),
                        _Pill(
                          emoji: '📊',
                          label: 'Progress',
                          bg: Color(0xFFE8F4FF),
                          border: Color(0xFFBEE0FF),
                          text: Color(0xFF2D9CDB),
                        ),
                      ],
                    ).animate().fadeIn(delay: 200.ms),

                    const SizedBox(height: 20),
                    // Illustration
                    const _WelcomeIllustration()
                        .animate()
                        .fadeIn(delay: 300.ms)
                        .slideY(begin: 0.15),

                    const SizedBox(height: 24),
                    // CTA
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: AppColors.gradientPrimary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.softPurple.withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () => Get.toNamed(Routes.register),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Get Started',
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.arrow_forward,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 400.ms),

                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: AppColors.mutedGray,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed(Routes.login),
                          child: Text(
                            'Sign in',
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.skyBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _Pill extends StatelessWidget {
  final String emoji;
  final String label;
  final Color bg;
  final Color border;
  final Color text;

  const _Pill({
    required this.emoji,
    required this.label,
    required this.bg,
    required this.border,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Text(
        '$emoji $label',
        style: GoogleFonts.dmSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: text,
        ),
      ),
    );
  }
}

class _WelcomeIllustration extends StatelessWidget {
  const _WelcomeIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Desk
          Positioned(
            bottom: 28,
            child: Container(
              width: 230,
              height: 10,
              decoration: BoxDecoration(
                color: const Color(0xFFCDE6FF),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 110,
            child: Container(width: 8, height: 30, color: const Color(0xFFCDE6FF)),
          ),
          Positioned(
            bottom: 0,
            right: 110,
            child: Container(width: 8, height: 30, color: const Color(0xFFCDE6FF)),
          ),
          // Person
          Positioned(
            bottom: 36,
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE3C2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🧑‍💻', style: TextStyle(fontSize: 32)),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 90,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB9D9FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    LucideIcons.headphones,
                    color: Color(0xFF3B82F6),
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
          // Laptop + chart
          Positioned(
            bottom: 36,
            left: 60,
            child: Container(
              width: 74,
              height: 50,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadow.withOpacity(0.4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _bar(14, const Color(0xFF5AB8FF)),
                  _bar(20, const Color(0xFF8B7CF8)),
                  _bar(26, const Color(0xFF22C55E)),
                  _bar(18, const Color(0xFFFFB020)),
                ],
              ),
            ),
          ),
          // Coffee
          Positioned(
            bottom: 36,
            right: 62,
            child: Container(
              width: 52,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE8D1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Center(
                child: Text('☕', style: TextStyle(fontSize: 22)),
              ),
            ),
          ),
          // Streak card
          Positioned(
            top: 8,
            left: 0,
            child: _floatCard(
              title: '✅ Streak',
              big: '14 🔥',
              sub: 'days consistent',
              bigColor: const Color(0xFF22C55E),
            ),
          ),
          // Mood card
          Positioned(
            top: 8,
            right: 0,
            child: _floatCard(
              title: '☀️ Mood',
              big: '8.4',
              sub: '● Feeling good',
              bigColor: const Color(0xFF2D9CDB),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bar(double h, Color c) {
    return Container(
      width: 8,
      height: h,
      decoration:
          BoxDecoration(color: c, borderRadius: BorderRadius.circular(4)),
    );
  }

  Widget _floatCard({
    required String title,
    required String big,
    required String sub,
    required Color bigColor,
  }) {
    return Container(
      width: 118,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withOpacity(0.5),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              color: AppColors.mutedGray,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            big,
            style: GoogleFonts.dmSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: bigColor,
            ),
          ),
          Text(
            sub,
            style: GoogleFonts.dmSans(
              fontSize: 10,
              color: AppColors.mutedGray,
            ),
          ),
        ],
      ),
    );
  }
}
