import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../global/custom_snackbar.dart';
import '../../../../global/issue_log_service.dart';
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
      await IssueLogService.instance.add(
        'Dashboard request started',
        details: 'GET ${Urls.adminDashboardOverview}',
      );

      final response = await api.get(
        Urls.adminDashboardOverview,
        auth: true,
        sendBearerToken: false,
      );

      debugPrint('Dashboard raw response: $response');
      log('Dashboard raw response: $response');

      if (response == null) {
        await IssueLogService.instance.add(
          'Dashboard request failed',
          level: 'error',
          details: 'No response returned from ${Urls.adminDashboardOverview}',
        );
        showSnackBar(false, 'Dashboard data could not be loaded.');
        return;
      }

      if (response is Map<String, dynamic> && response['success'] == true) {
        overview.value = AdminDashboardModel.fromJson(response);
        log('Dashboard loaded successfully');
        await IssueLogService.instance.add(
          'Dashboard loaded successfully',
          details: 'Cards and charts data was received.',
        );
      } else {
        await IssueLogService.instance.add(
          'Dashboard returned an unexpected response',
          level: 'warning',
          details: response.toString(),
        );
        showSnackBar(
          false,
          (response is Map<String, dynamic> ? response['message'] : null)
                  ?.toString() ??
              'Dashboard data could not be loaded.',
        );
      }
    } catch (error, stackTrace) {
      log('Dashboard error: $error', stackTrace: stackTrace);
      await IssueLogService.instance.add(
        'Dashboard fetch threw an exception',
        level: 'error',
        details: '$error\n$stackTrace',
      );
      showSnackBar(false, 'Failed to load dashboard.');
    } finally {
      isLoading.value = false;
    }
  }

  void selectTab(int index) {
    selectedTab.value = index;
  }
}
