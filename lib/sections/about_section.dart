import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/brutalist_card.dart';
import '../widgets/reveal_on_scroll.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key, required this.isDesktop});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final bio = RevealOnScroll(
      child: BrutalistCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('BIO', style: isDesktop ? AppText.displayLg() : AppText.displayLgMobile()),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                style: AppText.bodyLg(),
                children: [
                  const TextSpan(text: 'I am a passionate '),
                  TextSpan(
                    text: 'Software Engineer',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const TextSpan(text: ' based in '),
                  const TextSpan(
                      text: 'Islamabad, Pakistan',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                  const TextSpan(
                      text: ', specializing in building high-performance mobile applications '
                          'and AI-driven solutions. With a focus on '),
                  TextSpan(
                    text: 'Flutter and Python',
                    style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                      text: ', I transform complex technical requirements into elegant, '
                          'user-centric experiences.'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const [
                _MetaPill(icon: Icons.location_on, label: 'ISLAMABAD, PK'),
                _MetaPill(icon: Icons.code, label: '1+ YEARS EXP'),
              ],
            ),
          ],
        ),
      ),
    );

    final statCard1 = RevealOnScroll(
      delay: const Duration(milliseconds: 100),
      child: const _StatCard(value: '51', label: 'Repos on GitHub', color: AppColors.primary),
    );
    final statCard2 = RevealOnScroll(
      delay: const Duration(milliseconds: 200),
      child: const _StatCard(value: '246', label: 'Contributions', color: AppColors.tertiary),
    );

    // Vertical stacking (desktop sidebar) needs no flex — cards just take
    // their intrinsic height. Horizontal stacking (mobile) sits inside a
    // bounded-width Row, where Expanded is safe to split the space evenly.
    final stats = isDesktop
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [statCard1, const SizedBox(height: 24), statCard2],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: statCard1),
              const SizedBox(width: 24),
              Expanded(child: statCard2),
            ],
          );

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 8, child: bio),
          const SizedBox(width: 24),
          Expanded(flex: 4, child: stats),
        ],
      );
    }

    return Column(
      children: [
        bio,
        const SizedBox(height: 24),
        stats,
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label, required this.color});
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return BrutalistCard(
      color: color,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: AppText.displayLg(color: AppColors.onPrimary)),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: AppText.labelBold(color: AppColors.onPrimary),
          ),
        ],
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        border: Border.all(color: AppColors.ink, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.onSurface),
          const SizedBox(width: 6),
          Text(label, style: AppText.bodySm(color: AppColors.onSurface).copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
