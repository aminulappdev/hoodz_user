import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/others/show_loader.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/urls.dart';

class VerifyEmailController extends GetxController {
  VerifyEmailController(this._networkCaller);

  final RxString email = ''.obs;
  final RxString verificationToken = ''.obs;
  final RxString verificationType = 'signup'.obs;
  final RxString screenName = 'signup'.obs;

  final NetworkCaller _networkCaller;

  void initializeFromArguments(Object? arguments) {
    email.value = '';
    verificationToken.value = '';
    verificationType.value = 'signup';
    screenName.value = 'signup';

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

  Future<Map<String, dynamic>?> verifyEmail({required String otp}) async {
    if (verificationToken.value.isEmpty) {
      Get.snackbar(
        Strings.verificationFailed.tr,
        Strings.verificationTokenNotFound.tr,
      );
      return null;
    }

    Map<String, dynamic>? verifiedData;

    try {
      await showLoadingOverLay(
        msg: Strings.verifyingOtp.tr,
        asyncFunction: () async {
          final response = await _networkCaller.postRequest(
            '${Urls.verifyOtpUrl}?type=${verificationType.value}',
            accessToken: verificationToken.value,
            body: {'otp': otp},
          );

          if (!response.isSuccess) {
            Get.snackbar(Strings.verificationFailed.tr, response.errorMessage);
            return;
          }

          final accessToken = _extractAccessToken(response.responseData);
          final userData = _extractUser(response.responseData);
          if (accessToken == null || accessToken.isEmpty) {
            Get.snackbar(
              Strings.verificationFailed.tr,
              Strings.invalidLoginResponse.tr,
            );
            return;
          }

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
}
