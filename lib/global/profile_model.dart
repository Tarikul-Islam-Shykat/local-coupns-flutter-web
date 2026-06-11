class ProfileModel {
  final String? id;
  final String? fullName;
  final String? userName;
  final String? email;
  final String? password;
  final String? location;
  final dynamic phoneNumber;
  final List<String>? interests;
  final int? redemptions;
  final String? coverImage;
  final double? lat;
  final double? lon;
  final String? profileImage;
  final String? bannerImage;
  final String? logo;
  final String? role;
  final String? status;
  final bool? isSocialLogin;
  final bool? emailVerified;
  final bool? isBlocked;
  final bool? isDeleted;
  final bool? isProfileComplete;
  final bool? isApproved;
  final bool? onNotifications;
  final dynamic suspendedUntil;
  final dynamic lastLoginAt;
  final dynamic expirationOtp;
  final dynamic otp;
  final dynamic fcmToken;
  final bool? onBoarding;
  final dynamic accountLink;
  final dynamic stripeAccountId;
  final dynamic customerId;
  final dynamic paymentMethodId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<BusinessProfile>? profiles;

  ProfileModel({
    this.id,
    this.fullName,
    this.userName,
    this.email,
    this.password,
    this.location,
    this.phoneNumber,
    this.interests,
    this.redemptions,
    this.coverImage,
    this.lat,
    this.lon,
    this.profileImage,
    this.bannerImage,
    this.logo,
    this.role,
    this.status,
    this.isSocialLogin,
    this.emailVerified,
    this.isBlocked,
    this.isDeleted,
    this.isProfileComplete,
    this.isApproved,
    this.onNotifications,
    this.suspendedUntil,
    this.lastLoginAt,
    this.expirationOtp,
    this.otp,
    this.fcmToken,
    this.onBoarding,
    this.accountLink,
    this.stripeAccountId,
    this.customerId,
    this.paymentMethodId,
    this.createdAt,
    this.updatedAt,
    this.profiles,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String?,
      fullName: json['fullName'] as String?,
      userName: json['userName'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      location: json['location'] as String?,
      phoneNumber: json['phoneNumber'],
      interests: json['interests'] != null
          ? List<String>.from(json['interests'] as List)
          : null,
      redemptions: json['redemptions'] as int?,
      coverImage: json['coverImage'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      profileImage: json['profileImage'] as String?,
      bannerImage: json['bannerImage'] as String?,
      logo: json['logo'] as String?,
      role: json['role'] as String?,
      status: json['status'] as String?,
      isSocialLogin: json['isSocialLogin'] as bool?,
      emailVerified: json['emailVerified'] as bool?,
      isBlocked: json['isBlocked'] as bool?,
      isDeleted: json['isDeleted'] as bool?,
      isProfileComplete: json['isProfileComplete'] as bool?,
      isApproved: json['isApproved'] as bool?,
      onNotifications: json['onNotifications'] as bool?,
      suspendedUntil: json['suspendedUntil'],
      lastLoginAt: json['lastLoginAt'],
      expirationOtp: json['expirationOtp'],
      otp: json['otp'],
      fcmToken: json['fcmToken'],
      onBoarding: json['onBoarding'] as bool?,
      accountLink: json['accountLink'],
      stripeAccountId: json['stripeAccountId'],
      customerId: json['customerId'],
      paymentMethodId: json['paymentMethodId'],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.tryParse(json['createdAt'].toString()),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.tryParse(json['updatedAt'].toString()),
      profiles: (json['profiles'] as List?)
          ?.map((e) => BusinessProfile.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'location': location,
      'phoneNumber': phoneNumber,
      'interests': interests,
      'redemptions': redemptions,
      'coverImage': coverImage,
      'lat': lat,
      'lon': lon,
      'profileImage': profileImage,
      'bannerImage': bannerImage,
      'logo': logo,
      'role': role,
      'status': status,
      'isSocialLogin': isSocialLogin,
      'emailVerified': emailVerified,
      'isBlocked': isBlocked,
      'isDeleted': isDeleted,
      'isProfileComplete': isProfileComplete,
      'isApproved': isApproved,
      'onNotifications': onNotifications,
      'suspendedUntil': suspendedUntil,
      'lastLoginAt': lastLoginAt,
      'expirationOtp': expirationOtp,
      'otp': otp,
      'fcmToken': fcmToken,
      'onBoarding': onBoarding,
      'accountLink': accountLink,
      'stripeAccountId': stripeAccountId,
      'customerId': customerId,
      'paymentMethodId': paymentMethodId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'profiles': profiles?.map((x) => x.toJson()).toList(),
    };
  }
}

class BusinessProfile {
  final String? id;
  final String? userId;
  final String? bussinessName;
  final String? logo;
  final String? address;
  final String? city;
  final String? category;
  final String? website;
  final String? phone;
  final int? activeOffers;
  final int? redemption;
  final bool? isSubscribed;
  final int? ltv;
  final bool? isApproved;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BusinessProfile({
    this.id,
    this.userId,
    this.bussinessName,
    this.logo,
    this.address,
    this.city,
    this.category,
    this.website,
    this.phone,
    this.activeOffers,
    this.redemption,
    this.isSubscribed,
    this.ltv,
    this.isApproved,
    this.createdAt,
    this.updatedAt,
  });

  factory BusinessProfile.fromJson(Map<String, dynamic> json) {
    return BusinessProfile(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      bussinessName: json['bussinessName'] as String?,
      logo: json['logo'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      category: json['category'] as String?,
      website: json['website'] as String?,
      phone: json['phone'] as String?,
      activeOffers: json['activeOffers'] as int?,
      redemption: json['redemption'] as int?,
      isSubscribed: json['isSubscribed'] as bool?,
      ltv: json['LTV'] as int?,
      isApproved: json['isApproved'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.tryParse(json['createdAt'].toString()),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.tryParse(json['updatedAt'].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'bussinessName': bussinessName,
        'logo': logo,
        'address': address,
        'city': city,
        'category': category,
        'website': website,
        'phone': phone,
        'activeOffers': activeOffers,
        'redemption': redemption,
        'isSubscribed': isSubscribed,
        'LTV': ltv,
        'isApproved': isApproved,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
