import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../global/issue_log_panel.dart';
import '../../../../global/loading.dart';
import '../../../../global/responsive.dart';
import '../../../../service/storage/local_storage/local_storage.dart';
import '../../../../service/storage/secure/storage.dart';
import '../../dashboard/controller/admin_dashboard_controller.dart';
import '../../dashboard/model/admin_dashboard_model.dart';
import '../../users/ui/consumers_management_view.dart';

class AdminDashboardPage extends GetView<AdminDashboardController> {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Obx(
        () => _DashboardDrawer(
          selectedTab: controller.selectedTab.value,
          onSelectTab: controller.selectTab,
        ),
      ),
      body: SafeArea(
        child: ResponsiveLayout(
          builder: (context, info) {
            final showSidebar = info.isDesktop;

            return Obx(() {
              final dashboard = controller.overview.value;
              final isDashboard = controller.selectedTab.value == 0;
              final isUsers = controller.selectedTab.value == 1;
              final title = isDashboard
                  ? 'Dashboard'
                  : isUsers
                  ? 'Users Management'
                  : 'Support';
              final subtitle = isDashboard
                  ? 'Overview and analytics'
                  : isUsers
                  ? 'Manage all users'
                  : 'Issue tracking and support logs';

              return Row(
                children: [
                  if (showSidebar)
                    _Sidebar(
                      selectedTab: controller.selectedTab.value,
                      onSelectTab: controller.selectTab,
                    ),
                  Expanded(
                    child: Column(
                      children: [
                        _TopBar(
                          showMenu: !showSidebar,
                          title: title,
                          subtitle: subtitle,
                        ),
                        Expanded(
                          child: controller.selectedTab.value == 0
                              ? controller.isLoading.value
                                    ? loading(value: 38)
                                    : dashboard != null
                                    ? _DashboardContent(
                                        dashboard: dashboard,
                                        info: info,
                                      )
                                    : _DashboardStatusView(
                                        message:
                                            controller
                                                .dashboardErrorMessage
                                                .value ??
                                            'Dashboard data could not be loaded.',
                                        isUnauthorized:
                                            controller.isUnauthorized,
                                        onRetry: controller.fetchDashboard,
                                      )
                              : isUsers
                              ? const ConsumersManagementView()
                              : const _SupportView(),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            });
          },
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.showMenu,
    required this.title,
    required this.subtitle,
  });

  final bool showMenu;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE7EDF3))),
      ),
      child: Row(
        children: [
          if (showMenu)
            Builder(
              builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.menu_rounded),
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 2),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const Spacer(),
          const _VersionBadge(),
          const SizedBox(width: 12),
          const _ProfilePill(),
        ],
      ),
    );
  }
}

class _VersionBadge extends StatelessWidget {
  const _VersionBadge();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final timeLabel =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE7EDF3)),
      ),
      child: Text(
        'v1.0 • $timeLabel',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: const Color(0xFF0F172A),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ProfilePill extends StatelessWidget {
  const _ProfilePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E8),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Color(0xFFFF4000),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_rounded, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Admin',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                'Dashboard owner',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.selectedTab, required this.onSelectTab});

  final int selectedTab;
  final void Function(int index) onSelectTab;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border(right: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Column(
        children: [
          const _SidebarBrand(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _SidebarItem(
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  selected: selectedTab == 0,
                  onTap: () => onSelectTab(0),
                ),
                _SidebarItem(
                  icon: Icons.storefront_outlined,
                  label: 'Merchants',
                  onTap: () => _comingSoon(),
                ),
                _SidebarItem(
                  icon: Icons.people_outline_rounded,
                  label: 'Users',
                  selected: selectedTab == 1,
                  onTap: () => onSelectTab(1),
                ),
                _SidebarItem(
                  icon: Icons.receipt_long_outlined,
                  label: 'Redemptions',
                  onTap: () => _comingSoon(),
                ),
                _SidebarItem(
                  icon: Icons.subscriptions_outlined,
                  label: 'Subscriptions',
                  onTap: () => _comingSoon(),
                ),
                _SidebarItem(
                  icon: Icons.report_gmailerrorred_outlined,
                  label: 'Support',
                  selected: selectedTab == 2,
                  onTap: () => onSelectTab(2),
                ),
              ],
            ),
          ),
          const _SidebarFooter(),
        ],
      ),
    );
  }

  void _comingSoon() {
    Get.snackbar('Coming soon', 'This section is not built yet.');
  }
}

class _SupportView extends StatelessWidget {
  const _SupportView();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1100;

        if (isWide) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: const [
                Expanded(child: _SupportIntro()),
                SizedBox(width: 18),
                SizedBox(width: 380, child: IssueLogPanel()),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              _SupportIntro(),
              SizedBox(height: 18),
              Expanded(child: IssueLogPanel(compact: true)),
            ],
          ),
        );
      },
    );
  }
}

class _SupportIntro extends StatelessWidget {
  const _SupportIntro();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final updatedLabel =
        'Updated ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE7EDF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Support',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Use this tab to inspect dashboard, users, and API logs. When an image URL is attached, it will appear inside the log card.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _InfoChip(label: 'Version 1.0'),
              _InfoChip(label: updatedLabel),
              _InfoChip(label: 'Live log feed'),
            ],
          ),
          const SizedBox(height: 18),
          const _TokenDebugCard(),
        ],
      ),
    );
  }
}

class _TokenDebugCard extends StatefulWidget {
  const _TokenDebugCard();

  @override
  State<_TokenDebugCard> createState() => _TokenDebugCardState();
}

class _TokenDebugCardState extends State<_TokenDebugCard> {
  final _localService = LocalService();
  final _secureStorage = SecureStorageService();

  String? _localToken;
  String? _secureToken;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTokens();
  }

  Future<void> _loadTokens() async {
    final localToken = await _localService.getValue<String>(
      PreferenceKey.token,
    );
    final secureToken = await _secureStorage.get(SecureStorageService.token);

    if (!mounted) {
      return;
    }

    setState(() {
      _localToken = localToken;
      _secureToken = secureToken;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
            children: [
              Expanded(
                child: Text(
                  'Stored Token Debug',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                onPressed: _loadTokens,
                tooltip: 'Refresh token values',
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Use this to check what token is currently stored before the dashboard request runs.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: LinearProgressIndicator(),
            )
          else ...[
            _TokenValueRow(
              label: 'Local storage',
              storageKey: PreferenceKey.token.key,
              value: _localToken,
            ),
            const SizedBox(height: 12),
            _TokenValueRow(
              label: 'Secure storage',
              storageKey: SecureStorageService.token,
              value: _secureToken,
            ),
          ],
        ],
      ),
    );
  }
}

class _TokenValueRow extends StatelessWidget {
  const _TokenValueRow({
    required this.label,
    required this.storageKey,
    required this.value,
  });

  final String label;
  final String storageKey;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final text = (value == null || value!.trim().isEmpty) ? 'Missing' : value!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7EDF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Key: $storageKey',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: text == 'Missing'
                    ? null
                    : () async {
                        await Clipboard.setData(ClipboardData(text: text));
                        Get.snackbar(
                          'Copied',
                          '$label token copied.',
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 2),
                        );
                      },
                tooltip: 'Copy token',
                icon: const Icon(Icons.copy_rounded),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SelectableText(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              height: 1.45,
              color: const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
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
        color: const Color(0xFFFFF3E8),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFFFD6BF)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: const Color(0xFFFF4000),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _DashboardDrawer extends StatelessWidget {
  const _DashboardDrawer({
    required this.selectedTab,
    required this.onSelectTab,
  });

  final int selectedTab;
  final void Function(int index) onSelectTab;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: _Sidebar(selectedTab: selectedTab, onSelectTab: onSelectTab),
    );
  }
}

class _SidebarBrand extends StatelessWidget {
  const _SidebarBrand();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFF4000),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.local_offer_rounded, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Local Coupons',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Admin Panel',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: selected ? const Color(0x1AFF4000) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        dense: true,
        onTap: onTap,
        leading: Icon(
          icon,
          color: selected ? const Color(0xFFFF4000) : Colors.white70,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.white70,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        trailing: selected
            ? const Icon(Icons.chevron_right_rounded, color: Color(0xFFFF4000))
            : null,
      ),
    );
  }
}

class _SidebarFooter extends StatelessWidget {
  const _SidebarFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.admin_panel_settings, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Admin Account',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Signed in',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111C31),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [const _BuildStatusBlock()],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardStatusView extends StatelessWidget {
  const _DashboardStatusView({
    required this.message,
    required this.isUnauthorized,
    required this.onRetry,
  });

  final String message;
  final bool isUnauthorized;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final title = isUnauthorized
        ? 'You are not authorized'
        : 'Dashboard unavailable';
    final accent = isUnauthorized
        ? const Color(0xFFDC2626)
        : const Color(0xFFFF4000);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Container(
            padding: const EdgeInsets.all(24),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isUnauthorized
                        ? Icons.lock_outline_rounded
                        : Icons.error_outline_rounded,
                    color: accent,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                SelectableText(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF475569),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Try again'),
                    ),
                    if (isUnauthorized)
                      OutlinedButton.icon(
                        onPressed: () =>
                            Get.find<AdminDashboardController>().selectTab(2),
                        icon: const Icon(Icons.bug_report_outlined),
                        label: const Text('Open support log'),
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

class _BuildStatusBlock extends StatefulWidget {
  const _BuildStatusBlock();

  @override
  State<_BuildStatusBlock> createState() => _BuildStatusBlockState();
}

class _BuildStatusBlockState extends State<_BuildStatusBlock> {
  late final Future<PackageInfo> _packageInfo = PackageInfo.fromPlatform();
  late final DateTime _loadedAt = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: _packageInfo,
      builder: (context, snapshot) {
        final packageInfo = snapshot.data;
        final versionLabel = packageInfo == null
            ? 'Build loading...'
            : 'Build v${packageInfo.version}+${packageInfo.buildNumber}';
        final loadedLabel =
            'Loaded: ${DateFormat('dd MMM yyyy, hh:mm a').format(_loadedAt)}';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              versionLabel,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: const Color(0xFFFF4000),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              loadedLabel,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: Colors.white70),
            ),
          ],
        );
      },
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.dashboard, required this.info});

  final AdminDashboardModel dashboard;
  final ResponsiveInfo info;

  @override
  Widget build(BuildContext context) {
    final pagePadding = EdgeInsets.all(
      info.value(mobile: 16, tablet: 20, desktop: 24),
    );

    return SingleChildScrollView(
      padding: pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MetricGrid(cards: dashboard.cards, info: info),
          const SizedBox(height: 24),
          _ChartsGrid(dashboard: dashboard, info: info),
          const SizedBox(height: 24),
          _UsageCard(summary: dashboard.usageSummary, info: info),
        ],
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.cards, required this.info});

  final DashboardCards cards;
  final ResponsiveInfo info;

  @override
  Widget build(BuildContext context) {
    final items = <_MetricTileData>[
      _MetricTileData(
        title: 'Total Revenue',
        value: cards.totalRevenue.value.toString(),
        growth: cards.totalRevenue.growthFromLastMonth,
        icon: Icons.payments_outlined,
        color: const Color(0xFF2563EB),
      ),
      _MetricTileData(
        title: 'Merchants',
        value: cards.totalMerchants.value.toString(),
        growth: cards.totalMerchants.growthFromLastMonth,
        icon: Icons.storefront_outlined,
        color: const Color(0xFF10B981),
      ),
      _MetricTileData(
        title: 'Consumers',
        value: cards.totalConsumers.value.toString(),
        growth: cards.totalConsumers.growthFromLastMonth,
        icon: Icons.people_outline_rounded,
        color: const Color(0xFFF97316),
      ),
      _MetricTileData(
        title: 'Redemptions',
        value: cards.totalRedemptions.value.toString(),
        growth: cards.totalRedemptions.growthFromLastMonth,
        icon: Icons.redeem_outlined,
        color: const Color(0xFF8B5CF6),
      ),
      _MetricTileData(
        title: 'Active Subscriptions',
        value: cards.activeSubscriptions.value.toString(),
        growth: cards.activeSubscriptions.growthFromLastMonth,
        icon: Icons.subscriptions_outlined,
        color: const Color(0xFF14B8A6),
      ),
      _MetricTileData(
        title: 'Issues',
        value: cards.issues.value.toString(),
        growth: cards.issues.growthFromLastMonth,
        icon: Icons.report_gmailerrorred_outlined,
        color: const Color(0xFFEF4444),
      ),
    ];

    final crossAxisCount = info.value<int>(mobile: 1, tablet: 2, desktop: 3);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: info.isMobile ? 1.45 : 1.7,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return _MetricTile(data: item);
      },
    );
  }
}

class _MetricTileData {
  const _MetricTileData({
    required this.title,
    required this.value,
    required this.growth,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final num growth;
  final IconData icon;
  final Color color;
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.data});

  final _MetricTileData data;

  @override
  Widget build(BuildContext context) {
    final positive = data.growth >= 0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE7EDF3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: data.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(data.icon, color: data.color),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: positive
                      ? const Color(0xFFE8FFF4)
                      : const Color(0xFFFFEEEE),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${positive ? '+' : ''}${data.growth.toStringAsFixed(data.growth is int ? 0 : 2)}%',
                  style: TextStyle(
                    color: positive
                        ? const Color(0xFF059669)
                        : const Color(0xFFDC2626),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            data.value,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(data.title, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _ChartsGrid extends StatelessWidget {
  const _ChartsGrid({required this.dashboard, required this.info});

  final AdminDashboardModel dashboard;
  final ResponsiveInfo info;

  @override
  Widget build(BuildContext context) {
    if (info.isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _ChartCard(
              title: 'Monthly Revenue',
              subtitle: 'Core plan vs Spotlight plan',
              child: _MonthlyRevenueChart(data: dashboard.monthlyRevenue),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _ChartCard(
              title: 'Monthly Signups',
              subtitle: 'Merchants vs Consumers',
              child: _MonthlySignupsChart(data: dashboard.monthlySignups),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        _ChartCard(
          title: 'Monthly Revenue',
          subtitle: 'Core plan vs Spotlight plan',
          child: _MonthlyRevenueChart(data: dashboard.monthlyRevenue),
        ),
        const SizedBox(height: 16),
        _ChartCard(
          title: 'Monthly Signups',
          subtitle: 'Merchants vs Consumers',
          child: _MonthlySignupsChart(data: dashboard.monthlySignups),
        ),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE7EDF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _MonthlyRevenueChart extends StatelessWidget {
  const _MonthlyRevenueChart({required this.data});

  final List<RevenueByMonth> data;

  @override
  Widget build(BuildContext context) {
    final maxValue = data.fold<num>(
      0,
      (max, item) => [
        max,
        item.corePlan,
        item.spotlightPlan,
      ].reduce((a, b) => a > b ? a : b),
    );

    return Column(
      children: [
        const _LegendRow(
          leftColor: Color(0xFF2563EB),
          leftLabel: 'Core',
          rightColor: Color(0xFFF97316),
          rightLabel: 'Spotlight',
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: data.map((month) {
              final coreHeight = maxValue == 0
                  ? 0.0
                  : month.corePlan / maxValue;
              final spotlightHeight = maxValue == 0
                  ? 0.0
                  : month.spotlightPlan / maxValue;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 180,
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    _Bar(
                                      heightFactor: coreHeight,
                                      color: const Color(0xFF2563EB),
                                    ),
                                    const SizedBox(width: 6),
                                    _Bar(
                                      heightFactor: spotlightHeight,
                                      color: const Color(0xFFF97316),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              month.month,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MonthlySignupsChart extends StatelessWidget {
  const _MonthlySignupsChart({required this.data});

  final List<SignupByMonth> data;

  @override
  Widget build(BuildContext context) {
    final maxValue = data.fold<num>(
      0,
      (max, item) =>
          [max, item.merchants, item.consumers].reduce((a, b) => a > b ? a : b),
    );

    return Column(
      children: [
        const _LegendRow(
          leftColor: Color(0xFF10B981),
          leftLabel: 'Merchants',
          rightColor: Color(0xFF8B5CF6),
          rightLabel: 'Consumers',
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: data.map((month) {
              final merchantsHeight = maxValue == 0
                  ? 0.0
                  : month.merchants / maxValue;
              final consumersHeight = maxValue == 0
                  ? 0.0
                  : month.consumers / maxValue;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 180,
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    _Bar(
                                      heightFactor: merchantsHeight,
                                      color: const Color(0xFF10B981),
                                    ),
                                    const SizedBox(width: 6),
                                    _Bar(
                                      heightFactor: consumersHeight,
                                      color: const Color(0xFF8B5CF6),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              month.month,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.heightFactor, required this.color});

  final double heightFactor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final height = 16 + (heightFactor * 150);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 18,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.leftColor,
    required this.leftLabel,
    required this.rightColor,
    required this.rightLabel,
  });

  final Color leftColor;
  final String leftLabel;
  final Color rightColor;
  final String rightLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _LegendDot(color: leftColor, label: leftLabel),
        const SizedBox(width: 16),
        _LegendDot(color: rightColor, label: rightLabel),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _UsageCard extends StatelessWidget {
  const _UsageCard({required this.summary, required this.info});

  final UsageSummary summary;
  final ResponsiveInfo info;

  @override
  Widget build(BuildContext context) {
    final usageItems = <_UsageItem>[
      _UsageItem('Offers', summary.totalOffers),
      _UsageItem('Views', summary.views),
      _UsageItem('Saves', summary.saves),
      _UsageItem('Shares', summary.shares),
      _UsageItem('Activations', summary.activations),
      _UsageItem('Redemptions', summary.redemptions),
      _UsageItem('Calls', summary.calls),
      _UsageItem('Directions', summary.directions),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE7EDF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Usage Summary', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            'Activity across offers and redemptions',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: usageItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: info.value<int>(mobile: 2, tablet: 4, desktop: 4),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: info.isMobile ? 1.2 : 1.4,
            ),
            itemBuilder: (context, index) {
              return _UsageTile(item: usageItems[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _UsageItem {
  const _UsageItem(this.label, this.value);

  final String label;
  final num value;
}

class _UsageTile extends StatelessWidget {
  const _UsageTile({required this.item});

  final _UsageItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.value.toString(),
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(item.label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
