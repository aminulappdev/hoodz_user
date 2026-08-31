import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/core/widgets/image_source_picker_sheet.dart';
import 'package:hoodz/features/auth/presentation/controllers/profile_setup_controller.dart';
import 'package:hoodz/gen/assets.gen.dart';
import 'package:image_picker/image_picker.dart'; 

class ProfilePictureSetupScreen extends GetView<ProfileSetupController> {
  const ProfilePictureSetupScreen({super.key});
   
  Future<void> _onEditTap(BuildContext context) async { 
    final ImageSource? source = await showImageSourcePickerSheet(context);
    if (source == null) return;
    await controller.pickProfileImage(source);
  }
  
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(label: Strings.profilePicture.tr),
      body: SizedBox(
        height: height,
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ 
              SizedBox(height: 42.h(context)),

              Expanded(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 81.5,
                          backgroundColor: LightThemeColors.primaryColor,
                          child: Obx(
                            () => CircleAvatar(
                              radius: 80,
                              backgroundColor: const Color(0xFFCAD2D8),
                              backgroundImage:
                                  controller.profileImage.value != null
                                  ? FileImage(controller.profileImage.value!)
                                  : null,
                              child: controller.profileImage.value == null
                                  ? CrashSafeImage(
                                      Assets.icons.avatur.path,
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                          ),
                        ),

                        Positioned(
                          right: 20.h(context),
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () => _onEditTap(context),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: LightThemeColors.primaryColor,
                              child: CrashSafeImage(
                                Assets.icons.edit02.path,
                                color: Colors.white,
                                height: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Spacer(),

                    Obx(
                      () => CustomButton(
                        text: controller.isSubmitting.value
                            ? Strings.pleaseWait.tr
                            : Strings.continueButton.tr,
                        onPressed: controller.isSubmitting.value
                            ? null
                            : () => controller.submitUserProfileSetup(
                                  context,
                                  withImage: true,
                                ),
                      ),
                    ),
                    // SizedBox(height: 16.h(context)),

                    // Obx(
                    //   () => GestureDetector(
                    //     onTap: controller.isSubmitting.value
                    //         ? null
                    //         : () => controller.submitUserProfileSetup(
                    //               context,
                    //               withImage: false,
                    //             ),
                    //     child: Text(
                    //       'Skip',
                    //       style: Theme.of(context).textTheme.bodyMedium
                    //           ?.copyWith(
                    //             color: LightThemeColors.primaryColor,
                    //             fontSize: 14,
                    //             fontFamily: 'Geist',
                    //             fontWeight: FontWeight.w600,
                    //           ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 20.h(context)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
