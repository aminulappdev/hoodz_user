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
      appBar: CustomAppBar(label: Strings.profileSetup.tr, isShowBackButton: false,),
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
                  LabelText(label: Strings.address.tr),
                  SizedBox(height: 8.h(context)),
                  Obx(
                    () => _AddressPickerCard(
                      address: controller.selectedAddress.value,
                      onTap: () => _showLocationSheet(context),
                    ),
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

class _AddressPickerCard extends StatelessWidget {
  const _AddressPickerCard({
    required this.address,
    required this.onTap,
  });

  final String address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasAddress = address.trim().isNotEmpty;
    final theme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 96.h(context)),
          child: Ink(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 18.w(context),
              vertical: 18.h(context),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFE8ECEB)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  offset: Offset(0, 8),
                  blurRadius: 18,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 34.h(context),
                  width: 34.h(context),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF1EA),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on_outlined,
                    color: Color(0xFFFF5A00),
                    size: 20,
                  ),
                ),
                SizedBox(height: 8.h(context)),
                Text(
                  hasAddress ? address.trim() : Strings.setAddress.tr,
                  textAlign: TextAlign.center,
                  maxLines: hasAddress ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.bodyMedium?.copyWith(
                    color: hasAddress
                        ? const Color(0xFF2F2F2F)
                        : const Color(0xFF9B9B9B),
                    fontSize: 15.sp(context),
                    fontWeight: hasAddress ? FontWeight.w500 : FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6.h(context)),
                Text(
                  Strings.change.tr,
                  textAlign: TextAlign.center,
                  style: theme.bodyMedium?.copyWith(
                    color: const Color(0xFF757575),
                    fontSize: 12.sp(context),
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
