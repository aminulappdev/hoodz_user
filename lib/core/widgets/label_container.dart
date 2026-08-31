import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class LabelContainer extends StatelessWidget {
  final String? icon;
  final String name;
  final Color contentColor;
  final Color backgroundColor;
  const LabelContainer({
    super.key,
    this.icon,
    required this.name,
    required this.contentColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r(context)),
        color: backgroundColor.withValues(alpha: 0.06),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w(context),
          vertical: 4.h(context),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              CrashSafeImage(
                icon!,
                height: 16.h(context),
                width: 16.w(context),
                color: contentColor,
              ),
              SizedBox(width: 5.w(context)),
            ],
            Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp(context),
                color: contentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
