import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const _LogoBadge(),
                        SizedBox(height: 22.h),
                        headingText(
                          text: 'Log in your Account',
                          fontWeight: FontWeight.w700,
                          color: AppColors.blackColor,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          maxLines: 2,
                        ),
                        SizedBox(height: 8.h),
                        smallText(
                          text: 'Welcome back! Please enter your details.',
                          color: AppColors.hintTextColor,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          maxLines: 2,
                        ),
                        SizedBox(height: 30.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: normalText(
                            text: 'Email',
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackColor,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        GlobalTextField(
                          controller: controller.emailController,
                          hintText: 'admin@gmail.com',
                          keyboardType: TextInputType.emailAddress,
                          validator: controller.validateEmail,
                          fillColor: const Color(0xFFEAF1FF),
                          borderRadius: 10,
                        ),
                        SizedBox(height: 16.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: normalText(
                            text: 'Password',
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackColor,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        GlobalTextField(
                          controller: controller.passwordController,
                          hintText: 'Enter password',
                          isHidden: true,
                          validator: controller.validatePassword,
                          fillColor: const Color(0xFFEAF1FF),
                          borderRadius: 10,
                        ),
                        SizedBox(height: 10.h),
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
                              foregroundColor: AppColors.secondaryColor
                                  .withValues(alpha: 0.75),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Text('Forgot your password?'),
                          ),
                        ),
                        SizedBox(height: 14.h),
                        Obx(
                          () => GlobalAppButton(
                            text: 'Log In',
                            onTap: controller.submitLogin,
                            isLoading: controller.isLoading.value,
                            height: 48.h,
                            borderRadius: 28,
                            backgroundColor: AppColors.buttonColors,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoBadge extends StatelessWidget {
  const _LogoBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84.w,
      height: 84.w,
      decoration: BoxDecoration(
        color: AppColors.buttonColors,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.buttonColors.withValues(alpha: 0.24),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(
        Icons.local_offer_rounded,
        color: Colors.white,
        size: 42,
      ),
    );
  }
}

class _LoginBackground extends StatelessWidget {
  const _LoginBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GridPainter(lineColor: const Color(0xFFE8E8E8), spacing: 48),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
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
