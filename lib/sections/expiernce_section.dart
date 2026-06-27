// lib/sections/experience_section.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/reveal_on_scroll.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data
// ─────────────────────────────────────────────────────────────────────────────

class _Bullet {
  const _Bullet(this.text);
  final String text;
}

class _ExperienceData {
  const _ExperienceData({
    required this.title,
    required this.company,
    required this.date,
    required this.type,
    required this.accentColor,
    required this.bullets,
  });

  final String title;
  final String company;
  final String date;
  final String type;
  final Color accentColor;
  final List<_Bullet> bullets;
}

// ─────────────────────────────────────────────────────────────────────────────
// Section
// ─────────────────────────────────────────────────────────────────────────────

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key, required this.isDesktop});
  final bool isDesktop;

  // Cycled through bullet markers — keeps every card visually varied,
  // matching the multi-coloured dots in the reference design.
  static const _dotColors = [
    AppColors.primary,
    AppColors.secondary,
    AppColors.tertiary,
  ];

  static const _experiences = [
    _ExperienceData(
      title: 'Flutter Developer @ Freelancing',
      company: 'Self-Employed · Islamabad, Pakistan',
      date: 'May, 2026 — Present',
      type: 'FREELANCE',
      accentColor: AppColors.primary,
      bullets: [
        _Bullet(
          'Developed and launched LoadSouq, a logistics and freight '
              'marketplace, built entirely from scratch with Flutter and Dart.',
        ),
        _Bullet(
          'Integrated Google Maps API and real-time tracking features on '
              'top of a Firebase Authentication and Cloud Firestore backend.',
        ),
        _Bullet(
          'Optimised app performance by 40% through efficient state '
              'management and a streamlined deployment pipeline to Google Play.',
        ),
      ],
    ),
    _ExperienceData(
      title: 'Associate Flutter Developer @ AHAD SOFTECH',
      company: 'AHAD SOFTECH, LLP · Islamabad, Pakistan',
      date: 'September, 2025 — April, 2026',
      type: 'FULL-TIME',
      accentColor: AppColors.tertiary,
      bullets: [
        _Bullet(
          'Developed scalable mobile solutions for international clients, '
              'shipping 5 Android apps and improving delivery timelines by 15%.',
        ),
        _Bullet(
          'Managed app releases to Google Play and Apple App Store, '
              'integrating the Gemini API to deliver AI-driven features.',
        ),
        _Bullet(
          'Collaborated with UI/UX designers to implement pixel-perfect '
              'layouts, with monetisation via AdMob and In-App Purchases.',
        ),
        _Bullet(
          'Maintained scalable cloud architectures using Firebase Auth, '
              'Firestore, Cloud Messaging, Analytics, and Crashlytics.',
        ),
      ],
    ),
    _ExperienceData(
      title: 'Flutter Developer Intern @ MacroSoar',
      company: 'MacroSoar · Islamabad, Pakistan',
      date: 'August, 2025 — September, 2025',
      type: 'INTERNSHIP',
      accentColor: AppColors.secondary,
      bullets: [
        _Bullet(
          'Learned fundamentals of Dart and Flutter widget tree structure '
              'while contributing to a cross-platform music streaming app.',
        ),
        _Bullet(
          'Assisted in debugging and feature enhancements, designing local '
              'storage for offline audio caching and dynamic lyrics editing.',
        ),
        _Bullet(
          'Implemented Firebase Auth and Firestore for multiple demo '
              'projects alongside the core engineering team.',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeading(isDesktop: isDesktop),
        const SizedBox(height: 40),
        isDesktop
            ? _DesktopTimeline(experiences: _experiences)
            : _MobileTimeline(experiences: _experiences),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Heading — "02 — EXPERIENCE"
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.isDesktop});
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final muted = AppColors.onSurface.withValues(alpha: 0.32);
    final numStyle = GoogleFonts.montserrat(
      fontSize: isDesktop ? 32 : 22,
      fontWeight: FontWeight.w700,
      color: muted,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'EXPERIENCE',
          style: isDesktop ? AppText.displayLg() : AppText.displayLgMobile(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Desktop — zigzag timeline with a dashed centre spine
// ─────────────────────────────────────────────────────────────────────────────

class _DesktopTimeline extends StatelessWidget {
  const _DesktopTimeline({required this.experiences});
  final List<_ExperienceData> experiences;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _DashedLinePainter(
              color: AppColors.onSurface.withValues(alpha: 0.18),
            ),
          ),
        ),
        Column(
          children: List.generate(experiences.length, (i) {
            final data = experiences[i];
            final cardOnRight = i.isEven;
            return Padding(
              padding: EdgeInsets.only(
                bottom: i < experiences.length - 1 ? 36 : 0,
              ),
              child: RevealOnScroll(
                delay: Duration(milliseconds: i * 120),
                child: _TimelineRow(data: data, cardOnRight: cardOnRight),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  _DashedLinePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;
    const dashHeight = 6.0;
    const dashSpace = 6.0;
    final x = size.width / 2;
    double y = 0;
    while (y < size.height) {
      canvas.drawLine(Offset(x, y), Offset(x, y + dashHeight), paint);
      y += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.data, required this.cardOnRight});
  final _ExperienceData data;
  final bool cardOnRight;

  @override
  Widget build(BuildContext context) {
    final card = _ExperienceCard(data: data);
    final label = _DateLabel(
      date: data.date,
      type: data.type,
      color: data.accentColor,
      alignRight: !cardOnRight,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: cardOnRight ? label : card),
        SizedBox(
          width: 60,
          child: Center(
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: data.accentColor,
                border: Border.all(color: AppColors.surface, width: 3),
              ),
            ),
          ),
        ),
        Expanded(child: cardOnRight ? card : label),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Date / type label
// ─────────────────────────────────────────────────────────────────────────────

class _DateLabel extends StatelessWidget {
  const _DateLabel({
    required this.date,
    required this.type,
    required this.color,
    required this.alignRight,
  });

  final String date;
  final String type;
  final Color color;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          date,
          textAlign: alignRight ? TextAlign.right : TextAlign.left,
          style: GoogleFonts.montserrat(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          type,
          style: AppText.labelBold(
            color: AppColors.onSurface.withValues(alpha: 0.4),
          ).copyWith(letterSpacing: 1.6, fontSize: 11),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Card — with hover/click animations and brutalist border styling
// ─────────────────────────────────────────────────────────────────────────────

class _ExperienceCard extends StatefulWidget {
  const _ExperienceCard({required this.data});
  final _ExperienceData data;

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.data.title,
          style: GoogleFonts.montserrat(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.25,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.data.company,
          style: AppText.bodySm(
            color: AppColors.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 14),
        ...List.generate(widget.data.bullets.length, (i) {
          final bullet = widget.data.bullets[i];
          final dotColor = ExperienceSection
              ._dotColors[i % ExperienceSection._dotColors.length];
          return Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dotColor,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    bullet.text,
                    style: AppText.bodyLg(),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _hovering = true),
        onTapUp: (_) => setState(() => _hovering = false),
        onTapCancel: () => setState(() => _hovering = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.translationValues(
            _hovering ? -4 : 0,
            _hovering ? -4 : 0,
            0,
          ),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(0),
            border: Border.all(color: AppColors.ink, width: 4),
            boxShadow: [
              BoxShadow(
                color: AppColors.ink,
                offset: Offset(_hovering ? 12 : 8, _hovering ? 12 : 8),
                blurRadius: 0,
              ),
            ],
          ),
          child: content,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mobile — simple stacked list (no zigzag; not enough width for it)
// ─────────────────────────────────────────────────────────────────────────────

class _MobileTimeline extends StatelessWidget {
  const _MobileTimeline({required this.experiences});
  final List<_ExperienceData> experiences;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(experiences.length, (i) {
        final data = experiences[i];
        return Padding(
          padding: EdgeInsets.only(
            bottom: i < experiences.length - 1 ? 28 : 0,
          ),
          child: RevealOnScroll(
            delay: Duration(milliseconds: i * 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DateLabel(
                  date: data.date,
                  type: data.type,
                  color: data.accentColor,
                  alignRight: false,
                ),
                const SizedBox(height: 10),
                _ExperienceCard(data: data),
              ],
            ),
          ),
        );
      }),
    );
  }
}