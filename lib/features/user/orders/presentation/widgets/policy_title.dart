
import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class ProductInfoTile extends StatelessWidget {
  const ProductInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final Widget icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 28.h(context),
          width: 28.w(context),
          child: Center(child: icon),
        ),
        SizedBox(width: 14.w(context)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 15.sp(context),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff414141),
                ),
              ),
              SizedBox(height: 4.h(context)),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 13.sp(context),
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff8B8B8B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}