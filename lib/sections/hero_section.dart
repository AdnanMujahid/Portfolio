import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/brutalist_button.dart';
import '../widgets/reveal_on_scroll.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({
    super.key,
    required this.isDesktop,
    required this.onViewProjects,
    required this.onContactMe,
  });

  final bool isDesktop;
  final VoidCallback onViewProjects;
  final VoidCallback onContactMe;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with SingleTickerProviderStateMixin {
  late final AnimationController _float;

  @override
  void initState() {
    super.initState();
    _float = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColumn = Padding(
      padding: const EdgeInsets.fromLTRB(20, 120, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          RevealOnScroll(
            child: Text(
              'ADNAN\nMUJAHID',
              style: widget.isDesktop ? AppText.displayXl() : AppText.displayHero(),
            ),
          ),
          const SizedBox(height: 16),
          RevealOnScroll(
            delay: const Duration(milliseconds: 100),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainer,
                border: Border(left: BorderSide(color: AppColors.primary, width: 8)),
              ),
              child: Text(
                'Software Engineer • Flutter Developer • AI Solutions Builder',
                style: AppText.headlineMd(color: AppColors.onSurfaceVariant)
                    .copyWith(fontFamily: AppText.bodyLg().fontFamily, fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 24),
          RevealOnScroll(
            delay: const Duration(milliseconds: 200),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                BrutalistButton(
                  label: 'View Resume',
                  icon: Icons.arrow_forward,
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  onTap:  () async {
                    final url = Uri.parse('https://drive.google.com/file/d/1dMho-RBGM12c10HGYZqxvwDncMXnuMUi/view?usp=sharing');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.inAppBrowserView);
                    }
                    },
                ),
                BrutalistButton(
                  label: 'Contact Me',
                  icon: Icons.mail_outline,
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.onSecondary,
                  onTap: widget.onContactMe,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final composition = RevealOnScroll(
      delay: const Duration(milliseconds: 300),
      child: SizedBox(
        height: 420,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            AnimatedBuilder(
              animation: _float,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -10 + 20 * _float.value),
                  child: child,
                );
              },
              child: Opacity(
                opacity: 0.85,
                child: Image.asset('assets/images/hero_shapes.jpg', fit: BoxFit.contain),
              ),
            ),
            Transform.rotate(
              angle: -0.05,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.ink, width: 8),
                  boxShadow: const [
                    BoxShadow(color: AppColors.ink, offset: Offset(16, 16), blurRadius: 0),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset('assets/images/avatar.jpg', fit: BoxFit.cover),
              ),
            ),
            Positioned(
              top: 8,
              right: 0,
              child: Transform.rotate(
                angle: 0.2,
                child: _FloatingTag(
                  label: 'MOBILE APPLICATION DEVELOPER',
                  background: AppColors.tertiary,
                  foreground: AppColors.onTertiary,
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              left: 0,
              child: Transform.rotate(
                angle: -0.1,
                child: _FloatingTag(
                  label: 'SOFTWARE ENGINEER',
                  background: AppColors.secondary,
                  foreground: AppColors.onSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (widget.isDesktop) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 5, child: textColumn),
            const SizedBox(width: 24),
            Expanded(flex: 5, child: composition),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          textColumn,
          const SizedBox(height: 32),
          composition,
        ],
      ),
    );
  }
}

class _FloatingTag extends StatelessWidget {
  const _FloatingTag({required this.label, required this.background, required this.foreground});
  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: AppColors.ink, width: 4),
        boxShadow: const [BoxShadow(color: AppColors.ink, offset: Offset(4, 4), blurRadius: 0)],
      ),
      child: Text(label, style: AppText.labelBold(color: foreground).copyWith(fontSize: 13)),
    );
  }
}
