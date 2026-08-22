
import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class PaymentProviderText extends StatelessWidget {
  final String label;

  const PaymentProviderText({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6.w(context),
          height: 6.w(context),
          decoration: const BoxDecoration(
            color: Color(0xFFD6D6D6),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6.w(context)),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 12.sp(context),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF8B8B8B),
          ),
        ),
      ],
    );
  }
}
