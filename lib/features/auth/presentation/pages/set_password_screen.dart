import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/utils/validator_services.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/core/widgets/custom_text_field.dart';
import 'package:hoodz/features/auth/presentation/controllers/set_password_controller.dart';
import 'package:hoodz/features/auth/presentation/widgets/auth_background.dart';
import 'package:hoodz/features/auth/presentation/widgets/label_text_widget.dart';
import 'package:hoodz/gen/assets.gen.dart';

class SetPasswordScreen extends GetView<SetPasswordController> {
  const SetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.initializeFromArguments(
      ModalRoute.of(context)?.settings.arguments,
    );

    return Scaffold(
      body: AuthBackground(
        isBack: true,
        title: Strings.createNewPassword.tr,
        subtitle: Strings.createNewPasswordSubtitle.tr,
        contentColumn: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h(context)),

                LabelText(label: Strings.newPassword.tr),
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
                SizedBox(height: 30.h(context)),
                CustomButton(
                  text: Strings.continueButton.tr,
                  onPressed: () async {
                    final isSuccess = await controller.resetPassword();
                    if (!isSuccess) {
                      return;
                    }

                    PageNavigationService.offAll(context, AppRoutes.signIn);
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
