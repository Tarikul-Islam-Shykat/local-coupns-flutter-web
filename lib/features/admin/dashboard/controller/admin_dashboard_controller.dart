import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../global/custom_snackbar.dart';
import '../../../../service/network/endpoints/endpoints.dart';
import '../../../../service/network/service/api_service.dart';
import '../model/admin_dashboard_model.dart';

class AdminDashboardController extends GetxController {
  final isLoading = false.obs;
  final overview = Rxn<AdminDashboardModel>();
  final selectedTab = 0.obs;

  final api = ApiService.instance;

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    try {
      isLoading.value = true;
      final response = await api.get(Urls.adminDashboardOverview, auth: true);

      debugPrint('Dashboard raw response: $response');
      log('Dashboard raw response: $response');

      if (response == null) {
        showSnackBar(false, 'Dashboard data could not be loaded.');
        return;
      }

      if (response is Map<String, dynamic> && response['success'] == true) {
        overview.value = AdminDashboardModel.fromJson(response);
        log('Dashboard loaded successfully');
      } else {
        showSnackBar(
          false,
          (response is Map<String, dynamic> ? response['message'] : null)
                  ?.toString() ??
              'Dashboard data could not be loaded.',
        );
      }
    } catch (error, stackTrace) {
      log('Dashboard error: $error', stackTrace: stackTrace);
      showSnackBar(false, 'Failed to load dashboard.');
    } finally {
      isLoading.value = false;
    }
  }

  void selectTab(int index) {
    selectedTab.value = index;
  }
}
