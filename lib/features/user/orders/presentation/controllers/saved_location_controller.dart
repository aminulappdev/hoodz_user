import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/others/show_loader.dart';
import 'package:hoodz/core/utils/auth_response_utils.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/login_required_dialog.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/home_screen_controller.dart';
import 'package:hoodz/features/user/orders/data/models/save_address_model.dart'
    as saved_address;
import 'package:hoodz/features/user/orders/presentation/controllers/order_summary_controller.dart';
import 'package:hoodz/features/user/profile/presentation/controller/profile_controller.dart';
import 'package:hoodz/urls.dart';

class SavedLocationController extends GetxController {
  SavedLocationController() : _networkCaller = Get.find<NetworkCaller>();

  final NetworkCaller _networkCaller;

  final RxBool isLoading = false.obs;
  final RxnString selectedAddressId = RxnString();
  final Rxn<saved_address.SaveAddressModel> _saveAddressModel =
      Rxn<saved_address.SaveAddressModel>();

  List<saved_address.Datum> get savedAddresses =>
      _saveAddressModel.value?.data ?? const <saved_address.Datum>[];

  @override
  void onInit() {
    super.onInit();
    fetchSavedLocations();
  }

  Future<bool> fetchSavedLocations() async {
    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.trim().isEmpty) {
      showLoginRequiredDialog();
      return false;
    }

    isLoading.value = true;

    try {
      final response = await _networkCaller.getRequest(
        Urls.savedLocationsUrl,
        accessToken: accessToken,
      );

      if (isLoginRequiredResponse(response)) {
        showLoginRequiredDialog();
        return false;
      }

      if (!response.isSuccess) {
        showAppToast(message: response.errorMessage, isError: true);
        return false;
      }

      final responseData = response.responseData;
      if (responseData is! Map<String, dynamic>) {
        showAppToast(message: 'Invalid saved locations response', isError: true);
        return false;
      }

      _saveAddressModel.value =
          saved_address.SaveAddressModel.fromJson(responseData);
      return true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> applySavedAddress(saved_address.Datum address) async {
    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.trim().isEmpty) {
      showLoginRequiredDialog();
      return false;
    }

    final addressId = address.id;
    if (addressId == null || addressId.trim().isEmpty) {
      showAppToast(message: Strings.pleaseSelectYourAddress.tr, isError: true);
      return false;
    }

    final coordinates = address.location?.coordinates ?? const <double>[];
    if (coordinates.length < 2) {
      showAppToast(message: 'Selected address location is invalid.', isError: true);
      return false;
    }

    var isSuccess = false;
    selectedAddressId.value = addressId;

    await showLoadingOverLay(
      msg: Strings.updatingSelectedAddress.tr,
      asyncFunction: () async {
        final response = await _networkCaller.putRequest(
          Urls.deliveryLocationUrl,
          accessToken: accessToken,
          body: {
            'name': address.name,
            'location': {
              'type': address.location?.type ?? 'Point',
              'coordinates': coordinates,
            },
            'buildingNo': address.buildingNo,
            'floorNo': address.floorNo,
            'apartment': address.apartment,
            'city': address.city,
            'country': address.country,
          },
        );

        if (isLoginRequiredResponse(response)) {
          showLoginRequiredDialog();
          return;
        }

        if (!response.isSuccess) {
          showAppToast(message: response.errorMessage, isError: true);
          return;
        }

        await Get.find<ProfileController>().loadUserProfile(force: true);
        await Get.find<HomeScreenController>().getUserMeta(force: true);
        await Get.find<OrderSummaryController>().refreshOrderSummary();
        isSuccess = true;
      },
    );

    return isSuccess;
  }

  String addressTitle(saved_address.Datum address) {
    final apartment = address.apartment?.toString().trim();
    if (apartment != null && apartment.isNotEmpty) {
      return 'Apartment';
    }

    final name = address.name?.trim();
    return name == null || name.isEmpty ? Strings.address.tr : name;
  }

  String addressSubtitle(saved_address.Datum address) {
    return <String>[
      if (address.name?.trim().isNotEmpty == true) address.name!.trim(),
      if (address.city?.trim().isNotEmpty == true) address.city!.trim(),
      if (address.country?.trim().isNotEmpty == true) address.country!.trim(),
    ].join(', ');
  }
}
