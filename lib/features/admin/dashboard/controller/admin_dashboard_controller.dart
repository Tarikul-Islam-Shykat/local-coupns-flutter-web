import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../global/custom_snackbar.dart';
import '../../../../global/issue_log_service.dart';
import '../../../../service/network/endpoints/endpoints.dart';
import '../../../../service/network/instance/network_client.dart';
import '../../offers/controller/admin_offers_controller.dart';
import '../../users/controller/admin_users_controller.dart';
import '../model/admin_dashboard_model.dart';

class AdminDashboardController extends GetxController {
  final isLoading = false.obs;
  final overview = Rxn<AdminDashboardModel>();
  final dashboardErrorMessage = RxnString();
  final dashboardStatusCode = RxnInt();
  final selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    try {
      isLoading.value = true;
      overview.value = null;
      dashboardErrorMessage.value = null;
      dashboardStatusCode.value = null;
      await IssueLogService.instance.add(
        'Dashboard request started',
        details: 'GET ${Urls.adminDashboardOverview}',
      );

      final response = await NetworkClient.instance.dio.get(
        Urls.adminDashboardOverview,
        options: Options(extra: {'auth': true}),
      );
      final statusCode = response.statusCode;
      final body = response.data;

      debugPrint('Dashboard raw response: $body');
      log('Dashboard raw response: $body');

      if (body == null) {
        dashboardErrorMessage.value = 'Dashboard data could not be loaded.';
        await IssueLogService.instance.add(
          'Dashboard request failed',
          level: 'error',
          details: 'No response returned from ${Urls.adminDashboardOverview}',
        );
        showSnackBar(false, 'Dashboard data could not be loaded.');
        return;
      }

      if (_isUnauthorized(statusCode, body)) {
        dashboardStatusCode.value = statusCode ?? 401;
        dashboardErrorMessage.value =
            _extractMessage(body) ??
            'You are not authorized to view the dashboard.';
        await IssueLogService.instance.add(
          'Dashboard authorization failed',
          level: 'error',
          details:
              'Status: ${statusCode ?? 401}\n'
              'Message: ${dashboardErrorMessage.value}',
        );
        showSnackBar(false, dashboardErrorMessage.value!);
        return;
      }

      if (body is Map<String, dynamic> && body['success'] == true) {
        overview.value = AdminDashboardModel.fromJson(body);
        dashboardErrorMessage.value = null;
        dashboardStatusCode.value = null;
        log('Dashboard loaded successfully');
        await IssueLogService.instance.add(
          'Dashboard loaded successfully',
          details: 'Cards and charts data was received.',
        );
      } else {
        dashboardStatusCode.value = statusCode;
        dashboardErrorMessage.value =
            _extractMessage(body) ?? 'Dashboard data could not be loaded.';
        await IssueLogService.instance.add(
          'Dashboard returned an unexpected response',
          level: 'warning',
          details: body.toString(),
        );
        showSnackBar(false, dashboardErrorMessage.value!);
      }
    } on DioException catch (error, stackTrace) {
      final statusCode = error.response?.statusCode;
      final responseData = error.response?.data;
      final extractedMessage =
          _extractMessage(responseData) ??
          error.message ??
          'Failed to load dashboard.';

      dashboardStatusCode.value = statusCode;
      dashboardErrorMessage.value = extractedMessage;

      log('Dashboard Dio error: $error', stackTrace: stackTrace);
      await IssueLogService.instance.add(
        'Dashboard request failed',
        level: 'error',
        details:
            'GET ${Urls.adminDashboardOverview}\n'
            'Status: ${statusCode ?? "unknown"}\n'
            'Message: $extractedMessage\n'
            'Response body: ${responseData ?? "null"}',
      );
      showSnackBar(false, extractedMessage);
    } catch (error, stackTrace) {
      dashboardErrorMessage.value = 'Failed to load dashboard.';
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
    if (Get.isRegistered<AdminUsersController>()) {
      final usersController = Get.find<AdminUsersController>();
      if (index == 1) {
        usersController.showMerchants();
      } else if (index == 2) {
        usersController.showConsumers();
      }
    }
    if (index == 3 && Get.isRegistered<AdminOffersController>()) {
      Get.find<AdminOffersController>().loadOffers();
    }
  }

  bool get isUnauthorized =>
      dashboardStatusCode.value == 401 || dashboardStatusCode.value == 403;

  bool _isUnauthorized(int? statusCode, dynamic body) {
    if (statusCode == 401 || statusCode == 403) {
      return true;
    }

    final message = _extractMessage(body)?.toLowerCase();
    if (message == null) {
      return false;
    }

    return message.contains('not authorized') ||
        message.contains('unauthorized') ||
        message.contains('401');
  }

  String? _extractMessage(dynamic body) {
    if (body is Map<String, dynamic>) {
      final directMessage = body['message']?.toString().trim();
      if (directMessage != null && directMessage.isNotEmpty) {
        return directMessage;
      }

      final data = body['data'];
      if (data is Map<String, dynamic>) {
        final nestedMessage = data['message']?.toString().trim();
        if (nestedMessage != null && nestedMessage.isNotEmpty) {
          return nestedMessage;
        }
      }
    }

    final text = body?.toString().trim();
    if (text == null || text.isEmpty || text == 'null') {
      return null;
    }
    return text;
  }
}
