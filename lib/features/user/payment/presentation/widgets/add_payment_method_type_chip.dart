import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/payment/presentation/models/payment_method_item.dart';
import 'package:hoodz/gen/assets.gen.dart';

class AddPaymentMethodTypeChip extends StatelessWidget {
  final PaymentMethodType type;
  final bool isSelected;
  final VoidCallback onTap;

  const AddPaymentMethodTypeChip({
    super.key,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? const Color(0xFFFF7A1A)
        : const Color(0xFFEDEDED);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42.w(context),
        height: 42.w(context),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r(context)),
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: CrashSafeImage(
            _assetPath(type),
            width: 26.w(context),
            height: 18.h(context),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  String _assetPath(PaymentMethodType type) {
    switch (type) {
      case PaymentMethodType.paypal:
        return Assets.icons.payPal.path;
      case PaymentMethodType.stripe:
        return Assets.icons.stripe.path;
    }
  }
}
