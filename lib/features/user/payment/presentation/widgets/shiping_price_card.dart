import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/checkout_card.dart';

class ShipingPriceCard extends StatelessWidget {
  const ShipingPriceCard({
    super.key,
    required this.price,
    required this.deliveryCharge,
    required this.totalCost,
  });

  final double price;
  final double deliveryCharge;
  final double totalCost;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 14.w(context),
        vertical: 14.h(context),
      ),
      decoration: BoxDecoration(
        color: const Color(0xffF7F7F7),
        borderRadius: BorderRadius.circular(14.r(context)),
      ),
      child: Column(
        children: [
          SummaryRow(
            title: 'Price:',
            value: '\$${price.toStringAsFixed(2)}',
            titleColor: const Color(0xff6A6A6A),
          ),
          SizedBox(height: 8.h(context)),
          const Divider(color: Color(0xffD9D9D9), height: 1),
          SizedBox(height: 8.h(context)),
          SummaryRow(
            title: 'Delivery charge:',
            value: '\$${deliveryCharge.toStringAsFixed(2)}',
            titleColor: const Color(0xff6A6A6A),
          ),
          SizedBox(height: 8.h(context)),
          const Divider(color: Color(0xffD9D9D9), height: 1),
          SizedBox(height: 8.h(context)),
          SummaryRow(
            title: 'Total cost',
            value: '\$${totalCost.toStringAsFixed(2)}',
            isBold: true,
          ),
        ],
      ),
    );
  }
}