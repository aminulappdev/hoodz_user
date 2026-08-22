import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/core/widgets/custom_text_field.dart';
import 'package:hoodz/features/auth/presentation/widgets/label_text_widget.dart';
import 'package:hoodz/features/user/profile/presentation/controller/change_password_controller.dart';
import 'package:hoodz/gen/assets.gen.dart';

class ChangePasswordScreen extends GetView<ChangePasswordController> {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const CustomAppBar(label: 'Change Password'),
      body: SafeArea(
        child: SizedBox(
          height: height,
          width: width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h(context)),
                const LabelText(label: 'Current Password'),
                SizedBox(height: 8.h(context)),
                Obx(
                  () => CustomTextField(
                    hintText: '******',
                    obscureText: controller.isPasswordHidden.value,
                    suffixIcon: controller.isPasswordHidden.value
                        ? Assets.icons.eyeOff.path
                        : Assets.icons.view.path,
                    suffixIconOnPressed: controller.togglePasswordVisibility,
                  ),
                ),
                SizedBox(height: 20.h(context)),
                const LabelText(label: 'Confirm Password'),
                SizedBox(height: 8.h(context)),
                Obx(
                  () => CustomTextField(
                    hintText: '******',
                    obscureText: controller.isConfirmPasswordHidden.value,
                    suffixIcon: controller.isConfirmPasswordHidden.value
                        ? Assets.icons.eyeOff.path
                        : Assets.icons.view.path,
                    suffixIconOnPressed:
                        controller.toggleConfirmPasswordVisibility,
                  ),
                ),
                SizedBox(height: 20.h(context)),
                const LabelText(label: 'New Password'),
                SizedBox(height: 8.h(context)),
                Obx(
                  () => CustomTextField(
                    hintText: '******',
                    obscureText: controller.isPasswordHidden.value,
                    suffixIcon: controller.isPasswordHidden.value
                        ? Assets.icons.eyeOff.path
                        : Assets.icons.view.path,
                    suffixIconOnPressed: controller.togglePasswordVisibility,
                  ),
                ),

                SizedBox(height: 30.h(context)),
                CustomButton(
                  text: 'Save Changes',
                  onPressed: () {
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
