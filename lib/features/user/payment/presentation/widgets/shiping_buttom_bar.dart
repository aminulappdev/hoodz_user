import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/checkout_card.dart';

class ShipingButtomBar extends StatelessWidget {
  const ShipingButtomBar({
    super.key,
    required this.total,
    required this.onTap,
    this.subTotal,
    this.deliveryCharge,
    this.buttonText = 'Pay Now',
  });

  final double? subTotal;
  final double? deliveryCharge;
  final double total;
  final VoidCallback onTap;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    final hasBreakdown = subTotal != null && deliveryCharge != null;

    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
        ),
        padding: EdgeInsets.all(4.w(context)),
        child: hasBreakdown
            ? Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w(context),
                    vertical: 0.h(context),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // SummaryRow(
                      //   title: 'Sub-total',
                      //   value: '\$${subTotal!.toStringAsFixed(2)}',
                      //   titleColor: const Color(0xff9A9A9A),
                      // ),
                      // SizedBox(height: 14.h(context)),
                      // SummaryRow(
                      //   title: 'Delivery charge',
                      //   value: '\$${deliveryCharge!.toStringAsFixed(2)}',
                      //   titleColor: const Color(0xff9A9A9A),
                      // ),
                      // SizedBox(height: 14.h(context)),
                      // const Divider(color: Color(0xffEAEAEA), height: 1),
                      
                      SummaryRow(
                        title: 'Total cost',
                        value: '\$${total.toStringAsFixed(2)}',
                        isBold: true,
                      ),
                      SizedBox(height: 26.h(context)),
                      CustomButton(text: buttonText, onPressed: onTap),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price:',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontSize: 14.sp(context),
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff7A7A7A),
                              ),
                        ),
                        SizedBox(height: 4.h(context)),
                        Text(
                          '\$${total.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                fontSize: 22.sp(context),
                                fontWeight: FontWeight.w700,
                                color: const Color(0xff3F3F3F),
                              ),
                        ),
                      ],
                    ),
                    SizedBox(width: 100.w(context)),
                    Expanded(
                      child: CustomButton(text: buttonText, onPressed: onTap),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
