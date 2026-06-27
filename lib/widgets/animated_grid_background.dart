import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A lightweight stand-in for the page's WebGL grid/bloom shader: a faint
/// 5%-opacity black grid with two soft accent-color blooms that drift
/// slowly across the canvas. Sits behind all content at ~30% opacity,
/// matching the HTML's `opacity-30` wrapper.
class AnimatedGridBackground extends StatefulWidget {
  const AnimatedGridBackground({super.key});

  @override
  State<AnimatedGridBackground> createState() => _AnimatedGridBackgroundState();
}

class _AnimatedGridBackgroundState extends State<AnimatedGridBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 20))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: 0.3,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              size: Size.infinite,
              painter: _GridShaderPainter(t: _controller.value * 2 * math.pi),
            );
          },
        ),
      ),
    );
  }
}

class _GridShaderPainter extends CustomPainter {
  _GridShaderPainter({required this.t});
  final double t;

  static const blue = AppColors.primaryContainer;
  static const pink = AppColors.secondaryContainer;
  static const green = AppColors.tertiaryContainer;

  @override
  void paint(Canvas canvas, Size size) {
    // Base surface fill.
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.surface);

    // Faint grid.
    final gridPaint = Paint()
      ..color = AppColors.ink.withOpacity(0.05)
      ..strokeWidth = 1;
    const cell = 40.0;
    for (double x = 0; x < size.width; x += cell) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += cell) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Two drifting blooms (radial gradients), echoing the shader's moving
    // mouse-bloom + wave-driven color mixing.
    _bloom(
      canvas,
      size,
      center: Offset(
        size.width * (0.5 + 0.3 * math.sin(t)),
        size.height * (0.4 + 0.25 * math.cos(t * 0.8)),
      ),
      color: blue,
      radius: size.shortestSide * 0.35,
    );
    _bloom(
      canvas,
      size,
      center: Offset(
        size.width * (0.5 + 0.32 * math.cos(t * 0.6 + 1.5)),
        size.height * (0.6 + 0.22 * math.sin(t * 0.9 + 1.5)),
      ),
      color: pink,
      radius: size.shortestSide * 0.3,
    );
    _bloom(
      canvas,
      size,
      center: Offset(
        size.width * (0.5 + 0.25 * math.sin(t * 0.5 + 3)),
        size.height * (0.5 + 0.3 * math.cos(t * 0.4 + 3)),
      ),
      color: green,
      radius: size.shortestSide * 0.22,
    );
  }

  void _bloom(Canvas canvas, Size size,
      {required Offset center, required Color color, required double radius}) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color.withOpacity(0.35), color.withOpacity(0.0)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _GridShaderPainter oldDelegate) => oldDelegate.t != t;
}
