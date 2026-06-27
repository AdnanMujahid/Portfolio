import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/brutalist_button.dart';

class HeaderNav extends StatelessWidget implements PreferredSizeWidget {
  const HeaderNav({
    super.key,
    required this.isDesktop,
    required this.onNavTap,
    required this.onHireMe,
  });

  final bool isDesktop;
  final void Function(String sectionId) onNavTap;
  final VoidCallback onHireMe;

  static const _links = ['WORK', 'ABOUT', 'SKILLS', 'CONTACT'];

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    // Mirror the asymmetric gutters from HomeScreen exactly
    final leftPad  = isDesktop ? 64.0 : 20.0;
    final rightPad = isDesktop ? 48.0 : 20.0;
    final logoSize = isDesktop ? 44.0 : 36.0;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.ink, width: 4)),
        boxShadow: [BoxShadow(color: AppColors.ink, offset: Offset(4, 4), blurRadius: 0)],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: leftPad,
            right: rightPad,
            top: 8,
            bottom: 8,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // ── Logo mark ────────────────────────────────────────────────
              Image.asset(
                'assets/images/favicon.png',
                width: logoSize,
                height: logoSize,
                fit: BoxFit.contain,
              ),

              const SizedBox(width: 12),
              // Logo — left-locked, no Expanded so it doesn't shrink
              Text(
                'ADNAN MUJAHID',
                style: (isDesktop ? AppText.headlineMd() : AppText.displayLgMobile())
                    .copyWith(fontWeight: FontWeight.w900, letterSpacing: -0.5),
              ),

              // Nav links pushed to the right
              const Spacer(),

              if (isDesktop)
                Row(
                  children: _links
                      .map((label) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _NavLink(label: label, onTap: () => onNavTap(label)),
                  ))
                      .toList(),
                ),

              SizedBox(width: isDesktop ? 24 : 12),

              BrutalistButton(
                label: 'Hire Me',
                onTap: onHireMe,
                borderWidth: 2,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: AppText.bodySm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: _hovering ? AppColors.primaryContainer : Colors.transparent,
          transform: Matrix4.translationValues(
              _hovering ? -2 : 0, _hovering ? -2 : 0, 0),
          child: Text(
            widget.label,
            style: AppText.bodySm(
              color: _hovering ? AppColors.onPrimaryContainer : AppColors.onSurface,
            ).copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}