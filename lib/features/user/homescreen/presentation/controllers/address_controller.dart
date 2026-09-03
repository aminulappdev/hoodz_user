import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/others/location_selection_service.dart';
import 'package:hoodz/core/utils/auth_response_utils.dart';
import 'package:hoodz/core/utils/login_required_dialog.dart';
import 'package:hoodz/core/utils/safe_get_snackbar.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/profile/presentation/controller/profile_controller.dart';
import 'package:hoodz/urls.dart';

class AddressController extends GetxController {
  AddressController(this._locationService, this._networkCaller);

  final LocationSelectionService _locationService;
  final NetworkCaller _networkCaller;

  final RxBool isLoadingCurrentLocation = false.obs;
  final RxBool isUpdatingAddress = false.obs;

  Future<void> useCurrentLocation() async {
    isLoadingCurrentLocation.value = true;
    try {
      final currentLocation = await _locationService.getCurrentLocation();
      await updateAddress(currentLocation);
    } finally {
      isLoadingCurrentLocation.value = false;
    }
  }

  Future<void> updateAddress(LocationAddress location) async {
    if (isUpdatingAddress.value) {
      return;
    }

    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.trim().isEmpty) {
      showLoginRequiredDialog();
      return;
    }

    isUpdatingAddress.value = true;

    final response = await _networkCaller.putRequest(
      Urls.userLocationUrl,
      accessToken: accessToken,
      body: {
        'longitude': location.longitude,
        'latitude': location.latitude,
        'address': location.fullAddress,
        'timeZone': 'Asia/Dhaka',
      },
    );

    isUpdatingAddress.value = false;

    if (isLoginRequiredResponse(response)) {
      showLoginRequiredDialog();
      return;
    }

    if (!response.isSuccess) {
      showSafeGetSnackbar(Strings.addressUpdateFailed.tr, response.errorMessage);
      return;
    }

    Get.find<ProfileController>().updateAddressRealtime(location.fullAddress);
    showSafeGetSnackbar(
      Strings.addressUpdatedSuccessfully.tr,
      Strings.addressUpdatedSuccessfully.tr,
    );
  }
}
