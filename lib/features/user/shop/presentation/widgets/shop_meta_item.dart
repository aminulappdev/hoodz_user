

import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class ShopMetaItem extends StatelessWidget {
  const ShopMetaItem({
    required this.label,
    this.icon,
    this.iconColor,
    this.leadingIcon,
  });

  final String label;
  final String? icon;
  final Color? iconColor;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null)
          CrashSafeImage(
            icon!,
            height: 14.h(context),
            width: 14.w(context),
            color: iconColor ?? const Color(0xff8B8B8B),
          ),
        if (leadingIcon != null)
          Icon(
            leadingIcon,
            size: 14.h(context),
            color: const Color(0xff8B8B8B),
          ),
        SizedBox(width: 4.w(context)),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 13.sp(context),
            fontWeight: FontWeight.w500,
            color: const Color(0xff767676),
          ),
        ),
      ],
    );
  }
}