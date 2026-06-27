import 'package:adnan_mujahid/sections/expiernce_section.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme/app_colors.dart';
import 'theme/app_text.dart';
import 'widgets/animated_grid_background.dart';
import 'widgets/reveal_on_scroll.dart';
import 'sections/header_nav.dart';
import 'sections/hero_section.dart';
import 'sections/about_section.dart';
import 'sections/skills_section.dart';
import 'sections/projects_section.dart';
import 'sections/contact_section.dart';
import 'sections/footer_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  final _aboutKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _workKey = GlobalKey();
  final _contactKey = GlobalKey();
  final _experinceKey = GlobalKey();

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _onNavTap(String label) {
    switch (label) {
      case 'WORK':   _scrollTo(_workKey);    break;
      case 'ABOUT':  _scrollTo(_aboutKey);   break;
      case 'SKILLS': _scrollTo(_skillsKey);  break;
      case 'CONTACT':_scrollTo(_contactKey); break;
    }
  }

  Future<void> _sendEmail() async {
    final uri = Uri.parse('mailto:adnan@example.com');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= AppBreakpoints.desktop;
    // Left-aligned gutter: fixed 32px desktop, 20px mobile — NOT symmetric centering
    final leftPad  = isDesktop ? 24.0 : 10.0;
    final rightPad = isDesktop ? 28.0 : 10.0;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: HeaderNav(
        isDesktop: isDesktop,
        onNavTap: _onNavTap,
        onHireMe: () => _scrollTo(_contactKey),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: AnimatedGridBackground()),
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // full-width everything
              children: [

                // ── HERO — full bleed, own its padding ──────────────────────
                Padding(
                  padding: EdgeInsets.only(left: leftPad, right: rightPad),
                  child: HeroSection(
                    isDesktop: isDesktop,
                    onViewProjects: () => _scrollTo(_workKey),
                    onContactMe:   () => _scrollTo(_contactKey),
                  ),
                ),

                // ── ABOUT ───────────────────────────────────────────────────
                _SectionDivider(sectionKey: _aboutKey, label: 'ABOUT'),
                Padding(
                  padding: EdgeInsets.only(
                    left: leftPad, right: rightPad,
                    top: 40, bottom: 56,
                  ),
                  child: AboutSection(isDesktop: isDesktop),
                ),

                // ── ABOUT ───────────────────────────────────────────────────
                _SectionDivider(sectionKey: _experinceKey, label: 'EXPERIENCE'),
                Padding(
                  padding: EdgeInsets.only(
                    left: leftPad, right: rightPad,
                    top: 40, bottom: 56,
                  ),
                  child: ExperienceSection(isDesktop: isDesktop,),
                ),
                //ExperienceSection e
                

                // ── SKILLS ──────────────────────────────────────────────────
                _SectionDivider(sectionKey: _skillsKey, label: 'SKILLS'),
                Padding(
                  padding: EdgeInsets.only(
                    left: leftPad, right: rightPad,
                    top: 40, bottom: 56,
                  ),
                  child: SkillsSection(isDesktop: isDesktop),
                ),

                // ── WORK ────────────────────────────────────────────────────
                _SectionDivider(sectionKey: _workKey, label: 'WORK'),
                Padding(
                  padding: EdgeInsets.only(
                    left: leftPad, right: rightPad,
                    top: 40, bottom: 56,
                  ),
                  child: ProjectsSection(isDesktop: isDesktop),
                ),

                // ── CONTACT ─────────────────────────────────────────────────
                _SectionDivider(sectionKey: _contactKey, label: 'CONTACT'),
                Padding(
                  padding: EdgeInsets.only(
                    left: leftPad, right: rightPad,
                    top: 40, bottom: 56,
                  ),
                  child: RevealOnScroll(
                    child: ContactSection(
                      isDesktop: isDesktop,
                      onSendEmail: _sendEmail,
                    ),
                  ),
                ),

                // ── FOOTER — full bleed ──────────────────────────────────────
                FooterSection(isDesktop: isDesktop),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Brutalist section divider: full-width 8px black rule with a
/// left-anchored section label — NOT centered.
class _SectionDivider extends StatelessWidget {
  final GlobalKey sectionKey;
  final String label;

  const _SectionDivider({
    required this.sectionKey,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= AppBreakpoints.desktop;
    final leftPad = isDesktop ? 64.0 : 20.0;

    return SizedBox(
      key: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Full-bleed top rule
          Container(height: 8, color: AppColors.ink),
          // Section label — left-locked, monospace, uppercase
        ],
      ),
    );
  }
}