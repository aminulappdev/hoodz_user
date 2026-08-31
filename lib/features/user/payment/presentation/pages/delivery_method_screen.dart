import 'package:flutter/material.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/delivery_method_controller.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/delivery_method_card.dart';

class DeliveryMethodScreen extends GetView<DeliveryMethodController> {
  const DeliveryMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(label: Strings.deliveryMethod.tr),
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20.w(context),
            0,
            20.w(context),
            20.h(context),
          ),
          child: CustomButton(
            text: Strings.continueButton.tr,
            onPressed: () {
              PageNavigationService.to(context, AppRoutes.paymentMethod);
            },
          ),
        ),
      ),
      body: Obx(() {
        final selectedType = controller.selectedMethodType.value;

        return ListView.separated(
          padding: EdgeInsets.fromLTRB(
            20.w(context),
            24.h(context),
            20.w(context),
            100.h(context),
          ),
          itemCount: controller.methods.length,
          separatorBuilder: (_, __) => SizedBox(height: 14.h(context)),
          itemBuilder: (context, index) {
            final method = controller.methods[index];
            final isSelected = selectedType == method.type;
            return DeliveryMethodCard(
              title: method.title,
              providers: method.providers,
              type: method.type,
              isSelected: isSelected,
              onTap: () => controller.selectMethod(method.type),
            );
          },
        );
      }),
    );
  }
}
