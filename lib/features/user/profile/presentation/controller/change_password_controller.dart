import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/others/show_loader.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/core/utils/validator_services.dart';
import 'package:hoodz/urls.dart';

class ChangePasswordController extends GetxController {
  ChangePasswordController() : _networkCaller = Get.find<NetworkCaller>();

  final NetworkCaller _networkCaller;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();
  final RxBool isCurrentPasswordHidden = true.obs;
  final RxBool isPasswordHidden = true.obs;
  final RxBool isConfirmPasswordHidden = true.obs;
  final RxBool isLoading = false.obs;

  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordHidden.toggle();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.toggle();
  }

  Future<bool> changePassword() async {
    if (!ValidatorService.validateAndSave(formKey)) {
      return false;
    }

    if (passwordCtrl.text.trim() != confirmPasswordCtrl.text.trim()) {
      showAppToast(
        message: Strings.passwordsDoNotMatch.tr,
        isError: true,
      );
      return false;
    }

    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      showAppToast(
        message: Strings.accessTokenNotFoundPleaseLoginAgain.tr,
        isError: true,
      );
      return false;
    }

    var isSuccess = false;

    await showLoadingOverLay(
      msg: Strings.changingPassword.tr,
      asyncFunction: () async {
        isLoading.value = true;
        try {
          final response = await _networkCaller.postRequest(
            Urls.changePasswordUrl,
            accessToken: accessToken,
            body: {
              'currentPassword': currentPasswordCtrl.text.trim(),
              'password': passwordCtrl.text.trim(),
              'confirmPassword': confirmPasswordCtrl.text.trim(),
            },
          );

          if (!response.isSuccess) {
            showAppToast(message: response.errorMessage, isError: true);
            return;
          }

          currentPasswordCtrl.clear();
          passwordCtrl.clear();
          confirmPasswordCtrl.clear();
          isSuccess = true;
          showAppToast(message: Strings.passwordChangedSuccessfully.tr);
        } finally {
          isLoading.value = false;
        }
      },
    );

    if (isSuccess) {
      Get.back();
    }

    return isSuccess;
  }

  @override
  void onClose() {
    currentPasswordCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }
}
