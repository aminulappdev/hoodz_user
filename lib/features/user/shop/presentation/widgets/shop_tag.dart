import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class ShopTag extends StatelessWidget {
  const ShopTag({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w(context),
        vertical: 10.h(context),
      ),
      decoration: BoxDecoration(
        color: const Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(24.r(context)),
      ),
      child: Text(
        category,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 13.sp(context),
          fontWeight: FontWeight.w500,
          color: const Color(0xff6B6B6B),
        ),
      ),
    );
  }
}
