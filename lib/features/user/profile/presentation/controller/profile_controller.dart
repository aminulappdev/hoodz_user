import 'package:get/get.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/profile/data/models/user_profile_model.dart';
import 'package:hoodz/urls.dart';

class ProfileController extends GetxController {
  final RxString selectedLanguage = 'en'.obs;
  final RxBool isLoading = false.obs;
  final RxString currentAddress = ''.obs;

  final NetworkCaller _networkCaller = Get.find<NetworkCaller>();

  final Rx<UserProfileModel?> _userProfileModel = Rx<UserProfileModel?>(null);
  Rx<UserProfileModel?> get userProfileModel => _userProfileModel;
  Data? get userData => _userProfileModel.value?.data;

  final List<String> languages = const ['en', 'bn'];

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  void onLanguageChanged(String value) {
    selectedLanguage.value = value;
  }

  Future<void> loadUserProfile({bool force = false}) async {
    if (isLoading.value) {
      return;
    }

    if (!force && _userProfileModel.value != null) {
      return;
    }

    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      Get.snackbar(
        'Profile Load Failed',
        'Access token not found. Please login again.',
      );
      return;
    } 

    isLoading.value = true; 

    final response = await _networkCaller.getRequest(
      Urls.currentUserUrl,
      accessToken: accessToken,
    );

    isLoading.value = false;

    if (response.isSuccess) {
      _userProfileModel.value = UserProfileModel.fromJson(response.responseData);
      currentAddress.value = userData?.address ?? '';
      return;
    }

    Get.snackbar('Profile Load Failed', response.errorMessage);
  }

  void updateAddressRealtime(String address) {
    currentAddress.value = address;
  }
}
