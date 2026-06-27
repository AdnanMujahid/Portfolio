import 'package:flutter/material.dart';

/// Color tokens lifted directly from DESIGN.md / the Neo-Structure system.
/// Structural lines (borders/hard-shadows) intentionally use pure black,
/// per the "Surface & Border" rule: no grays for structural lines.
class AppColors {
  AppColors._();

  // Surfaces
  static const surface = Color(0xFFF8F9FA);
  static const surfaceDim = Color(0xFFD9DADB);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF3F4F5);
  static const surfaceContainer = Color(0xFFEDEEEF);
  static const surfaceContainerHigh = Color(0xFFE7E8E9);
  static const surfaceContainerHighest = Color(0xFFE1E3E4);

  // Text / ink
  static const onSurface = Color(0xFF191C1D);
  static const onSurfaceVariant = Color(0xFF424754);
  static const inverseSurface = Color(0xFF2E3132);
  static const inverseOnSurface = Color(0xFFF0F1F2);
  static const outline = Color(0xFF727785);

  // Primary — Electric Blue
  static const primary = Color(0xFF0058BE);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFF2170E4);
  static const onPrimaryContainer = Color(0xFFFEFCFF);
  static const primaryFixedDim = Color(0xFFADC6FF);

  // Secondary — Hot Pink
  static const secondary = Color(0xFFB90538);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFDC2C4F);
  static const secondaryFixedDim = Color(0xFFFFB2B7);

  // Tertiary — Neon Green
  static const tertiary = Color(0xFF006947);
  static const onTertiary = Color(0xFFFFFFFF);
  static const tertiaryContainer = Color(0xFF00855B);

  // Structural — every border / hard-shadow in the system is pure black
  static const ink = Color(0xFF000000);
}
