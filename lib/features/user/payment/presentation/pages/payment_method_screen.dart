import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/payment_method_controller.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/add_payment_method_button.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/payment_method_card.dart';

class PaymentMethodScreen extends GetView<PaymentMethodController> {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(label: 'Payment Method'),
      backgroundColor: Colors.white,
      // bottomNavigationBar: PaymentSummaryBar(
      //   priceLabel: '£42.00',
      //   onPayNow: () {
      //     PageNavigationService.to(context, AppRoutes.paymentSuccessfull);
      //   },
      // ),
      body: Obx(() {
        final selectedType = controller.selectedMethodType.value;

        return ListView(
          padding: EdgeInsets.fromLTRB(
            20.w(context),
            24.h(context),
            20.w(context),
            140.h(context),
          ),
          children: [
            ...controller.methods.map(
              (method) => Padding(
                padding: EdgeInsets.only(bottom: 14.h(context)),
                child: PaymentMethodCard(
                  iconData: method.iconData,
                  maskedNumber: method.maskedNumber,
                  expiryLabel: method.expiryLabel,
                  isSelected: selectedType == method.type,
                  onTap: () => controller.selectMethod(method.type),
                ),
              ),
            ),
            SizedBox(height: 22.h(context)),
            Center(
              child: AddPaymentMethodButton(
                onTap: () {
                  PageNavigationService.to(context, AppRoutes.addPayment);
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
