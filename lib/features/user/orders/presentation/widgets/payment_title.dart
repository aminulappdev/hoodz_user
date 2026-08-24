import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:hoodz/features/user/orders/data/models/payment_model.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/radio_indicator.dart';
import 'package:hoodz/gen/assets.gen.dart';

class PaymentMethodTile extends StatelessWidget {
  final PaymentMethod method;
  final bool isSelected;
  final bool isLast;
  final VoidCallback onTap;

  const PaymentMethodTile({
    super.key,
    required this.method,
    required this.isSelected, 
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
        ),
        child: Row(
          children: [
            CrashSafeImage(Assets.icons.payPal.keyName, height: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.type,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${method.maskedNumber} • Expire ${method.expiry}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            RadioIndicator(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}
