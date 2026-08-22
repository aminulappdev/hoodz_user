import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/utils/validator_services.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/core/widgets/custom_text_field.dart';
import 'package:hoodz/features/auth/presentation/controllers/forgot_password_controller.dart';
import 'package:hoodz/features/auth/presentation/widgets/auth_background.dart';
import 'package:hoodz/features/auth/presentation/widgets/label_text_widget.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground( 
        isBack: true, 
        title: 'Forgot Password',
        subtitle:
            'Please enter your email address which was used to create your account.',
        contentColumn: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h(context)),
                const LabelText(label: 'Email'),
                SizedBox(height: 8.h(context)),
                CustomTextField(
                  controller: controller.emailCtrl,
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  validator: ValidatorService.validateEmailAddress,
                ),
                SizedBox(height: 32.h(context)),
                CustomButton(
                  text: 'Continue',
                  onPressed: () async {
                    final resetData = await controller.sendResetOtp();
                    if (resetData == null) {
                      return;
                    }

                    Navigator.pushNamed(
                      context,
                      AppRoutes.verifyEmail,
                      arguments: resetData,
                    );
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
