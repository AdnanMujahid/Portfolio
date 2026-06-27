import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// Small sharp-rectangle tag used to label languages/tools on project cards.
/// 2px border, no shadow, bold mono text — per the Chips/Tags spec.
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.backgroundColor = AppColors.primary,
    this.foregroundColor = AppColors.onPrimary,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: AppColors.ink, width: 2),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppText.labelBold(color: foregroundColor),
      ),
    );
  }
}
