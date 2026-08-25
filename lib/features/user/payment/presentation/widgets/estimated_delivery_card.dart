import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class EstimatedDeliveryCard extends StatelessWidget {
  const EstimatedDeliveryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 18.w(context),
        vertical: 16.h(context),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCFA),
        borderRadius: BorderRadius.circular(14.r(context)),
        border: Border.all(color: const Color(0xFFF6E6DB)), 
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 15.sp(context),
                color: const Color(0xFFFF7A1A),
              ),
              SizedBox(width: 6.w(context)),
              Text(
                'Estimated Delivery Time',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 11.sp(context),
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFC6A893),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h(context)),
          Text(
            '30-40mins',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 28.sp(context),
              fontWeight: FontWeight.w700,
              color: const Color(0xFFFF7A1A),
            ),
          ),
          SizedBox(height: 6.h(context)),
          Text(
            "We'll notify you once your order is on the way.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 11.sp(context),
              fontWeight: FontWeight.w500,
              color: const Color(0xFFC0C0C0),
            ),
          ),
        ],
      ),
    );
  }
}
