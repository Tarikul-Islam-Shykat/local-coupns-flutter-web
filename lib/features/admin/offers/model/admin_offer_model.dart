class AdminOffersResponse {
  const AdminOffersResponse({
    required this.meta,
    required this.offers,
    this.message,
  });

  final OfferMeta meta;
  final List<AdminOffer> offers;
  final String? message;

  factory AdminOffersResponse.fromJson(Map<String, dynamic> json) {
    final data = _map(json['data']);
    return AdminOffersResponse(
      meta: OfferMeta.fromJson(_map(data['meta'])),
      offers: _list(
        data['data'],
      ).map((e) => AdminOffer.fromJson(_map(e))).toList(),
      message: data['message']?.toString() ?? json['message']?.toString(),
    );
  }
}

class OfferMeta {
  const OfferMeta({
    required this.total,
    required this.page,
    required this.limit,
  });

  final int total;
  final int page;
  final int limit;

  factory OfferMeta.fromJson(Map<String, dynamic> json) {
    return OfferMeta(
      total: _int(json['total']),
      page: _int(json['page']),
      limit: _int(json['limit']),
    );
  }
}

class AdminOffer {
  const AdminOffer({
    required this.id,
    required this.userId,
    required this.businessName,
    required this.title,
    required this.description,
    required this.category,
    required this.image,
    required this.redemptionType,
    required this.quality,
    required this.expiresAt,
    required this.redemptionInstructions,
    required this.termsAndConditions,
    required this.offerType,
    required this.status,
    required this.totalViews,
    required this.totalActivations,
    required this.totalSaves,
    required this.totalShares,
    required this.totalRedemptions,
    required this.totalCalls,
    required this.totalDirections,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  final String id;
  final String userId;
  final String businessName;
  final String title;
  final String description;
  final String category;
  final String? image;
  final String redemptionType;
  final String quality;
  final DateTime? expiresAt;
  final String redemptionInstructions;
  final String termsAndConditions;
  final String offerType;
  final String status;
  final int totalViews;
  final int totalActivations;
  final int totalSaves;
  final int totalShares;
  final int totalRedemptions;
  final int totalCalls;
  final int totalDirections;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final OfferUser user;

  factory AdminOffer.fromJson(Map<String, dynamic> json) {
    return AdminOffer(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      businessName: json['bussinessName']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      image: json['image']?.toString(),
      redemptionType: json['redemptionType']?.toString() ?? '',
      quality: json['quality']?.toString() ?? '',
      expiresAt: DateTime.tryParse(json['expiresAt']?.toString() ?? ''),
      redemptionInstructions: json['redemptionInstructions']?.toString() ?? '',
      termsAndConditions: json['termsAndConditions']?.toString() ?? '',
      offerType: json['offerType']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      totalViews: _int(json['totalViews']),
      totalActivations: _int(json['totalActivations']),
      totalSaves: _int(json['totalSaves']),
      totalShares: _int(json['totalShares']),
      totalRedemptions: _int(json['totalRedemptions']),
      totalCalls: _int(json['totalCalls']),
      totalDirections: _int(json['totalDirections']),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
      user: OfferUser.fromJson(_map(json['user'])),
    );
  }

  bool get isPending => status.toUpperCase() == 'PENDING';
}

class OfferUser {
  const OfferUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.profileImage,
    required this.profiles,
  });

  final String id;
  final String fullName;
  final String email;
  final String? profileImage;
  final List<OfferUserProfile> profiles;

  factory OfferUser.fromJson(Map<String, dynamic> json) {
    return OfferUser(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      profileImage: json['profileImage']?.toString(),
      profiles: _list(
        json['profiles'],
      ).map((e) => OfferUserProfile.fromJson(_map(e))).toList(),
    );
  }
}

class OfferUserProfile {
  const OfferUserProfile({
    required this.id,
    required this.businessName,
    required this.logo,
    required this.category,
    required this.address,
    required this.city,
    required this.website,
    required this.phone,
  });

  final String id;
  final String businessName;
  final String? logo;
  final String category;
  final String address;
  final String city;
  final String website;
  final String phone;

  factory OfferUserProfile.fromJson(Map<String, dynamic> json) {
    return OfferUserProfile(
      id: json['id']?.toString() ?? '',
      businessName: json['bussinessName']?.toString() ?? '',
      logo: json['logo']?.toString(),
      category: json['category']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      website: json['website']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
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
