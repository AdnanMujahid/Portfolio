import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/app_chip.dart';
import '../widgets/project_card.dart';
import '../widgets/reveal_on_scroll.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key, required this.isDesktop});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final card1 = RevealOnScroll(
      child: ProjectCard(
        imagePath: 'assets/images/project_gavel.jpg',
        imageBackground: AppColors.primaryFixedDim,
        tags: const [
          AppChip(label: 'Flutter', backgroundColor: AppColors.primary),
          AppChip(label: 'Python', backgroundColor: AppColors.secondary),
          AppChip(label: 'Firebase', backgroundColor: AppColors.primaryContainer),
          AppChip(label: 'Lang Chain', backgroundColor: Colors.red),
          AppChip(label: 'Hugging Face', backgroundColor: Colors.deepOrange),
        ],
        title: 'Legal EASE App',
        description:
            'An intelligent conversational agent designed to analyze legal documents and '
            'provide quick references for case laws using RAG (Retrieval-Augmented Generation).',
        buttonLabel: 'View Case Study',
        onTap: () async {
          final url = Uri.parse('https://sites.google.com/view/legaleaseapp/home');
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.inAppBrowserView);
          }
        },
      ),
    );

    final card2 = RevealOnScroll(
      delay: const Duration(milliseconds: 150),
      child: ProjectCard(
        imagePath: 'assets/images/project_heart.jpg',
        imageBackground: AppColors.secondaryFixedDim,
        tags: const [
          AppChip(label: 'Flutter', backgroundColor: AppColors.primary),
          AppChip(label: 'Python', backgroundColor: AppColors.secondary),
          AppChip(label: 'Gemini 2.5', backgroundColor: AppColors.onSurface),
          AppChip(label: 'Lang Chain', backgroundColor: Colors.red),
          AppChip(label: 'Hugging Face', backgroundColor: Colors.deepOrange),
        ],
        title: 'Mental Health Advisor APP',
        description:
            'A privacy-focused mobile app providing emotional support through fine-tuned LLM '
            'interactions, featuring local data encryption.',
        buttonLabel: 'View Case Study',
        onTap: () async {
          final url = Uri.parse('https://sites.google.com/view/mental-health-advisor-app/home');
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.inAppBrowserView);
          }
        },
      ),
    );

    final card3 = RevealOnScroll(
      delay: const Duration(milliseconds: 250),
      child: _WideFirebaseCard(isDesktop: isDesktop),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RevealOnScroll(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('FEATURED\nPROJECTS',
                  style: isDesktop ? AppText.displayLg() : AppText.displayLgMobile()),
              if (isDesktop) ...[
                const SizedBox(width: 16),
                Expanded(child: Container(height: 6, color: AppColors.ink)),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        if (isDesktop)
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: card1),
                  const SizedBox(width: 24),
                  Expanded(child: card2),
                ],
              ),
              const SizedBox(height: 24),
              card3,
            ],
          )
        else
          Column(
            children: [
              card1,
              const SizedBox(height: 24),
              card2,
              const SizedBox(height: 24),
              card3,
            ],
          ),
      ],
    );
  }
}

class _WideFirebaseCard extends StatefulWidget {
  const _WideFirebaseCard({required this.isDesktop});
  final bool isDesktop;

  @override
  State<_WideFirebaseCard> createState() => _WideFirebaseCardState();
}

class _WideFirebaseCardState extends State<_WideFirebaseCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final image = ClipRect(
      child: SizedBox(
        height: widget.isDesktop ? null : 220,
        width: double.infinity,
        child: Container(
          color: AppColors.surfaceContainer,
          child: AnimatedScale(
            scale: _hovering ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 400),
            child: Image.asset('assets/images/project_dashboard.jpg', fit: BoxFit.cover),
          ),
        ),
      ),
    );

    final content = Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Wrap(spacing: 8, runSpacing: 8, children: [
            AppChip(label: 'Flutter', backgroundColor: AppColors.primary),
            AppChip(label: 'Firebase', backgroundColor: AppColors.secondary),
          ]),
          const SizedBox(height: 12),
          Text('LOAD SOUQ', style: AppText.displayXl()),
          const SizedBox(height: 8),
          Text(
            'Load Souq is a freight and logistics marketplace for truck drivers and'
                ' shippers alike where you can easily find available loads,'
                'book your loads, and even get shipments done, all at once.',
            style: AppText.bodyLg(),
          ),
          const SizedBox(height: 24),
          Builder(builder: (context) {
            return _FullOverviewButton(hovering: _hovering);
          }),
        ],
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.translationValues(_hovering ? -4 : 0, _hovering ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.ink, width: 4),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink,
              offset: Offset(_hovering ? 12 : 8, _hovering ? 12 : 8),
              blurRadius: 0,
            ),
          ],
        ),
        child: widget.isDesktop
            ? IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(right: BorderSide(color: AppColors.ink, width: 4)),
                        ),
                        child: image,
                      ),
                    ),
                    Expanded(child: content),
                  ],
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColors.ink, width: 4)),
                    ),
                    child: image,
                  ),
                  content,
                ],
              ),
      ),
    );
  }
}

class _FullOverviewButton extends StatefulWidget {
  const _FullOverviewButton({required this.hovering});
  final bool hovering;

  @override
  State<_FullOverviewButton> createState() => _FullOverviewButtonState();
}

class _FullOverviewButtonState extends State<_FullOverviewButton> {
  bool _tapping = false;

  Future<void> _openOverview() async {
    final url = Uri.parse(
        'https://sites.google.com/view/load-souq-private-policy/terms-of-services');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.inAppBrowserView);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openOverview,
      onTapDown: (_) => setState(() => _tapping = true),
      onTapUp: (_) => setState(() => _tapping = false),
      onTapCancel: () => setState(() => _tapping = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.primary,
          border: Border.all(color: AppColors.ink, width: 4),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink,
              offset: Offset(
                _tapping ? 2 : (widget.hovering ? 6 : 4),
                _tapping ? 2 : (widget.hovering ? 6 : 4),
              ),
            ),
          ],
        ),
        child: Text(
          'FULL OVERVIEW',
          style: AppText.headlineMd(color: AppColors.onPrimary)
              .copyWith(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}
