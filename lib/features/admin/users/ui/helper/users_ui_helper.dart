import '../../model/admin_user_model.dart';

String prettyCategory(String value) {
  if (value.trim().isEmpty || value == '-') {
    return '-';
  }

  return value
      .split('_')
      .map(
        (part) => part.isEmpty
            ? part
            : '${part[0]}${part.substring(1).toLowerCase()}',
      )
      .join(' ');
}

String sectionLabelLower(String value) {
  if (value.trim().isEmpty) {
    return 'items';
  }
  return value.toLowerCase();
}

String userPrimaryLabel(AdminUser user, bool isMerchantMode) {
  return isMerchantMode ? user.businessName : user.fullName;
}

String userSecondaryLabel(AdminUser user, bool isMerchantMode) {
  return isMerchantMode ? user.fullName : '@${user.userName}';
}

String userStatusSummary(AdminUser user, bool isMerchantMode) {
  return isMerchantMode
      ? '${user.status} • ${user.subscriptionPlan}'
      : '${user.role} • ${user.status}';
}
