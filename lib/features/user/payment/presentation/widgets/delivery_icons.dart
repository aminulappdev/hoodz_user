
import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/payment/presentation/models/delivery_method_item.dart';

class DeliveryMethodIconWidget extends StatelessWidget {
  final DeliveryMethodType type;
  final bool isSelected;

  const DeliveryMethodIconWidget({
    super.key,
    required this.type,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34.w(context),
      height: 34.w(context),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? const Color(0xFFFF6B00) : const Color(0xFFF7F7F7),
      ),
      child: Icon(
        _resolveIcon(type),
        size: 18.sp(context),
        color: isSelected ? Colors.white : const Color(0xFF8F8F8F),
      ),
    );
  }

  IconData _resolveIcon(DeliveryMethodType type) {
    switch (type) {
      case DeliveryMethodType.card:
        return Icons.credit_card_rounded;
      case DeliveryMethodType.wallet:
        return Icons.account_balance_wallet_outlined;
      case DeliveryMethodType.cashOnDelivery:
        return Icons.local_shipping_outlined;
    }
  }
}
