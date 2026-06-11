import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_text.dart';
import 'app_btn.dart';

class DevelopmentDialog {
  static Future<void> show() async {
    await Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.engineering_rounded,
                  color: Colors.amber[800],
                  size: 48.w,
                ),
              ),
              SizedBox(height: 20.h),
              headingText(
                text: "Under Development",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              normalTextv2(
                text:
                    "The Shopper experience is currently being carefully crafted. Please check back soon for the full release!",
                textAlign: TextAlign.center,
                maxLines: 3,
                color: Colors.grey[700]!,
              ),
              SizedBox(height: 32.h),
              GlobalAppButton(
                text: "Got it",
                onTap: () => Get.back(),
                height: 48.h,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
