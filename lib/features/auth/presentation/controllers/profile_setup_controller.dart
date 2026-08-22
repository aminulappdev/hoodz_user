import 'dart:io';

import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/others/location_selection_service.dart';
import 'package:hoodz/core/services/others/image_picker_service.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/services/others/show_loader.dart';
import 'package:hoodz/core/services/upload_service.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/core/utils/validator_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hoodz/urls.dart';

class ProfileSetupController extends GetxController {
  ProfileSetupController(this._locationService, this._networkCaller);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final Rxn<File> profileImage = Rxn<File>();
  final RxnString selectedGender = RxnString();
  final RxBool isLoadingCurrentLocation = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString selectedAddress = ''.obs;
  final RxDouble selectedLatitude = 0.0.obs;
  final RxDouble selectedLongitude = 0.0.obs;
  final RxString selectedTimeZone = 'Asia/Dhaka'.obs;
  final RxString profileAvatarUrl = ''.obs;

  final LocationSelectionService _locationService;
  final NetworkCaller _networkCaller;
  final UploadService _uploadService = Get.find<UploadService>();

  final List<String> genders = ['male', 'female'];

  Future<void> selectDateOfBirth(BuildContext context) async {
    final now = DateTime.now();
    final firstDate = DateTime(1900);
    final lastDate = now;

    final pickedDate = await showDatePickerDialog(
      context: context,
      minDate: firstDate,
      maxDate: lastDate,
      width: 320,
      height: 400,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      contentPadding: const EdgeInsets.all(16),
      dialogBackground: Colors.white,
    );

    if (pickedDate == null) return;

    final day = pickedDate.day.toString().padLeft(2, '0');
    final month = pickedDate.month.toString().padLeft(2, '0');
    final year = pickedDate.year.toString();
    dateOfBirthController.text = '$day/$month/$year';
  }

  Future<void> pickProfileImage(ImageSource source) async {
    final pickedFile = await ImagePickerService.pickImage(source);
    if (pickedFile == null) return;
    profileImage.value = pickedFile;
  }

  void onGenderChanged(String gender) {
    selectedGender.value = gender;
  }

  Future<void> useCurrentLocation() async {
    isLoadingCurrentLocation.value = true;
    try {
      final currentLocation = await _locationService.getCurrentLocation();
      updateSelectedLocation(currentLocation);
    } finally {
      isLoadingCurrentLocation.value = false;
    }
  }

  void updateSelectedLocation(LocationAddress location) {
    selectedAddress.value = location.fullAddress;
    addressController.text = location.fullAddress;
    selectedLatitude.value = location.latitude;
    selectedLongitude.value = location.longitude;
    selectedTimeZone.value = 'Asia/Dhaka';
  }

  bool continueToProfilePicture(BuildContext context) {
    if (!ValidatorService.validateAndSave(formKey)) {
      return false;
    }

    if (selectedAddress.value.trim().isEmpty) {
      Get.snackbar('Validation', 'Please select your address');
      return false;
    }

    return true;
  }

  Future<void> submitUserProfileSetup(
    BuildContext context, {
    required bool withImage,
  }) async {
    if (isSubmitting.value) {
      return;
    }

    if (!ValidatorService.validateAndSave(formKey)) {
      return;
    }

    if (selectedAddress.value.trim().isEmpty) {
      Get.snackbar('Validation', 'Please select your address');
      return;
    }

    if (withImage && profileImage.value == null) {
      Get.snackbar('Validation', 'Please choose a profile picture or tap skip');
      return;
    }

    isSubmitting.value = true;

    try {
      await showLoadingOverLay(
        msg: 'Updating profile...',
        asyncFunction: () async {
          final accessToken = MySharedPref.getAccessToken();
          if (accessToken == null || accessToken.isEmpty) {
            Get.snackbar(
              'Profile Update Failed',
              'Access token missing. Please verify OTP again.',
            );
            return;
          }

          String avatarUrl = '';

          if (withImage && profileImage.value != null) {
            final uploadedAvatarUrl = await _uploadService.uploadSingleFile(
              accessToken: accessToken,
              file: profileImage.value!,
            );
            if (uploadedAvatarUrl == null) {
              return;
            }
            avatarUrl = uploadedAvatarUrl;
            profileAvatarUrl.value = uploadedAvatarUrl;
          }

          final updateProfileResponse = await _networkCaller.putRequest(
            Urls.currentUserUrl,
            accessToken: accessToken,
            body: {
              'name': nameController.text.trim(),
              'profileAvatar': avatarUrl.isEmpty ? null : avatarUrl,
              'countryCode': '+880',
              'phone': phoneController.text.trim(),
              'address': selectedAddress.value.trim(),
              'latitude': selectedLatitude.value,
              'longitude': selectedLongitude.value,
              'gender': (selectedGender.value ?? '').toLowerCase(),
              'dob': _formatDobForApi(dateOfBirthController.text.trim()),
              'isProfileSetUp': true,
            },
          );

          if (!updateProfileResponse.isSuccess) {
            Get.snackbar(
              'Profile Update Failed',
              updateProfileResponse.errorMessage,
            );
            return;
          }

          _resetFlow();
          Get.snackbar('Success', 'Profile setup completed successfully');
          PageNavigationService.offAll(context, AppRoutes.signIn);
        },
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  String _formatDobForApi(String dob) {
    final parts = dob.split('/');
    if (parts.length != 3) {
      return dob;
    }

    final day = parts[0].padLeft(2, '0');
    final month = parts[1].padLeft(2, '0');
    final year = parts[2];
    return '$year-$month-$day';
  }

  void _resetFlow() {
    nameController.clear();
    phoneController.clear();
    dateOfBirthController.clear();
    addressController.clear();
    selectedGender.value = null;
    selectedAddress.value = '';
    selectedLatitude.value = 0.0;
    selectedLongitude.value = 0.0;
    selectedTimeZone.value = 'Asia/Dhaka';
    profileAvatarUrl.value = '';
    profileImage.value = null;
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    dateOfBirthController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
