import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/radio_indicator.dart';

class PaymentActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isLast;
  final bool showRadio;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.isLast,
    required this.onTap,
    this.showRadio = false,
    this.isSelected = false,
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
            Icon(icon, color: Colors.grey.shade600, size: 22),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 14, color: Colors.black87))),
            if (showRadio) RadioIndicator(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}