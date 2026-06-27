import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/brutalist_card.dart';
import '../widgets/reveal_on_scroll.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key, required this.isDesktop});

  final bool isDesktop;

  static const _skills = <(String, Color, Color, double)>[
    ('FLUTTER', AppColors.primaryContainer, AppColors.onPrimaryContainer, 0.03),
    ('FIREBASE', AppColors.secondaryContainer, Colors.white, -0.03),
    ('AI / ML', AppColors.tertiaryContainer, Colors.white, 0.05),
    ('PYTHON', AppColors.onSurface, AppColors.surface, -0.02),
    ('DART', AppColors.surfaceContainerHighest, AppColors.onSurface, 0.08),
    ('FASTAPI', AppColors.primary, AppColors.onPrimary, -0.05),
    ('OPENAI API', AppColors.secondary, AppColors.onSecondary, 0.02),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RevealOnScroll(
          child: Text(
            'TECHNICAL STACK',
            textAlign: TextAlign.center,
            style: isDesktop ? AppText.displayLg() : AppText.displayLgMobile(),
          ),
        ),
        const SizedBox(height: 24),
        RevealOnScroll(
          delay: const Duration(milliseconds: 100),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [for (final s in _skills) _SkillTile(label: s.$1, bg: s.$2, fg: s.$3, angle: s.$4)],
          ),
        ),
      ],
    );
  }
}

class _SkillTile extends StatefulWidget {
  const _SkillTile({required this.label, required this.bg, required this.fg, required this.angle});
  final String label;
  final Color bg;
  final Color fg;
  final double angle;

  @override
  State<_SkillTile> createState() => _SkillTileState();
}

class _SkillTileState extends State<_SkillTile> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _active = true),
      onExit: (_) => setState(() => _active = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _active = true),
        onTapUp: (_) => setState(() => _active = false),
        onTapCancel: () => setState(() => _active = false),
        child: AnimatedRotation(
          turns: (_active ? widget.angle * 1.6 : 0) / (2 * 3.14159),
          duration: const Duration(milliseconds: 150),
          child: BrutalistCard(
            color: widget.bg,
            hoverLift: true,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Text(widget.label, style: AppText.headlineMd(color: widget.fg).copyWith(fontWeight: FontWeight.w900)),
          ),
        ),
      ),
    );
  }
}
