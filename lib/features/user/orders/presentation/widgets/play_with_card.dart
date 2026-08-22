import 'package:flutter/material.dart';
import 'package:hoodz/features/user/orders/data/models/payment_model.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/delivery_card_container.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/payment_tile.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/payment_title.dart';

class PayWithSection extends StatelessWidget {
  final List<PaymentMethod> methods;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onAddCard;

  const PayWithSection({
    super.key,
    required this.methods,
    required this.selectedIndex,
    required this.onSelect,
    required this.onAddCard, 
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
              for (final entry in methods.asMap().entries)
                PaymentMethodTile(
                  method: entry.value,
                  isSelected: selectedIndex == entry.key,
                  isLast: false,
                  onTap: () => onSelect(entry.key),
                ),
              PaymentActionTile(
                icon: Icons.add_circle_outline,
                label: 'Add new card',
                isLast: false,
                onTap: onAddCard,
              ),
              PaymentActionTile(
                icon: Icons.payments_outlined,
                label: 'Cash',
                isLast: true,
                showRadio: true,
                // Convention: -1 means "Cash selected" (i.e. not any card
                // index). Keep this convention documented wherever it's
                // used, since a "magic number" like -1 is only clear if
                // it's explained once, here.
                isSelected: selectedIndex == -1,
                onTap: () => onSelect(-1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}