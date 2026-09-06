import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailsShimmer extends StatelessWidget {
  const ProductDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProductShimmerBox(
            height: 200.h(context),
            width: double.infinity,
            radius: 12.r(context),
          ),
          SizedBox(height: 8.h(context)),
          SizedBox(
            height: 100.h(context),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, _) => SizedBox(width: 10.w(context)),
              itemBuilder: (_, _) => _ProductShimmerBox(
                height: 100.h(context),
                width: 88.w(context),
                radius: 10.r(context),
              ),
            ),
          ),
          SizedBox(height: 18.h(context)),
          _ProductShimmerBox(
            height: 24.h(context),
            width: 250.w(context),
            radius: 6.r(context),
          ),
          SizedBox(height: 12.h(context)),
          Row(
            children: [
              _ProductShimmerBox(
                height: 20.h(context),
                width: 86.w(context),
                radius: 6.r(context),
              ),
              SizedBox(width: 12.w(context)),
              _ProductShimmerBox(
                height: 16.h(context),
                width: 110.w(context),
                radius: 5.r(context),
              ),
            ],
          ),
          SizedBox(height: 18.h(context)),
          _ProductShimmerBox(
            height: 54.h(context),
            width: double.infinity,
            radius: 12.r(context),
          ),
          SizedBox(height: 20.h(context)),
          _ProductShimmerBox(
            height: 18.h(context),
            width: 120.w(context),
            radius: 5.r(context),
          ),
          SizedBox(height: 12.h(context)),
          Row(
            children: List.generate(
              4,
              (_) => Padding(
                padding: EdgeInsets.only(right: 10.w(context)),
                child: _ProductShimmerBox(
                  height: 38.h(context),
                  width: 44.w(context),
                  radius: 8.r(context),
                ),
              ),
            ),
          ),
          SizedBox(height: 22.h(context)),
          _ProductShimmerBox(
            height: 18.h(context),
            width: 150.w(context),
            radius: 5.r(context),
          ),
          SizedBox(height: 10.h(context)),
          ...List.generate(
            4,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: 8.h(context)),
              child: _ProductShimmerBox(
                height: 12.h(context),
                width: index.isEven ? double.infinity : 280.w(context),
                radius: 4.r(context),
              ),
            ),
          ),
          SizedBox(height: 18.h(context)),
          const Divider(color: Color(0xffEAEAEA)),
          SizedBox(height: 18.h(context)),
          _ProductShimmerBox(
            height: 70.h(context),
            width: double.infinity,
            radius: 12.r(context),
          ),
          SizedBox(height: 24.h(context)),
          _ProductShimmerBox(
            height: 18.h(context),
            width: 170.w(context),
            radius: 5.r(context),
          ),
          SizedBox(height: 12.h(context)),
          SizedBox(
            height: 266.h(context),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              separatorBuilder: (_, _) => SizedBox(width: 14.w(context)),
              itemBuilder: (_, _) => _ProductShimmerBox(
                height: 266.h(context),
                width: 190.w(context),
                radius: 16.r(context),
              ),
            ),
          ),
          SizedBox(height: 28.h(context)),
        ],
      ),
    );
  }
}

class _ProductShimmerBox extends StatelessWidget {
  const _ProductShimmerBox({
    required this.height,
    required this.width,
    required this.radius,
  });

  final double height;
  final double width;
  final double radius;

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
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
