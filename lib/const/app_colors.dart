import 'package:flutter/material.dart';

class AppColors {
  //static const Color bgColor = Color(0xFFE2EFFF);
  static const Color bgColor = Colors.white;
  static const Color primaryColor = Color(0xffFF4000);
  static const Color buttonColors = Color(0xffFF4000);
  static const Color secondaryColor = Color(0xff000710);
  static const Color blackColor = Color(0xff000710);
  static final Color shadowColor = const Color(0xff000710).withOpacity(0.1);

  static final Color fade = const Color(0xff2563EB).withOpacity(0.4);
  static final Color indicatorColor = const Color(0xff2563EB);

  static final Color whiteColor = const Color.fromARGB(255, 255, 255, 255);

  static const LinearGradient gradientColor = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF7B4BF5), Color(0xFFBD5FF3)],
  );
  static Color hintTextColor = Color(0xFF898989);
}
