import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../global/loading.dart';
import '../../../../global/responsive.dart';
import '../controller/admin_subscriptions_controller.dart';
import '../model/admin_subscription_model.dart';
import 'widgets/subscription_form_dialog.dart';

class AdminSubscriptionsView extends GetView<AdminSubscriptionsController> {
  const AdminSubscriptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final info = context.responsive;
      final categories = controller.categories;
      final plans = controller.filteredSubscriptions;

      return Padding(
        padding: EdgeInsets.all(
          info.value(mobile: 16, tablet: 18, desktop: 24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Subscriptions',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'View, edit, and create subscription plans for the admin panel.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    controller.startCreate();
                    showDialog<void>(
                      context: context,
                      builder: (_) =>
                          const SubscriptionFormDialog(isEditing: false),
                    );
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add Plan'),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final selected =
                      controller.selectedCategory.value == category;
                  return ChoiceChip(
                    label: Text(category),
                    selected: selected,
                    onSelected: (_) => controller.setCategory(category),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Container(
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
                    : plans.isEmpty
                    ? const _EmptySubscriptionsState()
                    : ListView.separated(
                        itemCount: plans.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return _SubscriptionCard(plan: plans[index]);
                        },
                      ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _SubscriptionCard extends GetView<AdminSubscriptionsController> {
  const _SubscriptionCard({required this.plan});

  final AdminSubscriptionPlan plan;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE7EDF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.planName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      plan.category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EEFF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '\$${plan.price.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF2563EB),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _InfoChip(label: '${plan.duration} days'),
              _InfoChip(label: '${plan.facilities.length} facilities'),
              _InfoChip(label: plan.isActive ? 'Active' : 'Inactive'),
              if (plan.appleProductId.isNotEmpty)
                _InfoChip(label: plan.appleProductId),
            ],
          ),
          if (plan.details.trim().isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              plan.details,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF475569),
                height: 1.45,
              ),
            ),
          ],
          if (plan.facilities.isNotEmpty) ...[
            const SizedBox(height: 14),
            ...plan.facilities.map(
              (facility) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 7),
                      child: Icon(
                        Icons.circle,
                        size: 6,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(facility)),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                plan.updatedAt != null
                    ? 'Updated ${DateFormat('dd MMM yyyy').format(plan.updatedAt!.toLocal())}'
                    : 'Updated date unavailable',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: const Color(0xFF64748B)),
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () {
                  controller.startEdit(plan);
                  showDialog<void>(
                    context: context,
                    builder: (_) =>
                        const SubscriptionFormDialog(isEditing: true),
                  );
                },
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Edit'),
              ),
              const SizedBox(width: 10),
              TextButton.icon(
                onPressed: () => _confirmDelete(context),
                icon: const Icon(Icons.delete_outline_rounded, size: 16),
                label: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Plan'),
        content: Text('Delete "${plan.planName}" permanently?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await controller.deleteSubscription(plan);
    }
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _EmptySubscriptionsState extends StatelessWidget {
  const _EmptySubscriptionsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.subscriptions_outlined,
            size: 52,
            color: Color(0xFFFF4000),
          ),
          const SizedBox(height: 12),
          Text(
            'No subscription plans found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          Text(
            'Create the first plan to populate this section.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
