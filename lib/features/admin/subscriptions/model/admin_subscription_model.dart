class AdminSubscriptionsResponse {
  const AdminSubscriptionsResponse({
    required this.success,
    required this.message,
    required this.plans,
  });

  final bool success;
  final String? message;
  final List<AdminSubscriptionPlan> plans;

  factory AdminSubscriptionsResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final list = _extractList(rawData);

    return AdminSubscriptionsResponse(
      success: json['success'] == true,
      message: json['message']?.toString(),
      plans: list
          .map((item) => AdminSubscriptionPlan.fromJson(_map(item)))
          .toList(),
    );
  }

  static List<dynamic> _extractList(dynamic rawData) {
    if (rawData is List) {
      return rawData;
    }
    if (rawData is Map && rawData['data'] is List) {
      return List<dynamic>.from(rawData['data'] as List);
    }
    return <dynamic>[];
  }
}

class AdminSubscriptionPlan {
  const AdminSubscriptionPlan({
    required this.id,
    required this.planName,
    required this.planType,
    required this.facilities,
    required this.appleProductId,
    required this.price,
    required this.duration,
    required this.details,
    required this.status,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String planName;
  final String planType;
  final List<String> facilities;
  final String appleProductId;
  final double price;
  final int duration;
  final String details;
  final String status;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory AdminSubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return AdminSubscriptionPlan(
      id: json['id']?.toString() ?? '',
      planName: (json['planName'] ?? json['name'] ?? '').toString(),
      planType: (json['planType'] ?? '').toString(),
      facilities: _parseFacilities(json['facilities']),
      appleProductId: (json['apple_product_id'] ?? json['appleProductId'] ?? '')
          .toString(),
      price: _doubleValue(json['price']),
      duration: _intValue(json['duration']),
      details: json['details']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      isActive: json['isActive'] == true,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
    );
  }

  String get category =>
      planType.trim().isEmpty ? 'Uncategorized' : planType.trim();
}

Map<String, dynamic> _map(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  return <String, dynamic>{};
}

List<String> _parseFacilities(dynamic value) {
  if (value is List) {
    return value.map((item) => item.toString()).toList();
  }
  if (value is String && value.trim().isNotEmpty) {
    return [value.trim()];
  }
  return <String>[];
}

int _intValue(dynamic value) {
  if (value is int) {
    return value;
  }
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _doubleValue(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }
  return double.tryParse(value?.toString() ?? '') ?? 0;
}
