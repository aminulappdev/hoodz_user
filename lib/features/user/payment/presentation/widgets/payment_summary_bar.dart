import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_button.dart';

class PaymentSummaryBar extends StatelessWidget {
  final String priceLabel;
  final VoidCallback onPayNow;

  const PaymentSummaryBar({
    super.key,
    required this.priceLabel,
    required this.onPayNow,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          18.w(context),
          16.h(context),
          18.w(context),
          16.h(context),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.r(context)),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 18,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Strings.priceLabel.tr,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 13.sp(context),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF909090),
                    ),
                  ),
                  SizedBox(height: 6.h(context)),
                  Text(
                    priceLabel,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 22.sp(context),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF353535),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 154.w(context),
              child: CustomButton(
                text: Strings.payNow.tr,
                onPressed: onPayNow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
