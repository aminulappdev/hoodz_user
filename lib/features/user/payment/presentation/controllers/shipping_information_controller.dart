import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/core/services/others/location_selection_service.dart';

class ShippingInformationController extends GetxController {
  ShippingInformationController(this._locationService);
  final double price = 42.00;
  final double deliveryCharge = 0.43;

  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController(); 
  final fullAddressController = TextEditingController();
  final buildingController = TextEditingController();
  final floorController = TextEditingController();
  final apartmentController = TextEditingController();
  final noteController = TextEditingController();

  final LocationSelectionService _locationService;
  final RxInt currentBannerIndex = 0.obs;
  final RxInt notificationCount = 3.obs;
  final RxString selectedAddress = 'AQUA Tower, 43 Mohakhali C/A'.obs;
  final RxBool isLoadingCurrentLocation = false.obs;

  final RxString selectedCountry = ''.obs;
  final RxString selectedCity = ''.obs;
  final RxString selectedDeliveryType = 'Instant Delivery'.obs;

  Future<void> useCurrentLocation() async {
    isLoadingCurrentLocation.value = true;
    try {
      final currentLocation = await _locationService.getCurrentLocation();
      selectedAddress.value = currentLocation.fullAddress;
    } finally {
      isLoadingCurrentLocation.value = false;
    }
  }

  final List<String> countries = const [
    'Bangladesh',
    'United States',
    'Canada',
  ];

  final List<String> cities = const ['Dhaka', 'Chattogram', 'Sylhet'];

  final List<String> deliveryTypes = const [
    'Instant Delivery',
    'Standard Delivery',
    'Scheduled Delivery',
  ];

  double get totalCost => price + deliveryCharge;

  void changeCountry(String value) {
    selectedCountry.value = value;
  }

  void changeCity(String value) {
    selectedCity.value = value;
  }

  void changeDeliveryType(String value) {
    selectedDeliveryType.value = value;
  }

  @override
  void onClose() {
    fullNameController.dispose();
    phoneNumberController.dispose();
    fullAddressController.dispose();
    buildingController.dispose();
    floorController.dispose();
    apartmentController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
