import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/core/services/others/location_selection_service.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/utils/validator_services.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/core/widgets/custom_text_field.dart';
import 'package:hoodz/core/widgets/image_source_picker_sheet.dart';
import 'package:hoodz/features/auth/presentation/widgets/label_text_widget.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/location_selection_sheet.dart';
import 'package:hoodz/features/user/profile/presentation/controller/edit_profile_controller.dart';
import 'package:hoodz/gen/assets.gen.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final EditProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<EditProfileController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeEditProfile();
    });
  }

  Future<void> _onEditTap(BuildContext context) async {
    final ImageSource? source = await showImageSourcePickerSheet(context);
    if (source == null) return;
    await controller.pickProfileImage(source);
  }

  Future<void> _showLocationSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Obx(
        () => LocationSelectionSheet(
          isLoadingCurrentLocation: controller.isLoadingCurrentLocation.value,
              onTapCurrentLocation: () async {
            Navigator.pop(context);
            try {
              await controller.useCurrentLocation();
            } on LocationServiceException catch (error) {
              Get.snackbar(
                Strings.locationUnavailable.tr,
                error.message,
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          onTapDifferentLocation: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.mapLocationPicker).then((
              result,
            ) {
              if (result is LocationAddress) {
                controller.updateSelectedLocation(result);
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final fieldTextStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF757575));

    return Scaffold(
      appBar: CustomAppBar(label: Strings.editProfile.tr),
      body: SizedBox(
        height: height,
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 56,
                          backgroundColor: LightThemeColors.primaryColor,
                          child: Obx(
                            () => CircleAvatar(
                              radius: 55,
                              backgroundColor: const Color(0xFFCAD2D8),
                              backgroundImage:
                                  controller.profileImage.value != null
                                  ? FileImage(controller.profileImage.value!)
                                  : controller.existingProfileImageUrl.value
                                            .trim()
                                            .isNotEmpty
                                  ? NetworkImage(
                                      controller.existingProfileImageUrl.value,
                                    )
                                  : null,
                              child:
                                  controller.profileImage.value == null &&
                                      controller.existingProfileImageUrl.value
                                          .trim()
                                          .isEmpty
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
                              radius: 12,
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
                  ),
                  SizedBox(height: 40.h(context)),
                  LabelText(label: Strings.fullName.tr),
                  SizedBox(height: 8.h(context)),
                  CustomTextField(
                    controller: controller.nameController,
                    hintText: Strings.enterYourName.tr,
                    validator: ValidatorService.validateSimpleField,
                  ),
                  SizedBox(height: 20.h(context)),
                  LabelText(label: Strings.phoneNumber.tr),
                  SizedBox(height: 8.h(context)),
                  CustomTextField(
                    controller: controller.phoneController,
                    hintText: Strings.enterYourPhoneNumber.tr,
                    keyboardType: TextInputType.phone,
                    validator: ValidatorService.validateSimpleField,
                  ),
                  SizedBox(height: 20.h(context)),
                  Row(
                    children: [
                      SizedBox(
                        width: 150.w(context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabelText(label: Strings.gender.tr),
                            SizedBox(height: 8.h(context)),
                            Obx(
                              () => CustomTextField(
                                hintText: Strings.select.tr,
                                hintStyle: fieldTextStyle,
                                value: controller.selectedGender.value,
                                onChanged: controller.onGenderChanged,
                                validator: ValidatorService.validateSimpleField,
                                contentPadding: EdgeInsets.all(16.h(context)),
                                items: controller.genders
                                    .map(
                                      (gender) => DropdownMenuItem(
                                        value: gender,
                                        child: Text(
                                          gender[0].toUpperCase() +
                                              gender.substring(1),
                                          style: fieldTextStyle,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w(context)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabelText(label: Strings.dateOfBirth.tr),
                            SizedBox(height: 8.h(context)),
                            CustomTextField(
                              controller: controller.dateOfBirthController,
                              hintText: Strings.dateFormatHint.tr,
                              hintStyle: fieldTextStyle,
                              readOnly: true,
                              validator: ValidatorService.validateSimpleField,
                              onTap: () => controller.selectDateOfBirth(context),
                              suffixIcon: Assets.icons.clock02.path,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w(context),
                                vertical: 16.h(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h(context)),
                  Row(
                    children: [
                      LabelText(label: Strings.address.tr),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _showLocationSheet(context),
                        child: Text(
                          Strings.change.tr,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF757575),
                            fontFamily: 'Geist',
                            fontSize: 12.sp(context),
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.underline,
                            decorationColor: const Color(0xFF757575),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h(context)),
                  CustomTextField(
                    controller: controller.addressController,
                    hintText: Strings.selectYourAddress.tr,
                    readOnly: true,
                    maxLines: 3,
                    validator: ValidatorService.validateSimpleField,
                  ),
                  SizedBox(height: 20.h(context)),
                  Obx(
                    () => CustomButton(
                      text: controller.isSubmitting.value
                          ? Strings.pleaseWait.tr
                          : Strings.update.tr,
                      onPressed: controller.isSubmitting.value
                          ? null
                          : () async {
                              final isSuccess = await controller.updateProfile();
                              if (!isSuccess) {
                                return;
                              }
                              PageNavigationService.back(context);
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
