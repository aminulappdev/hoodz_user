import 'package:flutter/material.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/delivery_card_container.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/payment_tile.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/payment_title.dart';

class PayWithSection extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const PayWithSection({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pay with', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        DeliveryCardContainer(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              PaymentActionTile(
                icon: Icons.credit_card_outlined,
                label: 'My Card',
                isLast: false,
                showRadio: true,
                isSelected: selectedIndex == 0,
                onTap: () => onSelect(0),
              ),
              PaymentActionTile(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Wallet',
                isLast: false,
                showRadio: true,
                isSelected: selectedIndex == 1,
                onTap: () => onSelect(1),
              ),
              PaymentActionTile(
                icon: Icons.payments_outlined,
                label: 'Cash',
                isLast: true,
                showRadio: true,
                isSelected: selectedIndex == 2,
                onTap: () => onSelect(2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
