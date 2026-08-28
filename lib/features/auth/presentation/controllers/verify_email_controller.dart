import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/others/show_loader.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/core/utils/validator_services.dart';
import 'package:hoodz/urls.dart';

class VerifyEmailController extends GetxController {
  VerifyEmailController(this._networkCaller);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController otpCtrl = TextEditingController();
  final RxString email = ''.obs;
  final RxString verificationToken = ''.obs;
  final RxString verificationType = 'signup'.obs;
  final RxString screenName = 'signup'.obs;

  final NetworkCaller _networkCaller;

  void initializeFromArguments(Object? arguments) {
    if (arguments is! Map) {
      return;
    }

    final routeEmail = arguments['email'];
    if (routeEmail is String && routeEmail.isNotEmpty) {
      email.value = routeEmail;
    }

    final routeToken = arguments['verificationToken'];
    if (routeToken is String && routeToken.isNotEmpty) {
      verificationToken.value = routeToken;
    }

    final routeScreenName = arguments['screenName'];
    if (routeScreenName is String && routeScreenName.isNotEmpty) {
      screenName.value = routeScreenName;
      verificationType.value = routeScreenName;
    }
  }

  Future<Map<String, dynamic>?> verifyEmail() async {
    if (!ValidatorService.validateAndSave(formKey)) {
      return null;
    }

    if (verificationToken.value.isEmpty) {
      Get.snackbar(
        'Verification Failed',
        'Verification token missing. Please try again.',
      );
      return null;
    }

    Map<String, dynamic>? verifiedData;

    try {
      await showLoadingOverLay(
        msg: 'Verifying OTP...',
        asyncFunction: () async {
          final response = await _networkCaller.postRequest(
            '${Urls.verifyOtpUrl}?type=${verificationType.value}',
            accessToken: verificationToken.value,
            body: {'otp': otpCtrl.text.trim()},
          );

          if (!response.isSuccess) {
            Get.snackbar('Verification Failed', response.errorMessage);
            return;
          }

          final accessToken = _extractAccessToken(response.responseData);
          final userData = _extractUser(response.responseData);
          if (accessToken == null || accessToken.isEmpty) {
            Get.snackbar(
              'Verification Failed',
              'Access token not found. Please try again.',
            );
            return;
          }

          otpCtrl.clear();

          if (screenName.value == 'forgot') {
            verifiedData = {
              'accessToken': accessToken,
              'email': email.value,
              'screenName': screenName.value,
            };
            return;
          }

          await MySharedPref.setAccessToken(accessToken);
          await MySharedPref.setUserId(
            (userData?['_id'] ?? userData?['id'] ?? '').toString(),
          );
          verifiedData = {'verifiedUser': userData};
        },
      );
    } finally {}

    return verifiedData;
  }

  String? _extractAccessToken(dynamic responseData) {
    if (responseData is! Map) {
      return null;
    }

    final data = responseData['data'];
    if (data is! Map) {
      return null;
    }

    final accessToken = data['accessToken'];
    if (accessToken is String && accessToken.isNotEmpty) {
      return accessToken;
    }

    return null;
  }

  Map<String, dynamic>? _extractUser(dynamic responseData) {
    if (responseData is! Map) {
      return null;
    }

    final data = responseData['data'];
    if (data is! Map) {
      return null;
    }

    final user = data['user'];
    if (user is Map<String, dynamic>) {
      return user;
    }

    if (user is Map) {
      return Map<String, dynamic>.from(user);
    }

    return null;
  }

  @override
  void onClose() {
    otpCtrl.dispose();
    super.onClose();
  }
}
