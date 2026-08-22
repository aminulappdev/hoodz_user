import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/others/show_loader.dart';
import 'package:hoodz/core/utils/validator_services.dart';
import 'package:hoodz/urls.dart';

class SetPasswordController extends GetxController {
  SetPasswordController(this._networkCaller);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();
  final RxBool isPasswordHidden = true.obs;
  final RxBool isConfirmPasswordHidden = true.obs;
  final RxBool rememberMe = true.obs;
  final RxString accessToken = ''.obs;
  final RxString email = ''.obs;
  final NetworkCaller _networkCaller;

  void initializeFromArguments(Object? arguments) {
    if (arguments is! Map) {
      return;
    }

    final routeAccessToken = arguments['accessToken'];
    if (routeAccessToken is String && routeAccessToken.isNotEmpty) {
      accessToken.value = routeAccessToken;
    }

    final routeEmail = arguments['email'];
    if (routeEmail is String && routeEmail.isNotEmpty) {
      email.value = routeEmail;
    }
  }

  void togglePasswordVisibility() {
    isPasswordHidden.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.toggle();
  }

  Future<bool> resetPassword() async {
    if (!ValidatorService.validateAndSave(formKey)) {
      return false;
    }

    if (accessToken.value.isEmpty) {
      Get.snackbar(
        'Reset Failed',
        'Reset token missing. Please start the forgot password flow again.',
      );
      return false;
    }

    var isSuccess = false;

    await showLoadingOverLay(
      msg: 'Updating password...',
      asyncFunction: () async {
        final response = await _networkCaller.postRequest(
          Urls.resetPasswordUrl,
          accessToken: accessToken.value,
          body: {
            'password': passwordCtrl.text.trim(),
            'confirmPassword': confirmPasswordCtrl.text.trim(),
          },
        );

        if (!response.isSuccess) {
          Get.snackbar('Reset Failed', response.errorMessage);
          return;
        }

        passwordCtrl.clear();
        confirmPasswordCtrl.clear();
        isSuccess = true;
      },
    );

    return isSuccess;
  }

  @override
  void onClose() {
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }
}
