import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../global/custom_snackbar.dart';
import '../../../../service/network/endpoints/endpoints.dart';
import '../../../../service/network/service/api_service.dart';
import '../../../../service/storage/local_storage/local_storage.dart';
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

      final response = await ApiService.instance.post(
        Urls.login,
        request.toJson(),
      );

      if (response == null) {
        showSnackBar(false, 'Login failed. Please try again.');
        return;
      }

      final loginResponse = LoginResponseModel.fromJson(response);

      if (!loginResponse.success && !loginResponse.hasToken) {
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

      await _localService.setValue(PreferenceKey.rememberMe, true);

      showSnackBar(true, loginResponse.message ?? 'Login successful.');
    } catch (_) {
      showSnackBar(
        false,
        'Unable to log in right now. Please check your connection and try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
