import 'package:flutter/material.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/checkout_section_card.dart';

class CheckoutOrderDetailsCard extends StatelessWidget {
  const CheckoutOrderDetailsCard({
    super.key,
    required this.onChangeTap,
  });

  final VoidCallback onChangeTap;

  @override
  Widget build(BuildContext context) {
    return CheckoutSectionCard(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column( 
        children: [
          Row(
            children: [
              const Text(
                'Order Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF202020),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: onChangeTap,
                child: const Text(
                  'Change',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6F6F6F),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 8),
          const CheckoutOrderInfoRow(label: 'Name:', value: 'Abdur Ahmed'),
          const CheckoutOrderInfoRow(
            label: 'Phone:',
            value: '+9524549655',
          ),
          const CheckoutOrderInfoRow(
            label: 'Delivery Type:',
            value: 'Instant Delivery',
          ),
          const CheckoutOrderInfoRow(
            label: 'Address:',
            value: 'House 12, Road 5, Mohakhali, Dhaka',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class CheckoutOrderInfoRow extends StatelessWidget {
  const CheckoutOrderInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 4 : 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 92,
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFB0B0B0),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      color: Color(0xFF353535),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!isLast) const Divider(height: 1, color: Color(0xFFF3F3F3)),
        ],
      ),
    );
  }
}
