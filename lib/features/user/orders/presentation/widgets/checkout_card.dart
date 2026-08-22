import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_button.dart';

class CheckoutCard extends StatelessWidget {
  final double subTotal;
  final double total;
  final double deliveryCharge;
  final VoidCallback onTap;

  const CheckoutCard({
    super.key,
    required this.subTotal,
    required this.total,
    required this.deliveryCharge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 18.w(context),
        vertical: 20.h(context),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r(context)),
        border: Border.all(color: const Color(0xffEAEAEA)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SummaryRow(
            title: 'Sub-total',
            value: '\$${subTotal.toStringAsFixed(2)}',
            titleColor: const Color(0xff9A9A9A),
          ),
          SizedBox(height: 14.h(context)),
          SummaryRow(
            title: 'Delivery charge',
            value: '\$${deliveryCharge.toStringAsFixed(2)}',
            titleColor: const Color(0xff9A9A9A),
          ),
          SizedBox(height: 14.h(context)),
          const Divider(color: Color(0xffEAEAEA), height: 1),
          SizedBox(height: 14.h(context)),
          SummaryRow(
            title: 'Total cost',
            value: '\$${total.toStringAsFixed(2)}',
            isBold: true,
          ),
          SizedBox(height: 26.h(context)),
          CustomButton(text: 'Proceed to Checkout', onPressed: onTap),
        ],
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  const SummaryRow({
    super.key,
    required this.title,
    required this.value,
    this.titleColor,
    this.isBold = false,
  });

  final String title;
  final String value;
  final Color? titleColor;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontSize: isBold ? 18.sp(context) : 14.sp(context),
      fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
      color: isBold ? const Color(0xff3F3F3F) : const Color(0xff525252),
    );
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: isBold ? 18.sp(context) : 14.sp(context),
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: titleColor ?? const Color(0xff3F3F3F),
          ),
        ),
        const Spacer(),
        Text(value, style: textStyle),
      ],
    );
  }
}
