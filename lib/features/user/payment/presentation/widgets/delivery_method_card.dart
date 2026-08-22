import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/payment/presentation/models/delivery_method_item.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/delivery_icons.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/payment_provider_text.dart';

class DeliveryMethodCard extends StatelessWidget {
  final String title;
  final List<String> providers;
  final DeliveryMethodType type;
  final bool isSelected;
  final VoidCallback onTap;

  const DeliveryMethodCard({
    super.key,
    required this.title,
    required this.providers,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w(context),
          vertical: 14.h(context),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r(context)),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFF7A1A)
                : const Color(0xFFF1F1F1),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0x14000000),
              blurRadius: 20.r(context),
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DeliveryMethodIconWidget(
              type: type,
              isSelected: isSelected,
            ),
            SizedBox(width: 14.w(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 14.sp(context),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF363636),
                    ),
                  ),
                  SizedBox(height: 6.h(context)),
                  Wrap(
                    spacing: 10.w(context),
                    runSpacing: 4.h(context),
                    children: providers
                        .map(
                          (provider) => PaymentProviderText(label: provider),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
