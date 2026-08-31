import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/others/location_selection_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/utils/validator_services.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/core/widgets/custom_text_field.dart';
import 'package:hoodz/features/auth/presentation/controllers/profile_setup_controller.dart';
import 'package:hoodz/features/auth/presentation/widgets/label_text_widget.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/location_selection_sheet.dart';
import 'package:hoodz/gen/assets.gen.dart';

class ProfileSetupScreen extends GetView<ProfileSetupController> {
  const ProfileSetupScreen({super.key});

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
    final routeArguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final fieldTextStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF757575));
    return Scaffold(
      appBar: CustomAppBar(label: Strings.profileSetup.tr),
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
                  SizedBox(height: 20.h(context)),
                  LabelText(label: Strings.fullName.tr),
                  SizedBox(height: 8.h(context)),
                  CustomTextField(
                    controller: controller.nameController,
                    hintText: Strings.enterYourName.tr,
                    validator: ValidatorService.validateFullName,
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
                            SizedBox(
                              child: Obx(
                                () => CustomTextField(
                                  hintText: Strings.select.tr,
                                  hintStyle: fieldTextStyle,
                                  value: controller.selectedGender.value,
                                  onChanged: controller.onGenderChanged,
                                  validator:
                                      ValidatorService.validateSimpleField,
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
                              onTap: () =>
                                  controller.selectDateOfBirth(context),
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
                      Spacer(),
                      GestureDetector(
                        onTap: () => _showLocationSheet(context),
                        child: Text(
                          Strings.change.tr,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
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
                  CustomButton(
                    text: Strings.continueButton.tr,
                    onPressed: () {
                      if (!controller.continueToProfilePicture(context)) {
                        return;
                      }
                      Navigator.pushNamed(
                        context,
                        AppRoutes.profilePictureSetup,
                        arguments: routeArguments,
                      );
                    },
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
