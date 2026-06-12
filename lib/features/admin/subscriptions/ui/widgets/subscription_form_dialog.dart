import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/admin_subscriptions_controller.dart';

class SubscriptionFormDialog extends GetView<AdminSubscriptionsController> {
  const SubscriptionFormDialog({super.key, required this.isEditing});

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isEditing ? 'Edit Subscription' : 'Create Subscription',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage plan name, billing details, and facilities from one form.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _SizedField(
                      width: 340,
                      child: _LabeledField(
                        label: 'Plan Name',
                        child: TextField(
                          controller: controller.planNameController,
                        ),
                      ),
                    ),
                    _SizedField(
                      width: 340,
                      child: _LabeledField(
                        label: 'Plan Type',
                        child: TextField(
                          controller: controller.planTypeController,
                        ),
                      ),
                    ),
                    _SizedField(
                      width: 160,
                      child: _LabeledField(
                        label: 'Price',
                        child: TextField(
                          controller: controller.priceController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    _SizedField(
                      width: 160,
                      child: _LabeledField(
                        label: 'Duration (days)',
                        child: TextField(
                          controller: controller.durationController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    _SizedField(
                      width: 340,
                      child: _LabeledField(
                        label: 'Apple Product ID',
                        child: TextField(
                          controller: controller.appleProductIdController,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _LabeledField(
                  label: 'Details',
                  child: TextField(
                    controller: controller.detailsController,
                    maxLines: 3,
                  ),
                ),
                const SizedBox(height: 16),
                _LabeledField(
                  label: 'Facilities (one per line)',
                  child: TextField(
                    controller: controller.facilitiesController,
                    maxLines: 6,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => SwitchListTile.adaptive(
                    value: controller.isActive.value,
                    onChanged: (value) => controller.isActive.value = value,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Active plan'),
                    subtitle: const Text(
                      'Turn this off to keep the plan hidden.',
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    Obx(
                      () => ElevatedButton(
                        onPressed: controller.isSaving.value
                            ? null
                            : controller.saveSubscription,
                        child: Text(
                          controller.isSaving.value
                              ? 'Saving...'
                              : isEditing
                              ? 'Save Changes'
                              : 'Create Plan',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _SizedField extends StatelessWidget {
  const _SizedField({required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, child: child);
  }
}
