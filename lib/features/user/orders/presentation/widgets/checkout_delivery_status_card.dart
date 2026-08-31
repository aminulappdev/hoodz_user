import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/checkout_section_card.dart';

class CheckoutDeliveryStatusCard extends StatelessWidget {
  const CheckoutDeliveryStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CheckoutSectionCard(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          const CheckoutStatusIconBubble(),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      Strings.delivery.tr,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8B8B8B),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      Strings.distance.tr,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8B8B8B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        Strings.arrivingInApprox20Mins.tr,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF323232),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '4.2 ${Strings.kilometer.tr}',
                      style: const TextStyle(
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
