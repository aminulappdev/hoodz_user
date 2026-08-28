import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/others/show_loader.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/core/utils/validator_services.dart';
import 'package:hoodz/urls.dart';

class SignInController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final NetworkCaller _networkCaller;
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

    await showLoadingOverLay(
      msg: 'Signing in...',
      asyncFunction: () async {
        final response = await _networkCaller.postRequest(
          Urls.loginWithEmailUrl,
          body: {
            'email': emailController.text.trim(),
            'password': passwordController.text,
          },
        );

        if (!response.isSuccess) {
          Get.snackbar('Login Failed', response.errorMessage);
          return;
        }

        final user = _extractUser(response.responseData);
        final accessToken = _extractAccessToken(response.responseData);

        if (user == null || accessToken == null) {
          Get.snackbar(
            'Login Failed',
            'Invalid login response. Please try again.',
          );
          return;
        }

        final status = (user['status'] ?? '').toString().toLowerCase();
        if (status == 'pending') {
          signInData = {
            'isPending': true,
            'message':
                'Tomar request pending e ache. Approval er jonno wait korun.',
          };
          return;
        }

        await MySharedPref.setAccessToken(accessToken);
        await MySharedPref.setUserId(
          (user['_id'] ?? user['id'] ?? '').toString(),
        );

        signInData = {
          'user': user,
          'accessToken': accessToken,
          'isProfileSetUp': user['isProfileSetUp'] == true,
          'targetRoute': AppRoutes.userDashboard,
        };
      },
    );

    return signInData;
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
