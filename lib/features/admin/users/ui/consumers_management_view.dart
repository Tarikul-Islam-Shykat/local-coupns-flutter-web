import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../global/responsive.dart';
import '../controller/admin_users_controller.dart';
import 'helper/users_ui_helper.dart';
import 'widgets/users_filter_card.dart';
import 'widgets/users_header.dart';
import 'widgets/users_results_panel.dart';

class ConsumersManagementView extends GetView<AdminUsersController> {
  const ConsumersManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final info = context.responsive;
      final users = controller.users;
      final meta = controller.meta.value;
      final isMerchantMode = controller.isMerchantMode;

      return Padding(
        padding: EdgeInsets.all(
          info.value(mobile: 16, tablet: 18, desktop: 24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UsersHeader(isMerchantMode: isMerchantMode),
            const SizedBox(height: 18),
            UsersFilterCard(controller: controller),
            const SizedBox(height: 18),
            Expanded(
              child: UsersResultsPanel(
                title:
                    '${controller.displaySectionLabel} (${meta?.total ?? users.length})',
                users: users,
                isLoading: controller.isLoading.value,
                isMerchantMode: isMerchantMode,
                isDesktop: info.isDesktop,
                emptyTitle:
                    'No ${sectionLabelLower(controller.displaySectionLabel)} found',
              ),
            ),
          ],
        ),
      );
    });
  }
}
