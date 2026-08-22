import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class VoucherCard extends StatelessWidget {
  const VoucherCard({super.key});

  @override 
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14.w(context),
        vertical: 14.h(context),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r(context)),
        border: Border.all(color: const Color(0xffEAEAEA)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.discount_outlined,
            color: const Color(0xff8B8B8B),
            size: 20.sp(context),
          ),
          SizedBox(width: 10.w(context)),
          Expanded(
            child: Text(
              "20% Mastercard Card 'MASTERCARD'",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp(context),
                fontWeight: FontWeight.w500,
                color: const Color(0xff666666),
              ),
            ),
          ),
          Text(
            'Apply',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp(context),
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
              color: const Color(0xff666666),
            ),
          ),
        ],
      ),
    );
  }
}
