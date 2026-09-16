import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/others/location_selection_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/core/widgets/custom_text_field.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/home_screen_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/location_selection_sheet.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/order_summary_controller.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/shipping_information_controller.dart';
import 'package:hoodz/features/user/profile/presentation/controller/profile_controller.dart';

class ShippingInformationScreen extends GetView<ShippingInformationController> {
  const ShippingInformationScreen({super.key});

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
              final success = await controller.useCurrentLocation();
              if (!success) {
                return;
              }
            } on LocationServiceException catch (error) {
              Get.snackbar(
                Strings.locationUnavailable.tr,
                error.message,
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          onTapDifferentLocation: () async {
            Navigator.pop(context);
            final result = await Navigator.pushNamed(
              context,
              AppRoutes.mapLocationPicker,
            );

            if (result is LocationAddress) {
              await controller.applySelectedLocation(result);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    return Obx(() {
      final user = profileController.userProfileModel.value?.data;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.prefillFromProfile(user);
      });

      return Scaffold( 
        backgroundColor: Colors.white,
        appBar: CustomAppBar(label: Strings.shippingInformation.tr),
        // bottomNavigationBar: ShipingButtomBar(
        //   total: controller.price,
        //   onTap: () {
        //     PageNavigationService.to(context, AppRoutes.deliveryMethod);
        //   },
        // ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            20.w(context),
            18.h(context),
            20.w(context),
            120.h(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _FieldLabel(Strings.fullName.tr),
              // SizedBox(height: 8.h(context)), 
              // CustomTextField(
              //   enabled: false,
              //   controller: controller.fullNameController, 
              //   hintText: Strings.enterYourName.tr,
              // ),
              // SizedBox(height: 18.h(context)),
              // _FieldLabel(Strings.phoneNumber.tr),
              // SizedBox(height: 8.h(context)),
              // CustomTextField(
              //   enabled: false,
              //   controller: controller.phoneNumberController,
              //   hintText: Strings.enterYourPhoneNumber.tr,
              //   keyboardType: TextInputType.phone,
              // ),
              _SectionHeader(
                title: Strings.shippingAddress.tr,
                onChange: () => _showLocationSheet(context),
              ),
              SizedBox(height: 10.h(context)),

              _AddressCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           const _FieldLabel('Country'),
                    //           SizedBox(height: 8.h(context)),
                    //           CustomTextField(hintText: 'Country'),
                    //         ],
                    //       ),
                    //     ),
                    //     SizedBox(width: 14.w(context)),
                    //     Expanded(
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           const _FieldLabel('City'),
                    //           SizedBox(height: 8.h(context)),
                    //           CustomTextField(hintText: 'City'),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    _FieldLabel(Strings.fullAddress.tr),
                    SizedBox(height: 8.h(context)),
                    CustomTextField(
                      controller: controller.fullAddressController,
                      hintText: Strings.address.tr,
                    ),
                    SizedBox(height: 18.h(context)),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _FieldLabel(Strings.buildingNo.tr),
                              SizedBox(height: 8.h(context)),
                              CustomTextField(
                                controller: controller.buildingController,
                                hintText: Strings.buildingNo.tr,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 14.w(context)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _FieldLabel(Strings.floorNo.tr),
                              SizedBox(height: 8.h(context)),
                              CustomTextField(
                                controller: controller.floorController,
                                hintText: Strings.floorNo.tr,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h(context)),
                    _FieldLabel(Strings.apartment.tr),
                    SizedBox(height: 8.h(context)),
                    CustomTextField(
                      controller: controller.apartmentController,
                      hintText: Strings.address.tr,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h(context)),
              CustomButton(
                text: Strings.saveChanges.tr,
                onPressed: () async {
                  final success = await controller.updateDeliveryLocation();
                  if (success && context.mounted) {
                    await Get.find<ProfileController>().loadUserProfile(
                      force: true,
                    );
                    await Get.find<HomeScreenController>().getUserMeta(
                      force: true,
                    );
                    await Get.find<OrderSummaryController>().refreshOrderSummary();
                    Navigator.pop(context);
                  }
                },
              ),
              // SizedBox(height: 18.h(context)),
              // ShipingPriceCard(
              //   price: controller.price,
              //   deliveryCharge: controller.deliveryCharge,
              //   totalCost: controller.totalCost,
              // ),
            ],
          ),
        ),
      );
    });
  }
}

class _SectionHeader extends StatelessWidget {
  final VoidCallback? onChange;
  const _SectionHeader({required this.title, this.onChange});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 16.sp(context),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2F2F2F),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onChange,
          child: Text(
            Strings.change.tr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 13.sp(context),
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6F6F6F),
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: child,
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontSize: 14.sp(context),
        fontWeight: FontWeight.w500,
        color: const Color(0xff7A7A7A),
      ),
    );
  }
}
