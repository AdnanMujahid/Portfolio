import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// "Slab" button. Default: 4px border + 4px hard shadow.
/// Hover (desktop/web): lifts -2,-2 and shadow grows to 6px.
/// Press (touch/click): pushes +2,+2 and shadow disappears.
class BrutalistButton extends StatefulWidget {
  const BrutalistButton({
    super.key,
    required this.label,
    this.onTap,
    this.backgroundColor = AppColors.primary,
    this.foregroundColor = AppColors.onPrimary,
    this.icon,
    this.borderWidth = 4,
    this.fullWidth = false,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
  });

  final String label;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData? icon;
  final double borderWidth;
  final bool fullWidth;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;

  @override
  State<BrutalistButton> createState() => _BrutalistButtonState();
}

class _BrutalistButtonState extends State<BrutalistButton> {
  bool _hovering = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    double dx = 0, dy = 0, shadow = 4;
    if (_pressed) {
      dx = widget.borderWidth / 2;
      dy = widget.borderWidth / 2;
      shadow = 0;
    } else if (_hovering) {
      dx = -2;
      dy = -2;
      shadow = 6;
    }

    final style = (widget.textStyle ?? AppText.headlineMd())
        .copyWith(color: widget.foregroundColor, fontWeight: FontWeight.w900);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() {
        _hovering = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          transform: Matrix4.translationValues(dx, dy, 0),
          width: widget.fullWidth ? double.infinity : null,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            border: Border.all(color: AppColors.ink, width: widget.borderWidth),
            boxShadow: shadow == 0
                ? const []
                : [
                    BoxShadow(
                      color: AppColors.ink,
                      offset: Offset(shadow, shadow),
                      blurRadius: 0,
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.label.toUpperCase(), style: style),
              if (widget.icon != null) ...[
                const SizedBox(width: 8),
                Icon(widget.icon, color: widget.foregroundColor, size: 22),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
