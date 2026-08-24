import 'package:flutter/material.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/core/widgets/custom_text_field.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/checkout_section_card.dart';

class CheckoutVoucherPointsCard extends StatelessWidget {
  const CheckoutVoucherPointsCard({
    super.key,
    required this.voucherController,
    required this.isPointsEnabled,
    required this.onPointsChanged,
    required this.onApplyVoucher,
    required this.availablePointsLabel,
  });
 
  final TextEditingController voucherController;
  final bool isPointsEnabled;
  final ValueChanged<bool> onPointsChanged;
  final VoidCallback onApplyVoucher;
  final String availablePointsLabel;

  @override
  Widget build(BuildContext context) {
    return CheckoutSectionCard(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Voucher & Points',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF202020),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: onApplyVoucher,
                child:  Text(
                  'Apply',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: LightThemeColors.primaryColor,
                    decoration: TextDecoration.underline,
                    decorationColor: LightThemeColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 10),
          CustomTextField(
            controller: voucherController,
            hintText: 'Enter voucher code',
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Use points',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF353535),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      availablePointsLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => onPointsChanged(!isPointsEnabled),
                child: SizedBox(
                  height: 40,
                  width: 72,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Switch.adaptive(
                      value: isPointsEnabled,
                      onChanged: onPointsChanged,
                      inactiveThumbColor: Colors.black45,
                      inactiveTrackColor: Colors.grey.shade300,
                      activeColor: const Color(0xFFE8622C),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
