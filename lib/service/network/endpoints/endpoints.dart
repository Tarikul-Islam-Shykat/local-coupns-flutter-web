class Urls {
  static const String baseUrl =
      'https://built-by-clint-backend.vercel.app/api/v1';
  // ------------------------auth--------------------------------------
  static const String login = '$baseUrl/auth/login';
  static const String businessRegister = '$baseUrl/users';
  static const String shopperRegister = '$baseUrl/users';
  static const String setupProfile = '$baseUrl/users/setup/profile';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String otpVerify = '$baseUrl/auth/verify-otp';
  static const String resendOTP = '$baseUrl/auth/resend-otp';
  static const String resetPass = '$baseUrl/auth/reset-password';
  static const String changePassword = '$baseUrl/auth/change-password';
  static const String userProfile = '$baseUrl/auth/profile';
  static const String updateUserProfile = '$baseUrl/users/profile';
  static const String logout = "$baseUrl/auth/logout";
  static const String users = '$baseUrl/users';
  static String approveOwner(String id) => '$baseUrl/users/approve-owner/$id';
  static String rejectOwner(String id) => '$baseUrl/users/reject-owner/$id';

  //---------------------business0------------------
  static const String getSubscription = '$baseUrl/subscriptionoffers';
  static const String engagementSummary =
      '$baseUrl/offers/get/engagement/summary';

  static String getBusinessOfferbyId(String userId) =>
      '$baseUrl/offers/get/by/$userId';
  static String getFeaturedOffersByUserId(String id) =>
      '$baseUrl/offers/get/featured/by/$id';
  static String getBusinessOffer = '$baseUrl/offers';
  static const String createBusinessOffer =
      '$baseUrl/offers'; // POST to create,
  static const String singleBusinessOffer =
      '$baseUrl/offers'; //Get with offerId
  static const String deleteBusinessOffer =
      '$baseUrl/offers'; //Delete with offerId
  static const String changeUserRole =
      '$baseUrl/users/switch-role'; // PUT to change role
  static const String getActivatedOffers =
      '$baseUrl/offers/get/activated/by/userId';
  static String activateOffer(String id) =>
      '$baseUrl/offers/activate/offer/$id';

  //---------------------profile------------------
  static const String profile = '$baseUrl/auth/profile';
  static const String getProfile = '$baseUrl/users/profile';
  static const String updateProfile = '$baseUrl/users/profile';
  static const String getSavedOffers = '$baseUrl/offers/get/saved/by/userId';
  static const String getEndingSoonOffers = '$baseUrl/offers/get/ending/soon';
  static const String toggleSaveOffer = '$baseUrl/offers/save/offer'; // + /:i

  static const String userPurchaseSubscription = "$baseUrl/subscriptionoffers";
  static String userSubscriptionSync(String id) =>
      "$baseUrl/usersubscriptions/$id";
  static const String userSubscriptions = "$baseUrl/usersubscriptions";
  static const String userSubscriptionByUserId =
      "$baseUrl/usersubscriptions/get/by/userid";
  static const String adminFetchSubscription = "$baseUrl/subscriptionoffers";
  static const String adminCreateSubscription = "$baseUrl/subscriptionoffers";
  static String adminUpdateSubscription(String id) =>
      "$baseUrl/subscriptionoffers/$id";
  static String adminDeleteSubscription(String id) =>
      "$baseUrl/subscriptionoffers/$id";

  static const String userMySubscription =
      "$baseUrl/user-subscription/my-subscription";

  static const String adminDashboardOverview = '$baseUrl/admindashboards';
}
