import 'package:get/get.dart';
import 'package:hoodz/app/translator/localization_service.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
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
  bool get hasCustomerSupport => userData?.hasCustomerSupport ?? false;

  final List<String> languages = const ['en', 'ar'];

  @override
  void onInit() {
    super.onInit();
    final savedLanguage = MySharedPref.getLocale().languageCode;
    selectedLanguage.value = LocalizationService.isLanguageSupported(
      savedLanguage,
    )
        ? savedLanguage
        : 'en';
    loadUserProfile();
  }

  Future<void> onLanguageChanged(String value) async {
    selectedLanguage.value = value;
    await LocalizationService.updateLanguage(value);
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
        Strings.profileLoadFailed.tr,
        Strings.accessTokenNotFoundPleaseLoginAgain.tr,
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
      _userProfileModel.value = UserProfileModel.fromJson(
        response.responseData,
      );
      final resolvedUserId =
          userData?.id?.trim() ?? userData?.dataId?.trim() ?? '';
      if (resolvedUserId.isNotEmpty) {
        await MySharedPref.setUserId(resolvedUserId);
      }
      currentAddress.value = userData?.address ?? '';
      return;
    }

    Get.snackbar(Strings.profileLoadFailed.tr, response.errorMessage);
  }

  void updateAddressRealtime(String address) {
    currentAddress.value = address;
  }
}
