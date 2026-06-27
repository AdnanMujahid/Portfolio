import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/brutalist_button.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key, required this.isDesktop, required this.onSendEmail});

  final bool isDesktop;
  final VoidCallback onSendEmail;

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _sending = false;

  static const _accessKey = '169e93eb-02cd-4984-b262-4300d109157f';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendEmail() async {
    final email   = _emailController.text.trim();
    final message = _messageController.text.trim();

    if (email.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in your email and message.')),
      );
      return;
    }

    setState(() => _sending = true);

    try {
      final response = await http.post(
        Uri.parse('https://api.web3forms.com/submit'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'access_key': _accessKey,
          'name':       _nameController.text.trim(),
          'email':      email,
          'message':    message,
          'subject':    'New Portfolio Message from ${_nameController.text.trim()}',
        }),
      );

      if (!mounted) return;

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message sent — thanks for reaching out!')),
        );
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${data['message'] ?? 'Try again.'}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Network error. Check your connection.')),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final left = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            style: (widget.isDesktop ? AppText.displayLg(color: AppColors.surface) : AppText.displayLgMobile(color: AppColors.surface))
                .copyWith(height: 1.2),
            children: [
              const TextSpan(text: 'READY TO BUILD SOMETHING\n'),
              TextSpan(text: 'EXTRAORDINARY?', style: TextStyle(color: AppColors.secondaryFixedDim)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Let's discuss your next Flutter app or AI implementation. Engineering excellence "
              'is just one message away.',
          style: AppText.bodyLg(color: AppColors.surfaceDim),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: widget.onSendEmail,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.mail_outline, color: AppColors.surface, size: 28),
              const SizedBox(width: 12),
              Text('adnanmujahid360@gmail.com',
                  style: AppText.headlineMd(color: AppColors.surface).copyWith(fontWeight: FontWeight.w800)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _SocialIcon(icon: Icons.business_center_outlined, hoverColor: AppColors.primary,  url: 'https://www.linkedin.com/in/adnanmujahid/'),
            const SizedBox(width: 12),
            _SocialIcon(icon: Icons.code,                     hoverColor: AppColors.tertiary, url: 'https://github.com/AdnanMujahid/'),
            const SizedBox(width: 12),
            // ✅ Pass just the email address — _launchUrl handles the mailto: URI
          ],
        ),
      ],
    );

    final form = Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border.fromBorderSide(BorderSide(color: AppColors.secondary, width: 4)),
        boxShadow: [BoxShadow(color: AppColors.secondaryContainer, offset: Offset(8, 8), blurRadius: 0)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _FormField(controller: _nameController, placeholder: 'YOUR NAME'),
          const SizedBox(height: 8),
          _FormField(controller: _emailController, placeholder: 'EMAIL ADDRESS'),
          const SizedBox(height: 8),
          _FormField(
              controller: _messageController,
              placeholder: 'TELL ME ABOUT YOUR PROJECT',
              maxLines: 4),
          const SizedBox(height: 8),
          BrutalistButton(
            label: _sending ? 'Sending...' : 'Send Transmission',
            fullWidth: true,
            backgroundColor: AppColors.secondary,
            foregroundColor: AppColors.onSecondary,
            borderWidth: 4,
            onTap: _sending ? null : _sendEmail,
          ),
        ],
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.onSurface,
        border: Border.all(color: AppColors.ink, width: 4),
        boxShadow: const [BoxShadow(color: AppColors.ink, offset: Offset(8, 8), blurRadius: 0)],
      ),
      padding: EdgeInsets.all(widget.isDesktop ? 48 : 24),
      child: widget.isDesktop
          ? Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: left),
          const SizedBox(width: 24),
          Expanded(child: form),
        ],
      )
          : Column(
        children: [
          left,
          const SizedBox(height: 32),
          form,
        ],
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({required this.controller, required this.placeholder, this.maxLines = 1});
  final TextEditingController controller;
  final String placeholder;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: AppText.bodySm(color: AppColors.onSurface),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: placeholder,
        hintStyle: AppText.bodySm(color: AppColors.onSurface.withOpacity(0.5)),
        contentPadding: const EdgeInsets.all(16),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.ink, width: 4),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.ink, width: 4),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.primary, width: 4),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  const _SocialIcon({
    required this.icon,
    required this.hoverColor,
    this.url,
  });
  final IconData icon;
  final Color hoverColor;
  final String? url;

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovering = false;

  Future<void> _launchUrl() async {
    if (widget.url == null) return;

    // ── Detect email address and build a proper mailto: URI ────────────────
    final isEmail = widget.url!.contains('@') && !widget.url!.startsWith('http');

    if (isEmail) {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: widget.url!,           // ✅ actual variable, not a string literal
        query: 'subject=${Uri.encodeComponent('Portfolio Enquiry')}',
      );

      try {
        // ✅ Skip canLaunchUrl — it always returns false for mailto: on Flutter Web
        await launchUrl(emailUri);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error launching email: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      // ── Normal https:// links ───────────────────────────────────────────
      final uri = Uri.parse(widget.url!);
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error opening link: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.url != null ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: _launchUrl,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _hovering ? widget.hoverColor : Colors.transparent,
            border: Border.all(color: AppColors.surface, width: 2),
          ),
          child: Icon(widget.icon, color: AppColors.surface, size: 22),
        ),
      ),
    );
  }
}