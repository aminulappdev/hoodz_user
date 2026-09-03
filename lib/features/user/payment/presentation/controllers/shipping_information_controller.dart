import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/others/show_loader.dart';
import 'package:hoodz/core/services/others/location_selection_service.dart';
import 'package:hoodz/core/utils/auth_response_utils.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/login_required_dialog.dart';
import 'package:hoodz/core/utils/safe_get_snackbar.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/profile/data/models/user_profile_model.dart';
import 'package:hoodz/urls.dart';

class ShippingInformationController extends GetxController {
  ShippingInformationController(this._locationService, this._networkCaller);
  final double price = 42.00;
  final double deliveryCharge = 0.43;

  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController(); 
  final fullAddressController = TextEditingController();
  final buildingController = TextEditingController();
  final floorController = TextEditingController();
  final apartmentController = TextEditingController();

  final LocationSelectionService _locationService;
  final NetworkCaller _networkCaller;
  final RxInt currentBannerIndex = 0.obs;
  final RxInt notificationCount = 3.obs;
  final RxString selectedAddress = 'AQUA Tower, 43 Mohakhali C/A'.obs;
  final RxBool isLoadingCurrentLocation = false.obs;
  final RxDouble selectedLatitude = 23.777176.obs;
  final RxDouble selectedLongitude = 90.399452.obs;

  final RxString selectedCountry = 'Bangladesh'.obs;
  final RxString selectedCity = 'Dhaka'.obs;
  bool _didPrefillProfile = false;

  Future<bool> useCurrentLocation() async {
    isLoadingCurrentLocation.value = true;
    try {
      final currentLocation = await _locationService.getCurrentLocation();
      return applySelectedLocation(currentLocation);
    } finally {
      isLoadingCurrentLocation.value = false;
    }
  }

  final List<String> countries = const [
    'Bangladesh',
    'United States',
    'Canada',
  ];

  final List<String> cities = const [
    'Dhaka',
    'Chattogram',
    'Sylhet',
    'Khulna',
    'Rajshahi',
    'Barishal',
    'Rangpur',
    'Mymensingh',
    'Cumilla',
    'Narayanganj',
    'Gazipur',
    'Jashore',
    'Cox\'s Bazar',
    'Bogura',
    'Tangail',
    'Faridpur',
    'Brahmanbaria',
    'Pabna',
    'Kushtia',
    'Noakhali',
  ];

  double get totalCost => price + deliveryCharge;

  void changeCountry(String value) {
    selectedCountry.value = value;
  }

  void changeCity(String value) {
    selectedCity.value = value;
  }

  Future<bool> updateDeliveryLocation() async {
    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.trim().isEmpty) {
      showLoginRequiredDialog();
      return false;
    }

    final name = _resolveLocationName();
    final city = selectedCity.value.trim();
    final country = selectedCountry.value.trim().isEmpty
        ? 'Bangladesh'
        : selectedCountry.value.trim();
    final fullAddress = fullAddressController.text.trim();
    final buildingNo = int.tryParse(buildingController.text.trim());
    final floorNo = int.tryParse(floorController.text.trim());
    final apartment = int.tryParse(apartmentController.text.trim());

    if (name.isEmpty) {
      showAppToast(message: 'Location name is required.', isError: true);
      return false;
    }
    if (fullAddress.isEmpty) {
      showAppToast(message: Strings.fullAddressRequired.tr, isError: true);
      return false;
    }
    if (city.isEmpty) {
      showAppToast(message: Strings.cityRequired.tr, isError: true);
      return false;
    }
    if (buildingNo == null) {
      showAppToast(message: Strings.buildingNumberRequired.tr, isError: true);
      return false;
    }
    if (floorNo == null) {
      showAppToast(message: Strings.floorNumberRequired.tr, isError: true);
      return false;
    }
    if (apartment == null) {
      showAppToast(message: Strings.apartmentNumberRequired.tr, isError: true);
      return false;
    }

    var isSuccess = false;

    await showLoadingOverLay(
      msg: Strings.savingDeliveryLocation.tr,
      asyncFunction: () async {
        final response = await _networkCaller.putRequest(
          Urls.deliveryLocationUrl,
          accessToken: accessToken,
          body: {
            'name': name,
            'location': {
              'type': 'Point',
              'coordinates': [
                selectedLongitude.value,
                selectedLatitude.value,
              ],
            },
            'buildingNo': buildingNo,
            'floorNo': floorNo,
            'apartment': apartment,
            'city': city,
            'country': country,
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

        isSuccess = true;
        showAppToast(message: 'Delivery location updated successfully');
      },
    );

    return isSuccess;
  }

  Future<bool> applySelectedLocation(LocationAddress location) async {
    final matchedCity = _resolveCity(location);
    if (matchedCity == null) {
      showSafeGetSnackbar(
        'City not found',
        'Selected location city does not match available cities.',
      );
      return false;
    }

    final selectedCityValue = selectedCity.value.trim();
    if (selectedCityValue.isNotEmpty &&
        matchedCity.toLowerCase() != selectedCityValue.toLowerCase()) {
      showSafeGetSnackbar(
        'City mismatch',
        'Picked location city does not match the selected city.',
      );
      return false;
    }

    selectedAddress.value = location.fullAddress;
    fullAddressController.text = location.fullAddress;
    selectedLatitude.value = location.latitude;
    selectedLongitude.value = location.longitude;
    return true;
  }

  void prefillFromProfile(Data? user) {
    if (_didPrefillProfile || user == null) {
      return;
    }

    if (fullNameController.text.trim().isEmpty) {
      fullNameController.text = user.name ?? '';
    }

    if (phoneNumberController.text.trim().isEmpty) {
      phoneNumberController.text = user.phone ?? '';
    }

    final deliveryAddress = user.deliveryAddress;
    if (deliveryAddress != null) {
      if (fullAddressController.text.trim().isEmpty) {
        fullAddressController.text = deliveryAddress.name ?? '';
      }

      if (selectedAddress.value.trim().isEmpty) {
        selectedAddress.value = deliveryAddress.name ?? selectedAddress.value;
      }

      final city = deliveryAddress.city?.trim();
      if (city != null &&
          city.isNotEmpty &&
          cities.any((item) => item.toLowerCase() == city.toLowerCase())) {
        selectedCity.value = city;
      }

      final country = deliveryAddress.country?.trim();
      if (country != null && country.isNotEmpty) {
        selectedCountry.value = country;
      }

      final coordinates = deliveryAddress.location?.coordinates ?? const <num>[];
      if (coordinates.length >= 2) {
        selectedLongitude.value = coordinates[0].toDouble();
        selectedLatitude.value = coordinates[1].toDouble();
      }

      if (buildingController.text.trim().isEmpty &&
          deliveryAddress.buildingNo != null) {
        buildingController.text = deliveryAddress.buildingNo.toString();
      }

      if (floorController.text.trim().isEmpty &&
          deliveryAddress.floorNo != null) {
        floorController.text = deliveryAddress.floorNo.toString();
      }

      if (apartmentController.text.trim().isEmpty &&
          deliveryAddress.apartment != null) {
        apartmentController.text = deliveryAddress.apartment.toString();
      }
    }

    _didPrefillProfile = true;
  }

  String _resolveLocationName() {
    final fullAddress = fullAddressController.text.trim();
    if (fullAddress.isNotEmpty) {
      final firstPart = fullAddress.split(',').first.trim();
      if (firstPart.isNotEmpty) {
        return firstPart;
      }
      return fullAddress;
    }

    final selected = selectedAddress.value.trim();
    if (selected.isNotEmpty) {
      final firstPart = selected.split(',').first.trim();
      if (firstPart.isNotEmpty) {
        return firstPart;
      }
      return selected;
    }

    return '';
  }

  String? _resolveCity(LocationAddress location) {
    final candidates = <String?>[
      location.addressLine,
      location.label,
      location.fullAddress,
    ];

    for (final city in cities) {
      final normalizedCity = city.toLowerCase();
      for (final candidate in candidates) {
        final text = candidate?.toLowerCase().trim() ?? '';
        if (text.isEmpty) {
          continue;
        }
        if (text.contains(normalizedCity)) {
          return city;
        }
      }
    }

    return null;
  }

  @override
  void onClose() {
    fullNameController.dispose();
    phoneNumberController.dispose();
    fullAddressController.dispose();
    buildingController.dispose();
    floorController.dispose();
    apartmentController.dispose();
    super.onClose();
  }
}
