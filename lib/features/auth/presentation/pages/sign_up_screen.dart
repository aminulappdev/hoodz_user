import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/utils/validator_services.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/core/widgets/custom_text_field.dart';
import 'package:hoodz/features/auth/presentation/controllers/sign_up_controller.dart';
import 'package:hoodz/features/auth/presentation/widgets/auth_background.dart';
import 'package:hoodz/features/auth/presentation/widgets/have_account.dart';
import 'package:hoodz/features/auth/presentation/widgets/label_text_widget.dart';
import 'package:hoodz/features/auth/presentation/widgets/others_auth_widget.dart';
import 'package:hoodz/gen/assets.gen.dart';

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        isBack: true,
        title: Strings.createYourAccount.tr,
        subtitle: Strings.signUpSubtitle.tr,
        contentColumn: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h(context)), 
                LabelText(label: Strings.emailAddress.tr),
                SizedBox(height: 8.h(context)),
                CustomTextField(
                  controller: controller.emailCtrl,
                  hintText: Strings.enterYourEmail.tr,
                  keyboardType: TextInputType.emailAddress,
                  validator: ValidatorService.validateEmailAddress,
                ),
                SizedBox(height: 20.h(context)),
                LabelText(label: Strings.password.tr),
                SizedBox(height: 8.h(context)),

                Obx(
                  () => CustomTextField(
                    controller: controller.passwordCtrl,
                    hintText: '******',
                    obscureText: controller.isPasswordHidden.value,
                    validator: ValidatorService.validatePassword,
                    suffixIcon: controller.isPasswordHidden.value
                        ? Assets.icons.eyeOff.path
                        : Assets.icons.view.path,
                    suffixIconOnPressed: controller.togglePasswordVisibility,
                  ),
                ),
                SizedBox(height: 20.h(context)),
                LabelText(label: Strings.confirmPassword.tr),
                SizedBox(height: 8.h(context)),

                Obx(
                  () => CustomTextField(
                    controller: controller.confirmPasswordCtrl,
                    hintText: '******',
                    obscureText: controller.isConfirmPasswordHidden.value,
                    validator: (confirmPassword) =>
                        ValidatorService.validateConfirmPassword(
                          confirmPassword,
                          controller.passwordCtrl.text,
                        ),
                    suffixIcon: controller.isConfirmPasswordHidden.value
                        ? Assets.icons.eyeOff.path
                        : Assets.icons.view.path,
                    suffixIconOnPressed:
                        controller.toggleConfirmPasswordVisibility,
                  ),
                ),
                SizedBox(height: 40.h(context)),
                CustomButton(
                  text: Strings.signUp.tr,
                  onPressed: () async {
                    final signUpData = await controller.signUp();
                    if (signUpData == null) {
                      return;
                    }
                    Navigator.pushNamed(
                      context,
                      AppRoutes.verifyEmail,
                      arguments: signUpData,
                    );
                  },
                ),
                SizedBox(height: 32.h(context)),
                OthersAuth(onApplePressed: () {}, onGooglePressed: () {}),
                SizedBox(height: 32.h(context)),
                HaveAnAccount(
                  content: Strings.alreadyHaveAccount.tr,
                  buttonTitle: Strings.signIn.tr,
                  onPressed: () {
                    PageNavigationService.to(context, AppRoutes.signIn);
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
