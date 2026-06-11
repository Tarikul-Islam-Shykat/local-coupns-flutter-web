import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'features/auth/login/controller/login_controller.dart';
import 'features/auth/login/ui/login_page.dart';
import 'routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LocalCouponsApp());
}

class LocalCouponsApp extends StatelessWidget {
  const LocalCouponsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Local Coupons',
          initialRoute: AppRoutes.login,
          initialBinding: BindingsBuilder(() {
            Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
          }),
          getPages: [
            GetPage(name: AppRoutes.login, page: () => const LoginPage()),
          ],
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFFF4000),
              brightness: Brightness.light,
              primary: const Color(0xFFFF4000),
              secondary: const Color(0xFF102A43),
              surface: Colors.white,
            ),
          ),
          home: child,
        );
      },
    );
  }
}
