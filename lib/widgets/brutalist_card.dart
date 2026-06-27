import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// The base "component-as-object" container: a thick black border plus a
/// solid, non-blurred hard shadow cast to the bottom-right. On desktop/web
/// (mouse present) it lifts on hover, matching `.brutalist-card:hover`.
class BrutalistCard extends StatefulWidget {
  const BrutalistCard({
    super.key,
    required this.child,
    this.color = AppColors.surfaceContainerLowest,
    this.borderWidth = 4,
    this.shadowOffset = 8,
    this.hoverLift = true,
    this.padding,
  });

  final Widget child;
  final Color color;
  final double borderWidth;
  final double shadowOffset;
  final bool hoverLift;
  final EdgeInsetsGeometry? padding;

  @override
  State<BrutalistCard> createState() => _BrutalistCardState();
}

class _BrutalistCardState extends State<BrutalistCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final lift = widget.hoverLift && _hovering;
    final offset = lift ? widget.shadowOffset * 1.5 : widget.shadowOffset;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(
          lift ? -widget.borderWidth : 0,
          lift ? -widget.borderWidth : 0,
          0,
        ),
        decoration: BoxDecoration(
          color: widget.color,
          border: Border.all(color: AppColors.ink, width: widget.borderWidth),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink,
              offset: Offset(offset, offset),
              blurRadius: 0,
              spreadRadius: 0,
            ),
          ],
        ),
        padding: widget.padding,
        clipBehavior: Clip.none,
        child: widget.child,
      ),
    );
  }
}
