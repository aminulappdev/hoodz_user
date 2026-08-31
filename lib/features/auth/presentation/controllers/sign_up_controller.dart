import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/others/show_loader.dart';
import 'package:hoodz/core/utils/validator_services.dart';
import 'package:hoodz/urls.dart';

class SignUpController extends GetxController {
  SignUpController(this._networkCaller);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();
  final RxBool isPasswordHidden = true.obs;
  final RxBool isConfirmPasswordHidden = true.obs; 
  final NetworkCaller _networkCaller;

  void togglePasswordVisibility() {
    isPasswordHidden.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.toggle();
  }

  Future<Map<String, String>?> signUp() async {
    if (!ValidatorService.validateAndSave(formKey)) {
      return null;
    }

    final email = emailCtrl.text.trim();
    const role = 'user';
    String? verificationToken;

    try {
      await showLoadingOverLay(
        msg: Strings.creatingAccount.tr,
        asyncFunction: () async {
          final response = await _networkCaller.postRequest(
            Urls.signUpWithEmailUrl,
            body: {
              'email': email,
              'password': passwordCtrl.text,
              'role': role,
              'fcmToken': 'FCM_TOKEN',
              'isLegalTermsAccepted': true,
            },
          );

          if (!response.isSuccess) {
            Get.snackbar(Strings.signUpFailed.tr, response.errorMessage);
            return;
          }

          verificationToken = _extractVerificationToken(response.responseData);
          if (verificationToken == null) {
            Get.snackbar(
              Strings.signUpFailed.tr,
              Strings.verificationTokenNotFound.tr,
            );
            return;
          }
        },
      );
    } finally {
    }

    if (verificationToken == null) {
      return null;
    }
    
    return {
      'verificationToken': verificationToken!,
      'email': email,
      'role': role,
      'screenName': 'signup',
    };
  }

  String? _extractVerificationToken(dynamic responseData) {
    if (responseData is! Map) {
      return null;
    }

    final data = responseData['data'];
    if (data is! Map) {
      return null;
    }

    final otpToken = data['otpToken'];
    if (otpToken is Map) {
      final verificationToken = otpToken['verificationToken'];
      if (verificationToken is String && verificationToken.isNotEmpty) {
        return verificationToken;
      }
    }

    return null;
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }
}
