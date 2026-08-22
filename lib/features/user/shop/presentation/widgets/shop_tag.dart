import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class ShopTag extends StatelessWidget {
  const ShopTag({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
  });

  final String category;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w(context),
          vertical: 10.h(context),
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffFFF4EC) : const Color(0xffF5F5F5),
          borderRadius: BorderRadius.circular(24.r(context)),
          border: Border.all(
            color: isSelected ? const Color(0xffFF7A00) : Colors.transparent,
          ),
        ),
        child: Text(
          category,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 13.sp(context),
            fontWeight: FontWeight.w500,
            color: isSelected
                ? const Color(0xffFF7A00)
                : const Color(0xff6B6B6B),
          ),
        ),
      ),
    );
  }
}
