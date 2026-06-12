import 'package:flutter/material.dart';

import '../../../../../global/responsive.dart';
import '../../controller/admin_users_controller.dart';

class UsersFilterCard extends StatelessWidget {
  const UsersFilterCard({super.key, required this.controller});

  final AdminUsersController controller;

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
              child: _SearchField(controller: controller),
            ),
            SizedBox(width: isWide ? gap : 0, height: isWide ? 0 : 12),
            Expanded(
              flex: isWide ? 2 : 1,
              child: _FilterDropdown<String>(
                label: 'Role',
                value: controller.selectedRole.value,
                items: const [
                  DropdownMenuItem(value: 'SHOPPER', child: Text('Consumers')),
                  DropdownMenuItem(
                    value: 'BUSSINESS_OWNER',
                    child: Text('Merchants'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) controller.setRole(value);
                },
              ),
            ),
            SizedBox(width: isWide ? gap : 0, height: isWide ? 0 : 12),
            Expanded(
              flex: isWide ? 2 : 1,
              child: _FilterDropdown<String>(
                label: 'Status',
                value: controller.selectedStatus.value,
                items: const [
                  DropdownMenuItem(value: '', child: Text('All Status')),
                  DropdownMenuItem(value: 'ACTIVE', child: Text('Active')),
                  DropdownMenuItem(value: 'PENDING', child: Text('Pending')),
                  DropdownMenuItem(value: 'BLOCKED', child: Text('Blocked')),
                ],
                onChanged: (value) {
                  if (value != null) controller.setStatus(value);
                },
              ),
            ),
            SizedBox(width: isWide ? gap : 0, height: isWide ? 0 : 12),
            SizedBox(
              width: isWide ? 120 : double.infinity,
              child: OutlinedButton.icon(
                onPressed: controller.clearFilters,
                icon: const Icon(Icons.restart_alt_rounded),
                label: const Text('Reset'),
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

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final AdminUsersController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller.searchController,
      onSubmitted: controller.loadUsers,
      decoration: InputDecoration(
        hintText: 'Search by name, email...',
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
    );
  }
}

class _FilterDropdown<T> extends StatelessWidget {
  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
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
    );
  }
}
