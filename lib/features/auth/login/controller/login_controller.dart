import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../global/custom_snackbar.dart';
import '../../../../service/network/endpoints/endpoints.dart';
import '../../../../service/network/service/api_service.dart';
import '../../../../service/storage/local_storage/local_storage.dart';
import '../../../../routes/app_routes.dart';
import '../model/login_model.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isRememberMe = true.obs;

  final LocalService _localService = LocalService();

  @override
  void onInit() {
    super.onInit();
    emailController.text = 'admin@gmail.com';
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(email)) return 'Enter a valid email address';
    return null;
  }

  String? validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Password is required';
    if (password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  Future<void> submitLogin() async {
    final form = formKey.currentState;
    if (form == null || !form.validate()) return;

    isLoading.value = true;

    try {
      final request = LoginRequestModel(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      debugPrint('Login request payload: ${request.toJson()}');
      log('Login request payload: ${request.toJson()}');

      final response = await ApiService.instance.post(
        Urls.login,
        request.toJson(),
      );

      if (response == null) {
        debugPrint('Login response is null');
        log('Login response is null');
        showSnackBar(false, 'Login failed. Please try again.');
        return;
      }

      debugPrint('Login raw response: $response');
      log('Login raw response: $response');

      final loginResponse = LoginResponseModel.fromJson(response);
      debugPrint('Login parsed success: ${loginResponse.success}');
      debugPrint('Login parsed message: ${loginResponse.message}');
      debugPrint('Login parsed token: ${loginResponse.token}');
      debugPrint('Login parsed userId: ${loginResponse.userId}');
      debugPrint('Login parsed role: ${loginResponse.role}');
      log('Login parsed success: ${loginResponse.success}');
      log('Login parsed message: ${loginResponse.message}');
      log('Login parsed token: ${loginResponse.token}');
      log('Login parsed userId: ${loginResponse.userId}');
      log('Login parsed role: ${loginResponse.role}');

      if (!loginResponse.success && !loginResponse.hasToken) {
        debugPrint('Login rejected because success/token were missing.');
        log('Login rejected because success/token were missing.');
        showSnackBar(
          false,
          loginResponse.message ?? 'Invalid login credentials.',
        );
        return;
      }

      if (loginResponse.hasToken) {
        await _localService.setValue(PreferenceKey.token, loginResponse.token!);
      }

      await _localService.setValue(
        PreferenceKey.email,
        loginResponse.email ?? emailController.text.trim(),
      );

      if ((loginResponse.role ?? '').isNotEmpty) {
        await _localService.setValue(PreferenceKey.role, loginResponse.role!);
      }

      if ((loginResponse.userId ?? '').isNotEmpty) {
        await _localService.setValue(
          PreferenceKey.userId,
          loginResponse.userId!,
        );
      }

      await _localService.setValue(PreferenceKey.rememberMe, true);

      showSnackBar(true, loginResponse.message ?? 'Login successful.');
      Get.offAllNamed(AppRoutes.adminDashboard);
    } catch (error, stackTrace) {
      debugPrint('Login error: $error');
      log('Login error: $error', stackTrace: stackTrace);
      showSnackBar(
        false,
        'Unable to log in right now. Please check your connection and try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
