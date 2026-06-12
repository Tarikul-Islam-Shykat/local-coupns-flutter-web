import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../global/loading.dart';
import '../../model/admin_user_model.dart';
import '../helper/users_ui_helper.dart';

class UsersResultsPanel extends StatelessWidget {
  const UsersResultsPanel({
    super.key,
    required this.title,
    required this.users,
    required this.isLoading,
    required this.isMerchantMode,
    required this.isDesktop,
    required this.emptyTitle,
  });

  final String title;
  final List<AdminUser> users;
  final bool isLoading;
  final bool isMerchantMode;
  final bool isDesktop;
  final String emptyTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      child: isLoading
          ? loading(value: 34)
          : users.isEmpty
          ? _EmptyState(title: emptyTitle)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 18),
                Expanded(
                  child: isDesktop
                      ? _UsersDesktopList(
                          users: users,
                          isMerchantMode: isMerchantMode,
                        )
                      : _UsersMobileList(
                          users: users,
                          isMerchantMode: isMerchantMode,
                        ),
                ),
              ],
            ),
    );
  }
}

class _UsersDesktopList extends StatelessWidget {
  const _UsersDesktopList({required this.users, required this.isMerchantMode});

  final List<AdminUser> users;
  final bool isMerchantMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7EDF3)),
      ),
      child: Column(
        children: [
          _DesktopHeaderRow(isMerchantMode: isMerchantMode),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          Expanded(
            child: ListView.separated(
              itemCount: users.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, color: Color(0xFFE2E8F0)),
              itemBuilder: (context, index) {
                return _DesktopDataRow(
                  user: users[index],
                  isMerchantMode: isMerchantMode,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopHeaderRow extends StatelessWidget {
  const _DesktopHeaderRow({required this.isMerchantMode});

  final bool isMerchantMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: isMerchantMode
            ? const [
                _HeaderCell(label: 'Merchant', flex: 4),
                _HeaderCell(label: 'Category', flex: 2),
                _HeaderCell(label: 'Plan', flex: 2),
                _HeaderCell(label: 'LTV', flex: 1),
                _HeaderCell(label: 'Verification', flex: 2),
                _HeaderCell(label: 'Active Offers', flex: 1),
                _HeaderCell(label: 'Redemptions', flex: 1),
                _HeaderCell(label: 'Actions', flex: 1),
              ]
            : const [
                _HeaderCell(label: 'Name', flex: 4),
                _HeaderCell(label: 'Email', flex: 5),
                _HeaderCell(label: 'Redemptions', flex: 2),
                _HeaderCell(label: 'Actions', flex: 1),
              ],
      ),
    );
  }
}

class _DesktopDataRow extends StatelessWidget {
  const _DesktopDataRow({required this.user, required this.isMerchantMode});

  final AdminUser user;
  final bool isMerchantMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: isMerchantMode
            ? [
                Expanded(
                  flex: 4,
                  child: _NameCell(user: user, isMerchantMode: true),
                ),
                Expanded(
                  flex: 2,
                  child: Text(prettyCategory(user.categoryLabel)),
                ),
                Expanded(
                  flex: 2,
                  child: _PlanPill(plan: user.subscriptionPlan),
                ),
                Expanded(flex: 1, child: Text(merchantLtvLabel(user))),
                Expanded(flex: 2, child: _VerificationPill(user: user)),
                Expanded(flex: 1, child: Text(user.activeOffers.toString())),
                Expanded(flex: 1, child: Text(user.redemptions.toString())),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _ViewButton(user: user, isMerchantMode: true),
                  ),
                ),
              ]
            : [
                Expanded(
                  flex: 4,
                  child: Text(
                    user.fullName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(flex: 5, child: Text(user.email)),
                Expanded(flex: 2, child: Text(user.redemptions.toString())),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _ViewButton(user: user, isMerchantMode: false),
                  ),
                ),
              ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({required this.label, required this.flex});

  final String label;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: const Color(0xFF475569),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PlanPill extends StatelessWidget {
  const _PlanPill({required this.plan});

  final String plan;

  @override
  Widget build(BuildContext context) {
    final normalized = plan.toLowerCase();
    final isSpotlight = normalized.contains('spot');

    return _InfoPill(
      label: plan,
      background: isSpotlight
          ? const Color(0xFFFFE9DD)
          : const Color(0xFFE8EEFF),
      foreground: isSpotlight
          ? const Color(0xFFFF5A1F)
          : const Color(0xFF3B82F6),
    );
  }
}

class _VerificationPill extends StatelessWidget {
  const _VerificationPill({required this.user});

  final AdminUser user;

  @override
  Widget build(BuildContext context) {
    final isVerified = user.emailVerified;

    return _InfoPill(
      label: merchantVerificationLabel(user),
      background: isVerified
          ? const Color(0xFFE8F9E8)
          : const Color(0xFFFFF4D6),
      foreground: isVerified
          ? const Color(0xFF22C55E)
          : const Color(0xFFCA8A04),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: foreground,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _UsersMobileList extends StatelessWidget {
  const _UsersMobileList({required this.users, required this.isMerchantMode});

  final List<AdminUser> users;
  final bool isMerchantMode;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: users.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _UserCard(user: users[index], isMerchantMode: isMerchantMode);
      },
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({required this.user, required this.isMerchantMode});

  final AdminUser user;
  final bool isMerchantMode;

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
              Expanded(
                child: _NameCell(user: user, isMerchantMode: isMerchantMode),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (isMerchantMode) ...[
            Text(user.email, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 6),
            Text('Business: ${user.businessName}'),
            const SizedBox(height: 4),
            Text('Category: ${prettyCategory(user.categoryLabel)}'),
            const SizedBox(height: 4),
            Text('Active offers: ${user.activeOffers}'),
            const SizedBox(height: 4),
            Text('Plan: ${user.subscriptionPlan}'),
          ] else ...[
            Text(user.email, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 6),
            Text('Redemptions: ${user.redemptions}'),
          ],
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: _ViewButton(user: user, isMerchantMode: isMerchantMode),
          ),
        ],
      ),
    );
  }
}

class _NameCell extends StatelessWidget {
  const _NameCell({required this.user, required this.isMerchantMode});

  final AdminUser user;
  final bool isMerchantMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          userPrimaryLabel(user, isMerchantMode),
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(
          userSecondaryLabel(user, isMerchantMode),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _ViewButton extends StatelessWidget {
  const _ViewButton({required this.user, required this.isMerchantMode});

  final AdminUser user;
  final bool isMerchantMode;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => Get.snackbar(
        userPrimaryLabel(user, isMerchantMode),
        userStatusSummary(user, isMerchantMode),
      ),
      icon: const Icon(Icons.visibility_outlined, size: 16),
      label: const Text('View'),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 44,
            color: Color(0xFFFF4000),
          ),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
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
