import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class PaymentMethodCard extends StatelessWidget {
  final String iconData;
  final String maskedNumber;
  final String expiryLabel;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.iconData,
    required this.maskedNumber,
    required this.expiryLabel,
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
                : const Color(0xFFF6F6F6),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0x10000000),
              blurRadius: 18.r(context),
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            CrashSafeImage(iconData, width: 36.w(context)),
            SizedBox(width: 12.w(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    maskedNumber,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 15.sp(context),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF585858),
                    ),
                  ),
                  SizedBox(height: 4.h(context)),
                  Text(
                    expiryLabel,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 11.sp(context),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF9B9B9B),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 22.w(context),
                height: 22.w(context),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF6B00),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: 14.sp(context),
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
