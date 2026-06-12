import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../global/loading.dart';
import '../../../../global/responsive.dart';
import '../controller/admin_offers_controller.dart';
import '../model/admin_offer_model.dart';

class OfferReviewView extends GetView<AdminOffersController> {
  const OfferReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final info = context.responsive;
      final meta = controller.meta.value;
      final offers = controller.filteredOffers;

      return SingleChildScrollView(
        padding: EdgeInsets.all(
          info.value(mobile: 16, tablet: 18, desktop: 24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _OfferHeader(pendingCount: controller.pendingOffersCount),
            const SizedBox(height: 18),
            _OfferFilterBar(controller: controller),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE7EDF3)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x06000000),
                    blurRadius: 18,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: controller.isLoading.value
                  ? loading(value: 34)
                  : offers.isEmpty
                  ? const _EmptyOffersState()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'All Offers (${meta?.total ?? offers.length})',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 18),
                        if (info.isDesktop)
                          _OffersTable(offers: offers)
                        else
                          _OfferCards(offers: offers),
                      ],
                    ),
            ),
          ],
        ),
      );
    });
  }
}

class _OfferHeader extends StatelessWidget {
  const _OfferHeader({required this.pendingCount});

  final int pendingCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review Queue',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          'Moderate and approve pending offers before they go live',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFFF59E0B),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$pendingCount pending approval',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF92400E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Review content documents and approve or reject offers.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFB45309),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OfferFilterBar extends StatelessWidget {
  const _OfferFilterBar({required this.controller});

  final AdminOffersController controller;

  @override
  Widget build(BuildContext context) {
    final gap = context.responsive.gap;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE7EDF3)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;
          final children = <Widget>[
            Expanded(
              flex: isWide ? 5 : 1,
              child: TextField(
                controller: controller.searchController,
                onChanged: controller.onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search by name, email, or category...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: const Color(0xFFF7F8FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFFF4000)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
            SizedBox(width: isWide ? gap : 0, height: isWide ? 0 : 12),
            Expanded(
              flex: isWide ? 2 : 1,
              child: DropdownButtonFormField<String>(
                initialValue: controller.selectedCategory.value,
                items: [
                  const DropdownMenuItem(
                    value: '',
                    child: Text('All Category'),
                  ),
                  ...controller.availableCategories.map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(_prettyOfferCategory(category)),
                    ),
                  ),
                ],
                onChanged: (value) => controller.setCategory(value ?? ''),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF7F8FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ];

          if (isWide) {
            return Row(children: children);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          );
        },
      ),
    );
  }
}

class _OffersTable extends StatelessWidget {
  const _OffersTable({required this.offers});

  final List<AdminOffer> offers;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 24,
        headingRowColor: const WidgetStatePropertyAll<Color>(Color(0xFFF8FAFC)),
        columns: const [
          DataColumn(label: Text('Merchant')),
          DataColumn(label: Text('Offer Title')),
          DataColumn(label: Text('Category')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Post Date')),
          DataColumn(label: Text('Expiry Date')),
          DataColumn(label: Text('Actions')),
        ],
        rows: offers
            .map(
              (offer) => DataRow(
                cells: [
                  DataCell(_MerchantCell(offer: offer)),
                  DataCell(Text(offer.title)),
                  DataCell(Text(_prettyOfferCategory(offer.category))),
                  DataCell(_StatusPill(status: offer.status)),
                  DataCell(Text(_formatDate(offer.createdAt))),
                  DataCell(Text(_formatDate(offer.expiresAt))),
                  DataCell(_ViewButton(offer: offer)),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

class _OfferCards extends StatelessWidget {
  const _OfferCards({required this.offers});

  final List<AdminOffer> offers;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: offers
          .map(
            (offer) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _OfferCard(offer: offer),
            ),
          )
          .toList(),
    );
  }
}

class _OfferCard extends StatelessWidget {
  const _OfferCard({required this.offer});

  final AdminOffer offer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7EDF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _MerchantCell(offer: offer)),
              _StatusPill(status: offer.status),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            offer.title,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text('Category: ${_prettyOfferCategory(offer.category)}'),
          const SizedBox(height: 4),
          Text('Posted: ${_formatDate(offer.createdAt)}'),
          const SizedBox(height: 4),
          Text('Expires: ${_formatDate(offer.expiresAt)}'),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: _ViewButton(offer: offer),
          ),
        ],
      ),
    );
  }
}

class _MerchantCell extends StatelessWidget {
  const _MerchantCell({required this.offer});

  final AdminOffer offer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          offer.businessName,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(
          offer.user.email,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: const Color(0xFF64748B)),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final normalized = status.toUpperCase();
    final isPending = normalized == 'PENDING';
    final background = isPending
        ? const Color(0xFFFFF4D6)
        : const Color(0xFFE8FFF4);
    final foreground = isPending
        ? const Color(0xFFCA8A04)
        : const Color(0xFF059669);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _titleCase(normalized),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ViewButton extends StatelessWidget {
  const _ViewButton({required this.offer});

  final AdminOffer offer;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => showDialog<void>(
        context: context,
        builder: (context) => _OfferDetailsDialog(offer: offer),
      ),
      icon: const Icon(Icons.visibility_outlined, size: 16),
      label: const Text('View'),
    );
  }
}

class _OfferDetailsDialog extends StatelessWidget {
  const _OfferDetailsDialog({required this.offer});

  final AdminOffer offer;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(offer.title),
      content: SizedBox(
        width: 640,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _DetailRow(label: 'Merchant', value: offer.businessName),
              _DetailRow(label: 'Owner', value: offer.user.fullName),
              _DetailRow(label: 'Email', value: offer.user.email),
              _DetailRow(
                label: 'Category',
                value: _prettyOfferCategory(offer.category),
              ),
              _DetailRow(label: 'Status', value: _titleCase(offer.status)),
              _DetailRow(
                label: 'Offer Type',
                value: _titleCase(offer.offerType),
              ),
              _DetailRow(
                label: 'Redemption Type',
                value: _titleCase(offer.redemptionType),
              ),
              _DetailRow(label: 'Created', value: _formatDate(offer.createdAt)),
              _DetailRow(label: 'Expires', value: _formatDate(offer.expiresAt)),
              const SizedBox(height: 12),
              Text(
                'Description',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(offer.description.isEmpty ? '-' : offer.description),
              const SizedBox(height: 16),
              Text(
                'Terms & Conditions',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                offer.termsAndConditions.isEmpty
                    ? '-'
                    : offer.termsAndConditions,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _MetricChip(label: 'Views', value: offer.totalViews),
                  _MetricChip(
                    label: 'Activations',
                    value: offer.totalActivations,
                  ),
                  _MetricChip(label: 'Saves', value: offer.totalSaves),
                  _MetricChip(label: 'Shares', value: offer.totalShares),
                  _MetricChip(
                    label: 'Redemptions',
                    value: offer.totalRedemptions,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$label: $value',
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _EmptyOffersState extends StatelessWidget {
  const _EmptyOffersState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.local_offer_outlined,
            size: 44,
            color: Color(0xFFFF4000),
          ),
          const SizedBox(height: 12),
          Text(
            'No offers found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          Text(
            'Try changing the search or category filter.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

String _prettyOfferCategory(String value) {
  if (value.trim().isEmpty) return '-';
  return value
      .split('_')
      .map(
        (part) => part.isEmpty
            ? part
            : '${part[0]}${part.substring(1).toLowerCase()}',
      )
      .join(' ');
}

String _titleCase(String value) {
  if (value.trim().isEmpty) return '-';
  return value
      .split('_')
      .map(
        (part) => part.isEmpty
            ? part
            : '${part[0]}${part.substring(1).toLowerCase()}',
      )
      .join(' ');
}

String _formatDate(DateTime? value) {
  if (value == null) return '-';
  return DateFormat('M/d/yy').format(value.toLocal());
}
