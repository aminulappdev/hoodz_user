
import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class SizePlate extends StatelessWidget {
  const SizePlate({
    super.key,
    required this.size,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
  });

  final String size;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42.h(context),
      width: 78.w(context),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24.r(context)),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Center(
        child: Text(
          size,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 14.sp(context),
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
