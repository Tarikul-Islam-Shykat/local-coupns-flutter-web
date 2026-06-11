import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      } else {
        users.clear();
      }
    } catch (error, stackTrace) {
      log('Users load error: $error', stackTrace: stackTrace);
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
