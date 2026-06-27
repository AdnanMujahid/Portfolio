import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'app_chip.dart';
import 'brutalist_button.dart' show BrutalistButton;

/// A single project card: image (separated by a 4px black rule), tag chips,
/// title, description, and a full-width "View Case Study" slab button.
class ProjectCard extends StatefulWidget {
  const ProjectCard({
    super.key,
    required this.imagePath,
    required this.imageBackground,
    required this.tags,
    required this.title,
    required this.description,
    required this.buttonLabel,
    this.onTap,
    this.buttonColor = AppColors.ink,
    this.buttonTextColor = Colors.white,
  });

  final String imagePath;
  final Color imageBackground;
  final List<AppChip> tags;
  final String title;
  final String description;
  final String buttonLabel;
  final VoidCallback? onTap;
  final Color buttonColor;
  final Color buttonTextColor;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRect(
              child: Container(
                height: 220,
                width: double.infinity,
                color: widget.imageBackground,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AnimatedScale(
                      scale: _hovering ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 400),
                      child: Image.asset(widget.imagePath, fit: BoxFit.cover),
                    ),
                    AnimatedOpacity(
                      opacity: _hovering ? 0.2 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(color: AppColors.ink),
                    ),
                  ],
                ),
              ),
            ),
            Container(height: 4, color: AppColors.ink),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(spacing: 8, runSpacing: 8, children: widget.tags),
                  const SizedBox(height: 12),
                  Text(widget.title, style: AppText.displayLgMobile()),
                  const SizedBox(height: 8),
                  Text(widget.description, style: AppText.bodySm()),
                  const SizedBox(height: 24),
                  BrutalistButton(
                    label: widget.buttonLabel,
                    onTap: widget.onTap,
                    fullWidth: true,
                    backgroundColor: widget.buttonColor,
                    foregroundColor: widget.buttonTextColor,
                    textStyle: AppText.bodyLg(),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
