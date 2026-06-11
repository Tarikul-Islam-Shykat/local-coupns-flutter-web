import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../global/loading.dart';
import '../../../../global/responsive.dart';
import '../controller/admin_users_controller.dart';
import '../model/admin_user_model.dart';

class ConsumersManagementView extends GetView<AdminUsersController> {
  const ConsumersManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final info = context.responsive;
      final users = controller.users;
      final meta = controller.meta.value;

      return SingleChildScrollView(
        padding: EdgeInsets.all(
          info.value(mobile: 16, tablet: 18, desktop: 24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(info: info),
            const SizedBox(height: 18),
            _FilterCard(controller: controller),
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
                  : users.isEmpty
                  ? const _EmptyState()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'All ${controller.displaySectionLabel} (${meta?.total ?? users.length})',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 18),
                        if (info.isDesktop)
                          _UsersTable(users: users)
                        else
                          _UsersCards(users: users),
                      ],
                    ),
            ),
          ],
        ),
      );
    });
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.info});

  final ResponsiveInfo info;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Consumers Management',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage consumer list',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0xFFE7EDF3)),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.notifications_none_rounded,
                color: Colors.black87,
              ),
              Positioned(
                top: 11,
                right: 11,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF4000),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FilterCard extends StatelessWidget {
  const _FilterCard({required this.controller});

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

class _UsersTable extends StatelessWidget {
  const _UsersTable({required this.users});

  final List<AdminUser> users;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: const WidgetStatePropertyAll<Color>(Color(0xFFF8FAFC)),
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('Redemptions')),
          DataColumn(label: Text('Actions')),
        ],
        rows: users
            .map(
              (user) => DataRow(
                cells: [
                  DataCell(_NameCell(user: user)),
                  DataCell(Text(user.email)),
                  DataCell(Text(user.redemptions.toString())),
                  DataCell(
                    OutlinedButton.icon(
                      onPressed: () => Get.snackbar(
                        user.fullName,
                        '${user.role} • ${user.status}',
                      ),
                      icon: const Icon(Icons.visibility_outlined, size: 16),
                      label: const Text('View'),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

class _UsersCards extends StatelessWidget {
  const _UsersCards({required this.users});

  final List<AdminUser> users;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: users
          .map(
            (user) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _UserCard(user: user),
            ),
          )
          .toList(),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({required this.user});

  final AdminUser user;

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
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFFF4000),
                child: Text(
                  user.initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: _NameCell(user: user)),
            ],
          ),
          const SizedBox(height: 12),
          Text(user.email, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 6),
          Text('Redemptions: ${user.redemptions}'),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: () =>
                  Get.snackbar(user.fullName, '${user.role} • ${user.status}'),
              icon: const Icon(Icons.visibility_outlined, size: 16),
              label: const Text('View'),
            ),
          ),
        ],
      ),
    );
  }
}

class _NameCell extends StatelessWidget {
  const _NameCell({required this.user});

  final AdminUser user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          user.fullName,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text('@${user.userName}', style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

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
            Icons.search_off_rounded,
            size: 44,
            color: Color(0xFFFF4000),
          ),
          const SizedBox(height: 12),
          Text('No users found', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(
            'Try changing the search, role, or status filters.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
