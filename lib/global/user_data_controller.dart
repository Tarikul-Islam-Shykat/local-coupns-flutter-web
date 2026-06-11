import 'package:get/get.dart';
import '../../service/network/endpoints/endpoints.dart';
import '../../service/network/service/api_service.dart';
import 'dart:developer';

import 'profile_model.dart';

class UserDataController extends GetxController {
  final Rxn<ProfileModel> userProfile = Rxn<ProfileModel>();
  final RxBool isLoading = false.obs;

  final api = ApiService.instance;

  @override
  void onInit() {
    super.onInit();
    fetchCurrentUserData();
  }

  Future<void> fetchCurrentUserData() async {
    try {
      isLoading.value = true;
      final response = await api.get(Urls.profile, auth: true);
      if (response != null && response["success"] == true) {
        userProfile.value = ProfileModel.fromJson(response["data"]);
        final profile = userProfile.value;
        log("Global UserDataController loaded: ${profile?.fullName}");
        log(
          "Profile debug => role: ${profile?.role}, hasBusinessProfile: ${profile?.profiles?.isNotEmpty == true}, businessCount: ${profile?.profiles?.length ?? 0}, isBusinessApproved: ${profile?.profiles?.firstOrNull?.isApproved == true}",
        );
      }
    } catch (e) {
      log("Error fetching global profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateUserData(ProfileModel profile) {
    userProfile.value = profile;
    userProfile.refresh();
  }

  String get fullName => userProfile.value?.fullName ?? "User";
  String get email => userProfile.value?.email ?? "";
  String get profileImage => userProfile.value?.profileImage ?? "";
  String get userRole => userProfile.value?.role ?? "";
  bool get hasBusinessProfile =>
      (userProfile.value?.profiles?.isNotEmpty ?? false);
  BusinessProfile? get primaryBusinessProfile {
    final profiles = userProfile.value?.profiles;
    if (profiles == null || profiles.isEmpty) return null;
    return profiles.first;
  }

  bool get isBusinessApproved => primaryBusinessProfile?.isApproved == true;
  bool get hasUnapprovedBusinessProfile =>
      hasBusinessProfile && !isBusinessApproved;
  bool get isBusinessPending => hasUnapprovedBusinessProfile;
  bool get needsBusinessSetup => !hasBusinessProfile;
  bool get hasSavedLocation {
    final location = userProfile.value?.location?.trim();
    return location != null && location.isNotEmpty;
  }

  String get displayLocation =>
      hasSavedLocation ? userProfile.value!.location!.trim() : "London, UK";
}
