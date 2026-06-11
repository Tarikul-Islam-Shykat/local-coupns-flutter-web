import 'dart:math';

class AdminUsersResponse {
  final UserMeta meta;
  final List<AdminUser> users;
  final String? message;

  const AdminUsersResponse({
    required this.meta,
    required this.users,
    this.message,
  });

  factory AdminUsersResponse.fromJson(Map<String, dynamic> json) {
    final data = _map(json['data']);
    return AdminUsersResponse(
      meta: UserMeta.fromJson(_map(data['meta'])),
      users: _list(
        data['data'],
      ).map((e) => AdminUser.fromJson(_map(e))).toList(),
      message: data['message']?.toString() ?? json['message']?.toString(),
    );
  }
}

class UserMeta {
  final int page;
  final int limit;
  final int total;

  const UserMeta({
    required this.page,
    required this.limit,
    required this.total,
  });

  factory UserMeta.fromJson(Map<String, dynamic> json) {
    return UserMeta(
      page: _int(json['page']),
      limit: _int(json['limit']),
      total: _int(json['total']),
    );
  }
}

class AdminUser {
  final String id;
  final String fullName;
  final String userName;
  final String email;
  final String? profileImage;
  final String role;
  final String status;
  final bool emailVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<UserProfile> profiles;
  final List<dynamic> userSubscriptions;

  const AdminUser({
    required this.id,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.profileImage,
    required this.role,
    required this.status,
    required this.emailVerified,
    required this.createdAt,
    required this.updatedAt,
    required this.profiles,
    required this.userSubscriptions,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      userName: json['userName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      profileImage: json['profileImage']?.toString(),
      role: json['role']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      emailVerified: json['emailVerified'] == true,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
      profiles: _list(
        json['profiles'],
      ).map((e) => UserProfile.fromJson(_map(e))).toList(),
      userSubscriptions: _list(json['userSubscriptions']),
    );
  }

  int get redemptions {
    if (profiles.isEmpty) return 0;
    return profiles.first.redemption;
  }

  String get initial {
    final trimmed = fullName.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) return _firstChar(parts.first);
    return '${_firstChar(parts.first)}${_firstChar(parts[1])}';
  }
}

class UserProfile {
  final String bussinessName;
  final String category;
  final int activeOffers;
  final int redemption;
  final int ltv;

  const UserProfile({
    required this.bussinessName,
    required this.category,
    required this.activeOffers,
    required this.redemption,
    required this.ltv,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      bussinessName: json['bussinessName']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      activeOffers: _int(json['activeOffers']),
      redemption: _int(json['redemption']),
      ltv: _int(json['LTV']),
    );
  }
}

Map<String, dynamic> _map(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  return <String, dynamic>{};
}

List<dynamic> _list(dynamic value) {
  if (value is List) return value;
  return <dynamic>[];
}

int _int(dynamic value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String _firstChar(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return '?';
  return trimmed.substring(0, min(1, trimmed.length)).toUpperCase();
}
