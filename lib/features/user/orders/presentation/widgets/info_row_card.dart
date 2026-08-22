import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/delivery_card_container.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/icon_bubble.dart';

class InfoRowCard extends StatelessWidget {
  final IconData icon;
  final Color? iconBg;
  final Color? iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;

  const InfoRowCard({
    super.key,
    required this.icon,
    this.iconBg,
    this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return DeliveryCardContainer(
      child: Row(
        children: [
          IconBubble(icon: icon, background: iconBg, iconColor: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          trailing,
        ],
      ),
    );
  }
}