import 'package:flutter/material.dart';

/// Recreates the HTML's IntersectionObserver `.reveal` → `.reveal.active`
/// pattern: child fades + slides up once it scrolls into the viewport,
/// firing only once. Self-contained — listens directly to the nearest
/// ancestor [Scrollable], no external packages required.
class RevealOnScroll extends StatefulWidget {
  const RevealOnScroll({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  final Widget child;
  final Duration delay;

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll> {
  bool _triggered = false;
  bool _visible = false;
  ScrollPosition? _position;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newPosition = Scrollable.maybeOf(context)?.position;
    if (newPosition != _position) {
      _position?.removeListener(_checkVisibility);
      _position = newPosition;
      _position?.addListener(_checkVisibility);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  @override
  void dispose() {
    _position?.removeListener(_checkVisibility);
    super.dispose();
  }

  void _checkVisibility() {
    if (_triggered || !mounted) return;
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.attached) return;

    final viewportHeight = MediaQuery.of(context).size.height;
    final position = renderObject.localToGlobal(Offset.zero);
    // Mirrors the JS rootMargin of '-50px' at the bottom of the viewport.
    final inView = position.dy < viewportHeight - 50;

    if (inView) {
      _triggered = true;
      Future.delayed(widget.delay, () {
        if (mounted) setState(() => _visible = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: _visible ? Offset.zero : const Offset(0, 0.06),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
