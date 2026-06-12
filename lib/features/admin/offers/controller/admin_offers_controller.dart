import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../global/issue_log_service.dart';
import '../../../../service/network/endpoints/endpoints.dart';
import '../../../../service/network/service/api_service.dart';
import '../model/admin_offer_model.dart';

class AdminOffersController extends GetxController {
  final isLoading = false.obs;
  final offers = <AdminOffer>[].obs;
  final filteredOffers = <AdminOffer>[].obs;
  final meta = Rxn<OfferMeta>();
  final selectedCategory = ''.obs;

  final searchController = TextEditingController();
  final availableCategories = <String>[].obs;

  final api = ApiService.instance;

  @override
  void onInit() {
    super.onInit();
    loadOffers();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> loadOffers() async {
    try {
      isLoading.value = true;
      await IssueLogService.instance.add(
        'Offers request started',
        details: 'GET ${Urls.getBusinessOffer}',
      );

      final response = await api.get(Urls.getBusinessOffer, auth: true);

      debugPrint('Offers raw response: $response');
      log('Offers raw response: $response');

      if (response is Map<String, dynamic> && response['success'] == true) {
        final parsed = AdminOffersResponse.fromJson(response);
        offers.assignAll(parsed.offers);
        filteredOffers.assignAll(parsed.offers);
        meta.value = parsed.meta;
        _syncCategories(parsed.offers);
        applyFilters();
        await IssueLogService.instance.add(
          'Offers loaded successfully',
          details: 'Loaded ${parsed.offers.length} offer(s).',
        );
      } else {
        offers.clear();
        filteredOffers.clear();
        meta.value = null;
        await IssueLogService.instance.add(
          'Offers request returned an unexpected response',
          level: 'warning',
          details: response.toString(),
        );
      }
    } catch (error, stackTrace) {
      log('Offers load error: $error', stackTrace: stackTrace);
      await IssueLogService.instance.add(
        'Offers fetch threw an exception',
        level: 'error',
        details: '$error\n$stackTrace',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void setCategory(String category) {
    selectedCategory.value = category;
    applyFilters();
  }

  void onSearchChanged(String _) {
    applyFilters();
  }

  void clearFilters() {
    searchController.clear();
    selectedCategory.value = '';
    applyFilters();
  }

  int get pendingOffersCount => offers.where((offer) => offer.isPending).length;

  void applyFilters() {
    final searchTerm = searchController.text.trim().toLowerCase();
    final category = selectedCategory.value;

    final results = offers.where((offer) {
      final matchesCategory = category.isEmpty || offer.category == category;
      if (!matchesCategory) {
        return false;
      }

      if (searchTerm.isEmpty) {
        return true;
      }

      final haystack = [
        offer.businessName,
        offer.title,
        offer.category,
        offer.user.fullName,
        offer.user.email,
      ].join(' ').toLowerCase();

      return haystack.contains(searchTerm);
    }).toList();

    filteredOffers.assignAll(results);
  }

  void _syncCategories(List<AdminOffer> items) {
    final categories =
        items
            .map((offer) => offer.category)
            .where((category) => category.trim().isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    availableCategories.assignAll(categories);
  }
}
