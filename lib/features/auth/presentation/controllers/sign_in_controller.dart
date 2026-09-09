import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/others/show_loader.dart';
import 'package:hoodz/core/services/others/push_notification_service.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/core/utils/validator_services.dart';
import 'package:hoodz/urls.dart';

class SignInController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final NetworkCaller _networkCaller;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  final RxBool isPasswordHidden = true.obs;
  final RxBool rememberMe = true.obs;
  final TextEditingController emailController = TextEditingController(
    text: "pewader553@hutdot.com",
  );
  final TextEditingController passwordController = TextEditingController(
    text: "Aminul@2000",
  );

  SignInController(this._networkCaller);

  void togglePasswordVisibility() {
    isPasswordHidden.toggle();
  }

  void toggleRememberMe() {
    rememberMe.toggle();
  }

  Future<Map<String, dynamic>?> signIn() async {
    if (!ValidatorService.validateAndSave(formKey)) {
      return null;
    }

    Map<String, dynamic>? signInData;
    final fcmToken = await PushNotificationService().getOrCreateToken();

    await showLoadingOverLay(
      msg: Strings.signingIn.tr,
      asyncFunction: () async {
        final response = await _networkCaller.postRequest(
          Urls.loginWithEmailUrl,
          body: {
            'email': emailController.text.trim(),
            'password': passwordController.text,
            if (fcmToken != null && fcmToken.isNotEmpty) 'fcmToken': fcmToken,
          },
        );

        if (!response.isSuccess) {
          showAppToast(message: response.errorMessage, isError: true);
          return;
        }

        signInData = await _buildSuccessfulSignInData(response.responseData);
      },
    );

    return signInData;
  }

  Future<Map<String, dynamic>?> signInWithGoogle() async {
    Map<String, dynamic>? signInData;

    await showLoadingOverLay(
      msg: Strings.signingIn.tr,
      asyncFunction: () async {
        try {
          await _googleSignIn.signOut();
          final googleUser = await _googleSignIn.signIn();
          if (googleUser == null) {
            return;
          }

          final googleAuth = await googleUser.authentication;
          final googleToken = googleAuth.idToken ?? googleAuth.accessToken;
          if (googleToken == null || googleToken.isEmpty) {
            showAppToast(
              message: Strings.invalidLoginResponse.tr,
              isError: true,
            );
            return;
          }

          final fcmToken = await PushNotificationService().getOrCreateToken();
          final response = await _networkCaller.postRequest(
            Urls.googleAuthUrl,
            body: {
              'name': _resolveGoogleName(googleUser),
              'email': googleUser.email,
              'token': googleToken,
              'role': 'user',
              if (fcmToken != null && fcmToken.isNotEmpty) 'fcmToken': fcmToken,
              'isLegalTermsAccepted': true,
            },
          );

          if (!response.isSuccess) {
            showAppToast(message: response.errorMessage, isError: true);
            return;
          }

          signInData = await _buildSuccessfulSignInData(response.responseData);
        } catch (error) {
          showAppToast(message: error.toString(), isError: true);
        }
      },
    );

    return signInData;
  }

  Future<Map<String, dynamic>?> _buildSuccessfulSignInData(
    dynamic responseData,
  ) async {
    final user = _extractUser(responseData);
    final accessToken = _extractAccessToken(responseData);

    if (user == null || accessToken == null) {
      showAppToast(
        message: Strings.invalidLoginResponse.tr,
        isError: true,
      );
      return null;
    }

    final status = (user['status'] ?? '').toString().toLowerCase();
    if (status == 'pending') {
      return {
        'isPending': true,
        'message': Strings.requestPendingMessage.tr,
      };
    }

    await MySharedPref.setAccessToken(accessToken);
    await MySharedPref.setUserId((user['_id'] ?? user['id'] ?? '').toString());

    return {
      'user': user,
      'accessToken': accessToken,
      'isProfileSetUp': user['isProfileSetUp'] == true,
      'targetRoute': AppRoutes.userDashboard,
    };
  }

  String _resolveGoogleName(GoogleSignInAccount googleUser) {
    final displayName = googleUser.displayName?.trim();
    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }

    final emailName = googleUser.email.split('@').first.trim();
    return emailName.isNotEmpty ? emailName : googleUser.email;
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

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
