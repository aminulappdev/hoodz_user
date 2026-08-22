import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class AddPaymentMethodButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddPaymentMethodButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44.h(context),
        padding: EdgeInsets.symmetric(horizontal: 24.w(context)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999.r(context)),
          border: Border.all(color: const Color(0xFFF7F1EC)),
          boxShadow: [
            BoxShadow(
              color: const Color(0x0A000000),
              blurRadius: 18.r(context),
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18.w(context),
              height: 18.w(context),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFF7A1A)),
              ),
              child: Icon(
                Icons.add,
                size: 12.sp(context),
                color: const Color(0xFFFF7A1A),
              ),
            ),
            SizedBox(width: 10.w(context)),
            Text( 
              'Add payment method',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 15.sp(context),
                fontWeight: FontWeight.w600,
                color: const Color(0xFFFF7A1A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
