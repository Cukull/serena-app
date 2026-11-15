import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:serena/app/app_assets.dart';
import 'package:serena/core/theme/app_colors.dart';

/// Header brand layar auth: logo + wordmark, dengan tombol kembali opsional.
class AuthBrandHeader extends StatelessWidget {
  const AuthBrandHeader({super.key, this.onBack, this.onTap});

  final VoidCallback? onBack;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onBack == null)
          const SizedBox(width: 36)
        else
          _CircleButton(icon: LucideIcons.chevronLeft, onTap: onBack!),
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0x3863C7F7), Color(0x388B7CF8)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x6163C7F7)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3363C7F7),
                        blurRadius: 20,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(AppAssets.logo),
                  ),
                ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(
                      begin: 0,
                      end: -3,
                      duration: 1750.ms,
                      curve: Curves.easeInOut,
                    ),
                const SizedBox(width: 12),
                Image.asset(AppAssets.wordmark, height: 22),
              ],
            ),
          ),
        ),
        const SizedBox(width: 36),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: Material(
        color: const Color(0xCCFFFFFF),
        shape: const CircleBorder(
          side: BorderSide(color: AppColors.webFieldBorder),
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Icon(icon, size: 20, color: const Color(0xFF1E293B)),
        ),
      ),
    );
  }
}
