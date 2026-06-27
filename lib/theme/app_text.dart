import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// "Marketing vs. Machine" type system:
/// Montserrat (heavy) for display/headline graphics, JetBrains Mono for
/// body copy, UI labels, and metadata.
class AppText {
  AppText._();

  static TextStyle get _montserrat => GoogleFonts.montserrat();
  static TextStyle get _mono => GoogleFonts.jetBrainsMono();

  /// 80px / weight 900 / -0.04em — hero, desktop only.
  static TextStyle displayXl({Color color = AppColors.onSurface}) =>
      GoogleFonts.montserrat(
        fontWeight: FontWeight.w900, // Black
        fontSize: 80,
        height: 1.1,
        letterSpacing: -0.04 * 80,
        color: color,
      );

  /// 60px mobile hero fallback (matches the HTML's text-[60px] on small screens).
  static TextStyle displayHero({Color color = AppColors.onSurface}) =>
      GoogleFonts.montserrat(
        fontSize: 60,
        fontWeight: FontWeight.w900,
        height: 1.1,
        letterSpacing: -0.04 * 60,
        color: color,
      );

  /// 48px / weight 800 / -0.02em — desktop section headings.
  static TextStyle displayLg({Color color = AppColors.onSurface}) =>
      GoogleFonts.montserrat(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        height: 1.2,
        letterSpacing: -0.02 * 48,
        color: color,
      );

  /// 32px / weight 800 — mobile section headings.
  static TextStyle displayLgMobile({Color color = AppColors.onSurface}) =>
      GoogleFonts.montserrat(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        height: 1.2,
        color: color,
      );

  /// 24px / weight 700 — headline / button-scale text.
  static TextStyle headlineMd({Color color = AppColors.onSurface}) =>
      GoogleFonts.montserrat(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: color,
      );

  /// 18px JetBrains Mono — primary body copy.
  static TextStyle bodyLg({Color color = AppColors.onSurfaceVariant}) =>
      GoogleFonts.jetBrainsMono(fontSize: 18, fontWeight: FontWeight.w400, height: 1.6, color: color);

  /// 14px JetBrains Mono — secondary / dense copy.
  static TextStyle bodySm({Color color = AppColors.onSurfaceVariant}) =>
      GoogleFonts.jetBrainsMono(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5, color: color);

  /// 12px JetBrains Mono Bold, uppercase — chips, eyebrow labels, metadata.
  static TextStyle labelBold({Color color = AppColors.onSurface}) =>
      GoogleFonts.jetBrainsMono(fontSize: 12, fontWeight: FontWeight.w700, height: 1.0, color: color);
}

/// 8px baseline spacing scale.
class AppSpacing {
  AppSpacing._();
  static const base = 8.0;
  static const gutter = 24.0;
  static const margin = 32.0;
  static const stackSm = 12.0;
  static const stackMd = 24.0;
  static const stackLg = 48.0;
}

/// Shared breakpoint: matches Tailwind's `md:` cutoff used throughout the HTML.
class AppBreakpoints {
  AppBreakpoints._();
  static const desktop = 768.0;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktop;
}
