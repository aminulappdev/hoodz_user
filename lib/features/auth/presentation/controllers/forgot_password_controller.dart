import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/others/show_loader.dart';
import 'package:hoodz/core/utils/validator_services.dart';
import 'package:hoodz/urls.dart';

class ForgotPasswordController extends GetxController {
  ForgotPasswordController(this._networkCaller);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailCtrl = TextEditingController();
  final NetworkCaller _networkCaller;

  Future<Map<String, String>?> sendResetOtp() async {
    if (!ValidatorService.validateAndSave(formKey)) {
      return null;
    }

    final email = emailCtrl.text.trim();
    String? verificationToken;

    await showLoadingOverLay(
      msg: Strings.sendingOtp.tr,
      asyncFunction: () async {
        final response = await _networkCaller.postRequest(
          Urls.forgotPasswordUrl,
          body: {'email': email},
        );

        if (!response.isSuccess) {
          Get.snackbar(Strings.requestFailed.tr, response.errorMessage);
          return;
        }

        verificationToken = _extractVerificationToken(response.responseData);
        if (verificationToken == null) {
          Get.snackbar(
            Strings.requestFailed.tr,
            Strings.verificationTokenNotFound.tr,
          );
        }
      },
    );

    if (verificationToken == null) {
      return null;
    }

    return {
      'verificationToken': verificationToken!,
      'email': email,
      'screenName': 'forgot',
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

    final verificationToken = data['verificationToken'];
    if (verificationToken is String && verificationToken.isNotEmpty) {
      return verificationToken;
    }

    return null;
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    super.onClose();
  }
}
 
