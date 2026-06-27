import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key, required this.isDesktop});

  final bool isDesktop;

  static const _links = [
    _FooterLink(label: 'GITHUB',   url: 'https://github.com/AdnanMujahid/', hoverColor: AppColors.tertiary),
    _FooterLink(label: 'LINKEDIN', url: 'https://www.linkedin.com/in/adnanmujahid/',     hoverColor: AppColors.primary),
  ];

  @override
  Widget build(BuildContext context) {
    final logo = Text(
      'ADNAN.',
      style: AppText.displayLgMobile(color: AppColors.surface)
          .copyWith(fontWeight: FontWeight.w900),
    );
    final copyright = Text(
      '© 2024 ADNAN MUJAHID. ENGINEERED FOR EXCELLENCE.',
      style: AppText.bodySm(color: AppColors.surfaceDim),
    );
    final links = Wrap(
      spacing: 16,
      runSpacing: 8,
      children: _links.map((l) => _FooterLinkWidget(link: l)).toList(),
    );

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.onSurface,
        border: Border(top: BorderSide(color: AppColors.secondary, width: 8)),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 32 : 20, vertical: 24),
      child: isDesktop
          ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [logo, copyright, links],
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          logo,
          const SizedBox(height: 12),
          copyright,
          const SizedBox(height: 12),
          links,
        ],
      ),
    );
  }
}

// ── Data model ──────────────────────────────────────────────────────────────

class _FooterLink {
  const _FooterLink({
    required this.label,
    required this.url,
    required this.hoverColor,
  });
  final String label;
  final String url;
  final Color hoverColor;
}

// ── Interactive link widget ──────────────────────────────────────────────────

class _FooterLinkWidget extends StatefulWidget {
  const _FooterLinkWidget({required this.link});
  final _FooterLink link;

  @override
  State<_FooterLinkWidget> createState() => _FooterLinkWidgetState();
}

class _FooterLinkWidgetState extends State<_FooterLinkWidget> {
  bool _hovering = false;

  Future<void> _launch() async {
    final url = widget.link.url;

    // Email address — build a mailto: URI
    final isEmail = url.contains('@') && !url.startsWith('http');
    final Uri uri = isEmail
        ? Uri(
      scheme: 'mailto',
      path: url,
      query: 'subject=${Uri.encodeComponent('Portfolio Enquiry')}',
    )
        : Uri.parse(url);

    try {
      await launchUrl(uri,
          mode: isEmail ? LaunchMode.platformDefault : LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open link: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: _launch,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            // Fills with hoverColor on hover, transparent otherwise
            color: _hovering ? widget.link.hoverColor : Colors.transparent,
          ),
          child: Text(
            widget.link.label,
            style: AppText.bodySm(color: AppColors.surface)
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}