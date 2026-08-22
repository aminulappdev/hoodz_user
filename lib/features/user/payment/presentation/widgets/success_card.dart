
import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/gen/assets.gen.dart';

class SuccessCard extends StatelessWidget {
  const SuccessCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CrashSafeImage(
          Assets.icons.checkMark02.path,
          width: 164.w(context),
        ),
        
        Text(
          'Order Placed Successfully!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(
                fontSize: 22.sp(context),
                fontWeight: FontWeight.w700,
                color: const Color(0xFF333333),
              ),
        ),
        SizedBox(height: 8.h(context)),
        Text(
          'Thank you for your purchase',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 13.sp(context),
            fontWeight: FontWeight.w500,
            color: const Color(0xFFB2B2B2),
          ),
        ),
      ],
    );
  }
}
