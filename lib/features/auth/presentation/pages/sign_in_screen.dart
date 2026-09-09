import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/utils/validator_services.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/core/widgets/custom_text_field.dart';
import 'package:hoodz/features/auth/presentation/controllers/sign_in_controller.dart';
import 'package:hoodz/features/auth/presentation/widgets/auth_background.dart';
import 'package:hoodz/features/auth/presentation/widgets/have_account.dart';
import 'package:hoodz/features/auth/presentation/widgets/label_text_widget.dart';
import 'package:hoodz/features/auth/presentation/widgets/others_auth_widget.dart';
import 'package:hoodz/features/auth/presentation/widgets/remember_me_widget.dart';
import 'package:hoodz/gen/assets.gen.dart';

class SignInScreen extends GetView<SignInController> {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> handleSignInResult(
      Map<String, dynamic>? signInData, {
      bool shouldOpenProfileSetup = true,
    }) async {
      if (signInData == null) {
        return;
      }

      if (signInData['isPending'] == true) {
        await showDialog<void>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(Strings.requestPending.tr),
            content: Text(
              (signInData['message'] ?? '').toString(),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: Text(Strings.ok.tr),
              ),
            ],
          ),
        );
        return;
      }

      if (shouldOpenProfileSetup && signInData['isProfileSetUp'] != true) {
        PageNavigationService.offAll(
          context,
          AppRoutes.profileSetup,
          arguments: {'verifiedUser': signInData['user']},
        );
        return;
      }

      PageNavigationService.offAll(
        context,
        signInData['targetRoute'] as String,
      );
    }

    return Scaffold(
      body: AuthBackground( 
        isBack: false,
        backLabel: Strings.back.tr,
        title: Strings.welcomeBack.tr,
        subtitle: Strings.signInSubtitle.tr,
        contentColumn: Form( 
          key: controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h(context)),
                LabelText(label: Strings.email.tr),
                SizedBox(height: 8.h(context)), 
                CustomTextField(
                  controller: controller.emailController,
                  hintText: Strings.enterYourEmail.tr,
                  keyboardType: TextInputType.emailAddress,
                  validator: ValidatorService.validateEmailAddress,
                ),
                SizedBox(height: 20.h(context)),
                LabelText(label: Strings.password.tr),
                SizedBox(height: 8.h(context)),
                Obx(
                  () => CustomTextField(
                    controller: controller.passwordController,
                    hintText: '******',
                    obscureText: controller.isPasswordHidden.value,
                    suffixIcon: controller.isPasswordHidden.value
                        ? Assets.icons.eyeOff.path
                        : Assets.icons.view.path,
                    suffixIconOnPressed: controller.togglePasswordVisibility,
                    validator: ValidatorService.validateSimpleField,
                  ),
                ),
                SizedBox(height: 20.h(context)),
                Obx(
                  () => RememberMe(
                    value: controller.rememberMe.value,
                    rememberMeText: Strings.rememberMe.tr,
                    forgotPasswordText: Strings.forgotPassword.tr,
                    onToggle: controller.toggleRememberMe,
                    onForgotPassword: () {
                      PageNavigationService.to(
                        context,
                        AppRoutes.forgotPassword,
                      );
                    },
                  ),
                ),
                SizedBox(height: 40.h(context)),
                CustomButton(
                  text: Strings.signIn.tr,
                  onPressed: () async {
                    final signInData = await controller.signIn();
                    await handleSignInResult(signInData);
                  },
                ),
                SizedBox(height: 32.h(context)),
                OthersAuth(
                  onApplePressed: () {},
                  onGooglePressed: () async {
                    final signInData = await controller.signInWithGoogle();
                    await handleSignInResult(
                      signInData,
                      shouldOpenProfileSetup: false,
                    );
                  },
                ),
                SizedBox(height: 32.h(context)),
                HaveAnAccount(
                  content: Strings.dontHaveAccount.tr,
                  buttonTitle: Strings.signUp.tr,
                  onPressed: () {
                    PageNavigationService.to(context, AppRoutes.signUp);
                  },
                ),
              ],
            ),
          ),
        ),
      ), 
    );
  }
}
