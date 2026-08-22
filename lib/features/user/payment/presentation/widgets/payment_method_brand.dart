import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/payment/presentation/models/payment_method_item.dart';

class PaymentMethodBrand extends StatelessWidget {
  final PaymentMethodType type;

  const PaymentMethodBrand({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final label = switch (type) {
      PaymentMethodType.paypal => 'PayPal',
      PaymentMethodType.stripe => 'stripe',
    };

    final color = switch (type) {
      PaymentMethodType.paypal => const Color(0xFF0A68FF),
      PaymentMethodType.stripe => const Color(0xFF635BFF),
    };

    return Text(
      label,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontSize: 16.sp(context),
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }
}
