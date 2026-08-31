import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/utils/validator_services.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/features/auth/presentation/controllers/verify_email_controller.dart';
import 'package:hoodz/features/auth/presentation/widgets/auth_background.dart';
import 'package:hoodz/features/auth/presentation/widgets/label_text_widget.dart';
import 'package:hoodz/features/auth/presentation/widgets/pin_code_field.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otpCtrl = TextEditingController();
  final VerifyEmailController controller = Get.find<VerifyEmailController>();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      return;
    }
    _initialized = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      controller.initializeFromArguments(
        ModalRoute.of(context)?.settings.arguments,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        isBack: true,
        title: Strings.verifyEmail.tr,
        subtitle: Strings.verifyEmailSubtitle.tr,
        contentColumn: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h(context)),
                LabelText(label: Strings.otp.tr),
                SizedBox(height: 8.h(context)),
                AppPinCodeField(
                  controller: _otpCtrl,
                  length: 6,
                  validator: ValidatorService.validateSimpleField,
                ),
                SizedBox(height: 30.h(context)),
                CustomButton(
                  text: Strings.verify.tr,
                  onPressed: () async {
                    final isValid = _formKey.currentState?.validate() ?? false;
                    if (!isValid) {
                      return;
                    }

                    final verifiedData = await controller.verifyEmail(
                      otp: _otpCtrl.text.trim(),
                    );
                    if (verifiedData == null) {
                      return;
                    }

                    if (controller.screenName.value == 'forgot') {
                      PageNavigationService.replace(
                        context,
                        AppRoutes.setPassword,
                        arguments: verifiedData,
                      );
                      return;
                    }

                    PageNavigationService.replace(
                      context,
                      AppRoutes.profileSetup,
                      arguments: verifiedData,
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
