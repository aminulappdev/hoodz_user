import 'package:flutter/material.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/checkout_section_card.dart';

class CheckoutDeliveryStatusCard extends StatelessWidget {
  const CheckoutDeliveryStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const CheckoutSectionCard(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          CheckoutStatusIconBubble(),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Delivery',
                      style: TextStyle(fontSize: 12, color: Color(0xFF8B8B8B)),
                    ),
                    Spacer(),
                    Text(
                      'Distance',
                      style: TextStyle(fontSize: 12, color: Color(0xFF8B8B8B)),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Arriving in approx 20 mins',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF323232),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      '4.2 km',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF323232),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CheckoutStatusIconBubble extends StatelessWidget {
  const CheckoutStatusIconBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: const BoxDecoration(
        color: Color(0xFFE5F8EA),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.access_time, color: Color(0xFF2FB15B), size: 16),
    );
  }
}
