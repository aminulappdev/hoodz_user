import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/core/widgets/custom_text_field.dart';
import 'package:hoodz/core/utils/validator_services.dart';
import 'package:hoodz/features/auth/presentation/widgets/label_text_widget.dart';
import 'package:hoodz/features/user/profile/presentation/controller/change_password_controller.dart';
import 'package:hoodz/gen/assets.gen.dart';

class ChangePasswordScreen extends GetView<ChangePasswordController> {
  const ChangePasswordScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(label: Strings.changePassword.tr),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w(context)),
          child: SizedBox(
            width: width,
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h(context)),
                  LabelText(label: Strings.currentPassword.tr),
                  SizedBox(height: 8.h(context)),
                  Obx(
                    () => CustomTextField(
                      controller: controller.currentPasswordCtrl,
                      hintText: '******',
                      obscureText: controller.isCurrentPasswordHidden.value,
                      suffixIcon: controller.isCurrentPasswordHidden.value
                          ? Assets.icons.eyeOff.path
                          : Assets.icons.view.path,
                      suffixIconOnPressed:
                          controller.toggleCurrentPasswordVisibility,
                      validator: ValidatorService.validateSimpleField,
                    ),
                  ),
                  SizedBox(height: 20.h(context)),
                  LabelText(label: Strings.newPassword.tr),
                  SizedBox(height: 8.h(context)),
                  Obx(
                    () => CustomTextField(
                      controller: controller.passwordCtrl,
                      hintText: '******',
                      obscureText: controller.isPasswordHidden.value,
                      suffixIcon: controller.isPasswordHidden.value
                          ? Assets.icons.eyeOff.path
                          : Assets.icons.view.path,
                      suffixIconOnPressed: controller.togglePasswordVisibility,
                      validator: ValidatorService.validatePassword,
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
                      suffixIcon: controller.isConfirmPasswordHidden.value
                          ? Assets.icons.eyeOff.path
                          : Assets.icons.view.path,
                      suffixIconOnPressed:
                          controller.toggleConfirmPasswordVisibility,
                      validator: (value) {
                        final baseValidation =
                            ValidatorService.validateSimpleField(value);
                        if (baseValidation != null) {
                          return baseValidation;
                        }

                        if (value?.trim() != controller.passwordCtrl.text.trim()) {
                          return Strings.passwordsDoNotMatch.tr;
                        }

                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 30.h(context)),
                  Obx(
                    () => CustomButton(
                      enabled: !controller.isLoading.value,
                      text: controller.isLoading.value
                          ? Strings.saving.tr
                          : Strings.update.tr,
                      onPressed: () async {
                        await controller.changePassword();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
