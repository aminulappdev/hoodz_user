import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class PaymentFormLabel extends StatelessWidget {
  final String text;

  const PaymentFormLabel({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontSize: 14.sp(context),
        fontWeight: FontWeight.w500,
        color: const Color(0xFF8B8B8B),
      ),
    );
  }
}
