import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/core/widgets/custom_text_field.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/add_payment_controller.dart';
import 'package:hoodz/features/user/payment/presentation/models/payment_method_item.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/add_payment_method_type_chip.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/payment_form_label.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/save_card_checkbox_row.dart';
import 'package:hoodz/gen/assets.gen.dart';

class AddPaymentScreen extends GetView<AddPaymentController> {
  const AddPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(label: Strings.addPaymentMethodTitle.tr),
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16.w(context),
            0,
            16.w(context),
            24.h(context),
          ),
          child: CustomButton(
            text: Strings.addCard.tr,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Obx(() {
        final selectedType = controller.selectedMethodType.value;
        final saveCardForFuture = controller.saveCardForFuture.value;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            16.w(context),
            18.h(context),
            16.w(context),
            120.h(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Strings.selectYourPaymentMethod.tr,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp(context),
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF8B8B8B),
                ),
              ),
              SizedBox(height: 12.h(context)),
              Row(
                children: [
                  AddPaymentMethodTypeChip(
                    type: PaymentMethodType.stripe,
                    isSelected: selectedType == PaymentMethodType.stripe,
                    onTap: () {
                      controller.selectMethod(PaymentMethodType.stripe);
                    },
                  ),
                  SizedBox(width: 10.w(context)),
                  AddPaymentMethodTypeChip(
                    type: PaymentMethodType.paypal,
                    isSelected: selectedType == PaymentMethodType.paypal,
                    onTap: () {
                      controller.selectMethod(PaymentMethodType.paypal);
                    },
                  ),
                ],
              ),
              SizedBox(height: 20.h(context)),
              PaymentFormLabel(text: Strings.cardHolderName.tr),
              SizedBox(height: 10.h(context)),
              CustomTextField(
                hintText: Strings.yourName.tr,
                prefixIcon: Assets.icons.idCard.path,
              ),
              SizedBox(height: 18.h(context)),
              PaymentFormLabel(text: Strings.cardNumber.tr),
              SizedBox(height: 10.h(context)),
              CustomTextField(
                hintText: Strings.cardNumber.tr,
                prefixIcon: selectedType == PaymentMethodType.stripe
                    ? Assets.icons.stripe.path
                    : Assets.icons.payPal.path,
              ),
              SizedBox(height: 18.h(context)),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PaymentFormLabel(text: Strings.validUntil.tr),
                        SizedBox(height: 10.h(context)),
                        CustomTextField(hintText: Strings.monthYear.tr),
                      ],
                    ),
                  ),
                  SizedBox(width: 14.w(context)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PaymentFormLabel(text: Strings.cvv.tr),
                        SizedBox(height: 10.h(context)),
                        CustomTextField(hintText: Strings.cvv.tr),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h(context)),
              SaveCardCheckboxRow(
                value: saveCardForFuture,
                onChanged: controller.toggleSaveCard,
              ),
            ],
          ),
        );
      }),
    );
  }
}
