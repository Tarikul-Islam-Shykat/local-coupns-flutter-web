import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'features/admin/dashboard/controller/admin_dashboard_controller.dart';
import 'features/admin/dashboard/ui/admin_dashboard_page.dart';
import 'features/admin/offers/controller/admin_offers_controller.dart';
import 'features/admin/users/controller/admin_users_controller.dart';
import 'features/auth/login/controller/login_controller.dart';
import 'features/auth/login/ui/login_page.dart';
import 'global/issue_log_service.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IssueLogService.instance.init();
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
            GetPage(
              name: AppRoutes.adminDashboard,
              page: () => const AdminDashboardPage(),
              binding: BindingsBuilder(() {
                Get.lazyPut<AdminDashboardController>(
                  () => AdminDashboardController(),
                  fenix: true,
                );
                Get.lazyPut<AdminUsersController>(
                  () => AdminUsersController(),
                  fenix: true,
                );
                Get.lazyPut<AdminOffersController>(
                  () => AdminOffersController(),
                  fenix: true,
                );
              }),
            ),
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
