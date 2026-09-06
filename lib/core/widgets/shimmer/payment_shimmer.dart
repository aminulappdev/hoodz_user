import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:shimmer/shimmer.dart';

class PaymentShimmerBox extends StatelessWidget {
  const PaymentShimmerBox({
    super.key,
    required this.height,
    required this.width,
    this.radius = 8,
    this.circle = false,
  });

  final double height;
  final double width;
  final double radius;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE7E7E7),
      highlightColor: const Color(0xFFF8F8F8),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: circle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: circle ? null : BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

class PaymentDetailsShimmer extends StatelessWidget {
  const PaymentDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        14.w(context),
        12.h(context),
        14.w(context),
        24.h(context),
      ),
      child: Column(
        children: [
          PaymentShimmerBox(
            height: 90.h(context),
            width: double.infinity,
            radius: 14.r(context),
          ),
          SizedBox(height: 14.h(context)),
          PaymentShimmerBox(
            height: 140.h(context),
            width: double.infinity,
            radius: 14.r(context),
          ),
          SizedBox(height: 14.h(context)),
          PaymentShimmerBox(
            height: 180.h(context),
            width: double.infinity,
            radius: 14.r(context),
          ),
          SizedBox(height: 14.h(context)),
          PaymentShimmerBox(
            height: 110.h(context),
            width: double.infinity,
            radius: 14.r(context),
          ),
        ],
      ),
    );
  }
}

class PaymentTransactionShimmer extends StatelessWidget {
  const PaymentTransactionShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (_) => Padding(
          padding: EdgeInsets.only(bottom: 12.h(context)),
          child: PaymentShimmerBox(
            height: 76.h(context),
            width: double.infinity,
            radius: 14.r(context),
          ),
        ),
      ),
    );
  }
}
