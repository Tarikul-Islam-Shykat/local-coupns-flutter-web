import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../global/custom_snackbar.dart';
import '../../../../global/issue_log_service.dart';
import '../../../../service/network/endpoints/endpoints.dart';
import '../../../../service/network/service/api_service.dart';
import '../model/admin_subscription_model.dart';

class AdminSubscriptionsController extends GetxController {
  final api = ApiService.instance;

  final isLoading = false.obs;
  final isSaving = false.obs;
  final isDeleting = false.obs;
  final subscriptions = <AdminSubscriptionPlan>[].obs;
  final selectedCategory = 'All'.obs;

  final planNameController = TextEditingController();
  final planTypeController = TextEditingController(text: 'monthly');
  final priceController = TextEditingController();
  final durationController = TextEditingController(text: '30');
  final appleProductIdController = TextEditingController();
  final detailsController = TextEditingController();
  final facilitiesController = TextEditingController();
  final isActive = true.obs;

  String? editingSubscriptionId;

  @override
  void onInit() {
    super.onInit();
    loadSubscriptions();
  }

  @override
  void onClose() {
    planNameController.dispose();
    planTypeController.dispose();
    priceController.dispose();
    durationController.dispose();
    appleProductIdController.dispose();
    detailsController.dispose();
    facilitiesController.dispose();
    super.onClose();
  }

  List<String> get categories {
    final values = subscriptions.map((plan) => plan.category).toSet().toList()
      ..sort();
    return ['All', ...values];
  }

  List<AdminSubscriptionPlan> get filteredSubscriptions {
    if (selectedCategory.value == 'All') {
      return subscriptions;
    }
    return subscriptions
        .where((plan) => plan.category == selectedCategory.value)
        .toList();
  }

  Future<void> loadSubscriptions() async {
    try {
      isLoading.value = true;
      await IssueLogService.instance.add(
        'Subscriptions request started',
        details: 'GET ${Urls.adminFetchSubscription}',
      );

      final response = await api.get(Urls.adminFetchSubscription, auth: true);

      if (response is Map<String, dynamic>) {
        final parsed = AdminSubscriptionsResponse.fromJson(response);
        subscriptions.assignAll(parsed.plans);
        if (!categories.contains(selectedCategory.value)) {
          selectedCategory.value = 'All';
        }
        await IssueLogService.instance.add(
          'Subscriptions loaded successfully',
          details: 'Loaded ${parsed.plans.length} subscription plan(s).',
        );
      } else {
        subscriptions.clear();
        await IssueLogService.instance.add(
          'Subscriptions request returned an unexpected response',
          level: 'warning',
          details: response.toString(),
        );
      }
    } catch (error, stackTrace) {
      log('Subscriptions load error: $error', stackTrace: stackTrace);
      await IssueLogService.instance.add(
        'Subscriptions fetch threw an exception',
        level: 'error',
        details: '$error\n$stackTrace',
      );
      showSnackBar(false, 'Failed to load subscriptions.');
    } finally {
      isLoading.value = false;
    }
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  void startCreate() {
    editingSubscriptionId = null;
    planNameController.clear();
    planTypeController.text = 'monthly';
    priceController.clear();
    durationController.text = '30';
    appleProductIdController.clear();
    detailsController.clear();
    facilitiesController.clear();
    isActive.value = true;
  }

  void startEdit(AdminSubscriptionPlan plan) {
    editingSubscriptionId = plan.id;
    planNameController.text = plan.planName;
    planTypeController.text = plan.planType;
    priceController.text = plan.price.toStringAsFixed(0);
    durationController.text = plan.duration.toString();
    appleProductIdController.text = plan.appleProductId;
    detailsController.text = plan.details;
    facilitiesController.text = plan.facilities.join('\n');
    isActive.value = plan.isActive;
  }

  Future<void> saveSubscription() async {
    if (!_validateForm()) {
      return;
    }

    try {
      isSaving.value = true;
      final payload = _buildPayload();

      final response = editingSubscriptionId == null
          ? await api.post(Urls.adminCreateSubscription, payload, auth: true)
          : await api.put(
              Urls.adminUpdateSubscription(editingSubscriptionId!),
              payload,
              auth: true,
            );

      if (response is Map<String, dynamic> && response['success'] == true) {
        showSnackBar(
          true,
          editingSubscriptionId == null
              ? 'Subscription created successfully.'
              : 'Subscription updated successfully.',
        );
        await loadSubscriptions();
        Get.back();
      } else {
        showSnackBar(
          false,
          response is Map<String, dynamic>
              ? response['message']?.toString() ??
                    'Failed to save subscription.'
              : 'Failed to save subscription.',
        );
      }
    } catch (error) {
      showSnackBar(false, 'Failed to save subscription.');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteSubscription(AdminSubscriptionPlan plan) async {
    try {
      isDeleting.value = true;
      final response = await api.delete(
        Urls.adminDeleteSubscription(plan.id),
        auth: true,
      );

      if (response is Map<String, dynamic> && response['success'] == true) {
        showSnackBar(true, 'Subscription deleted successfully.');
        await loadSubscriptions();
      } else {
        showSnackBar(
          false,
          response is Map<String, dynamic>
              ? response['message']?.toString() ??
                    'Failed to delete subscription.'
              : 'Failed to delete subscription.',
        );
      }
    } catch (error) {
      showSnackBar(false, 'Failed to delete subscription.');
    } finally {
      isDeleting.value = false;
    }
  }

  Map<String, dynamic> _buildPayload() {
    return {
      'planName': planNameController.text.trim(),
      'planType': planTypeController.text.trim(),
      'facilities': facilitiesController.text
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList(),
      'apple_product_id': appleProductIdController.text.trim(),
      'price': double.parse(priceController.text.trim()),
      'duration': int.parse(durationController.text.trim()),
      'details': detailsController.text.trim(),
      'isActive': isActive.value,
    };
  }

  bool _validateForm() {
    if (planNameController.text.trim().isEmpty) {
      showSnackBar(false, 'Plan name is required.');
      return false;
    }
    if (planTypeController.text.trim().isEmpty) {
      showSnackBar(false, 'Plan type is required.');
      return false;
    }
    if (priceController.text.trim().isEmpty) {
      showSnackBar(false, 'Price is required.');
      return false;
    }
    if (double.tryParse(priceController.text.trim()) == null) {
      showSnackBar(false, 'Price must be a valid number.');
      return false;
    }
    if (durationController.text.trim().isEmpty) {
      showSnackBar(false, 'Duration is required.');
      return false;
    }
    if (int.tryParse(durationController.text.trim()) == null) {
      showSnackBar(false, 'Duration must be a valid number.');
      return false;
    }
    if (appleProductIdController.text.trim().isEmpty) {
      showSnackBar(false, 'Apple product ID is required.');
      return false;
    }
    final facilities = facilitiesController.text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
    if (facilities.isEmpty) {
      showSnackBar(false, 'Add at least one facility.');
      return false;
    }
    return true;
  }
}
