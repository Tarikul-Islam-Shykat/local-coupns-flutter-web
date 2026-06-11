import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../global/issue_log_service.dart';
import '../../../../service/network/endpoints/endpoints.dart';
import '../../../../service/network/service/api_service.dart';
import '../model/admin_user_model.dart';

class AdminUsersController extends GetxController {
  final isLoading = false.obs;
  final users = <AdminUser>[].obs;
  final meta = Rxn<UserMeta>();

  final searchController = TextEditingController();
  final selectedRole = 'SHOPPER'.obs;
  final selectedStatus = ''.obs;

  final roles = const ['SHOPPER', 'BUSSINESS_OWNER'];
  final statuses = const ['', 'ACTIVE', 'PENDING', 'BLOCKED'];

  final api = ApiService.instance;

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  Future<void> loadUsers([String? _]) async {
    try {
      isLoading.value = true;

      final query = <String, dynamic>{
        'searchTerm': searchController.text.trim(),
        'role': selectedRole.value,
        'status': selectedStatus.value,
      }..removeWhere((key, value) => value == null || value.toString().isEmpty);

      debugPrint('Users query: $query');
      log('Users query: $query');
      await IssueLogService.instance.add(
        'Users request started',
        details: 'GET ${Urls.users}\n$query',
      );

      final response = await api.get(
        Urls.users,
        auth: true,
        queryParameters: query,
      );

      debugPrint('Users raw response: $response');
      log('Users raw response: $response');

      if (response is Map<String, dynamic> && response['success'] == true) {
        final parsed = AdminUsersResponse.fromJson(response);
        users.assignAll(parsed.users);
        meta.value = parsed.meta;
        log('Loaded users: ${users.length}');
        await IssueLogService.instance.add(
          'Users loaded successfully',
          details: 'Loaded ${users.length} user(s).',
        );
      } else {
        users.clear();
        await IssueLogService.instance.add(
          'Users request returned an unexpected response',
          level: 'warning',
          details: response.toString(),
        );
      }
    } catch (error, stackTrace) {
      log('Users load error: $error', stackTrace: stackTrace);
      await IssueLogService.instance.add(
        'Users fetch threw an exception',
        level: 'error',
        details: '$error\n$stackTrace',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void setRole(String role) {
    selectedRole.value = role;
    loadUsers();
  }

  void setStatus(String status) {
    selectedStatus.value = status;
    loadUsers();
  }

  void clearFilters() {
    searchController.clear();
    selectedRole.value = 'SHOPPER';
    selectedStatus.value = '';
    loadUsers();
  }

  void onSearchChanged(String _) {
    loadUsers();
  }

  String get displaySectionLabel =>
      selectedRole.value == 'BUSSINESS_OWNER' ? 'Merchants' : 'Consumers';
}
