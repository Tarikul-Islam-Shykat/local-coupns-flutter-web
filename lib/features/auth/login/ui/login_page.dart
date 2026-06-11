import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../const/app_colors.dart';
import '../../../../global/app_btn.dart';
import '../../../../global/custom_snackbar.dart';
import '../../../../global/custom_text.dart';
import '../../../../global/text_form_field.dart';
import '../controller/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _LoginBackground()),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final isDesktop = width >= 1024;
                final isTablet = width >= 720 && width < 1024;
                final horizontalPadding = isDesktop
                    ? 32.0
                    : isTablet
                    ? 24.0
                    : 16.0;
                final contentWidth = isDesktop ? 1180.0 : 560.0;

                return Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: isDesktop ? 32 : 20,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: contentWidth),
                      child: isDesktop
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Expanded(flex: 5, child: _HeroPanel()),
                                const SizedBox(width: 28),
                                Expanded(
                                  flex: 5,
                                  child: _FormPanel(controller: controller),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const _HeroPanel(compact: true),
                                const SizedBox(height: 24),
                                _FormPanel(controller: controller),
                              ],
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 20 : 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.white.withValues(alpha: 0.88),
        border: Border.all(color: const Color(0xFFE4E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: compact
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 72 : 88,
            height: compact ? 72 : 88,
            decoration: BoxDecoration(
              color: AppColors.buttonColors,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.buttonColors.withValues(alpha: 0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.local_offer_rounded,
              color: Colors.white,
              size: 42,
            ),
          ),
          SizedBox(height: compact ? 18 : 24),
          headingText(
            text: 'Log in your Account',
            fontWeight: FontWeight.w700,
            color: AppColors.blackColor,
            textAlign: compact ? TextAlign.center : TextAlign.start,
            overflow: TextOverflow.visible,
            maxLines: 2,
          ),
          const SizedBox(height: 10),
          smallText(
            text: 'Welcome back! Please enter your details.',
            color: AppColors.hintTextColor,
            textAlign: compact ? TextAlign.center : TextAlign.start,
            overflow: TextOverflow.visible,
            maxLines: 2,
          ),
          SizedBox(height: compact ? 18 : 26),
          _BulletRow(
            compact: compact,
            icon: Icons.check_circle_outline_rounded,
            text: 'Fast, clean login experience',
          ),
          SizedBox(height: compact ? 10 : 12),
          _BulletRow(
            compact: compact,
            icon: Icons.devices_outlined,
            text: 'Responsive on phone, tablet, and desktop',
          ),
          SizedBox(height: compact ? 10 : 12),
          _BulletRow(
            compact: compact,
            icon: Icons.security_outlined,
            text: 'Ready for your existing API endpoints',
          ),
        ],
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({
    required this.compact,
    required this.icon,
    required this.text,
  });

  final bool compact;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: compact
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.buttonColors),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            text,
            textAlign: compact ? TextAlign.center : TextAlign.start,
            style: const TextStyle(
              fontSize: 15,
              height: 1.45,
              color: Color(0xFF334E68),
            ),
          ),
        ),
      ],
    );
  }
}

class _FormPanel extends StatelessWidget {
  const _FormPanel({required this.controller});

  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.white.withValues(alpha: 0.9),
        border: Border.all(color: const Color(0xFFE4E7EB)),
      ),
      child: Form(
        key: controller.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: normalText(
                text: 'Email',
                fontWeight: FontWeight.w500,
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 8),
            GlobalTextField(
              controller: controller.emailController,
              hintText: 'admin@gmail.com',
              keyboardType: TextInputType.emailAddress,
              validator: controller.validateEmail,
              fillColor: const Color(0xFFEAF1FF),
              borderRadius: 12,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: normalText(
                text: 'Password',
                fontWeight: FontWeight.w500,
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 8),
            GlobalTextField(
              controller: controller.passwordController,
              hintText: 'Enter password',
              isHidden: true,
              validator: controller.validatePassword,
              fillColor: const Color(0xFFEAF1FF),
              borderRadius: 12,
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  showSnackBar(
                    false,
                    'Forgot password flow is not connected yet.',
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.secondaryColor.withValues(
                    alpha: 0.75,
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: const Text('Forgot your password?'),
              ),
            ),
            const SizedBox(height: 14),
            Obx(
              () => GlobalAppButton(
                text: 'Log In',
                onTap: controller.submitLogin,
                isLoading: controller.isLoading.value,
                height: 52,
                borderRadius: 999,
                backgroundColor: AppColors.buttonColors,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginBackground extends StatelessWidget {
  const _LoginBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GridPainter(lineColor: const Color(0xFFE9E9E9), spacing: 56),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFFDFDFD)],
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter({required this.lineColor, required this.spacing});

  final Color lineColor;
  final double spacing;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;

    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor || oldDelegate.spacing != spacing;
  }
}
