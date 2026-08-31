import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/checkout_section_card.dart';

class CheckoutOrderDetailsCard extends StatelessWidget {
  const CheckoutOrderDetailsCard({
    super.key,
    required this.onChangeTap,
    required this.name,
    required this.phone,
    required this.deliveryType,
    required this.address,
  });

  final VoidCallback onChangeTap;
  final String name;
  final String phone;
  final String deliveryType;
  final String address;

  @override
  Widget build(BuildContext context) {
    return CheckoutSectionCard(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column( 
        children: [
          Row(
            children: [
              Text(
                Strings.orderDetails.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF202020),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: onChangeTap,
                child: Text(
                  Strings.change.tr,
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
          CheckoutOrderInfoRow(label: Strings.name.tr, value: name),
          CheckoutOrderInfoRow(
            label: Strings.phone.tr,
            value: phone,
          ),
          CheckoutOrderInfoRow(
            label: Strings.deliveryType.tr,
            value: deliveryType,
          ),
          CheckoutOrderInfoRow(
            label: Strings.address.tr,
            value: address,
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
