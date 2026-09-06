import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:shimmer/shimmer.dart';

class ProductGridShimmer extends StatelessWidget {
  const ProductGridShimmer({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(
        20.w(context),
        12.h(context),
        20.w(context),
        20.h(context),
      ),
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14.w(context),
        mainAxisSpacing: 14.h(context),
        childAspectRatio: 0.7,
      ),
      itemBuilder: (_, _) => const _ProductListShimmerCard(),
    );
  }
}

class ProductReviewShimmer extends StatelessWidget {
  const ProductReviewShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        16.w(context),
        8.h(context),
        16.w(context),
        24.h(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ReviewShimmerBox(
            height: 150.h(context),
            width: double.infinity,
            radius: 14.r(context),
          ),
          SizedBox(height: 18.h(context)),
          _ReviewShimmerBox(
            height: 20.h(context),
            width: 150.w(context),
            radius: 6.r(context),
          ),
          SizedBox(height: 12.h(context)),
          _ReviewShimmerBox(
            height: 44.h(context),
            width: double.infinity,
            radius: 10.r(context),
          ),
          SizedBox(height: 14.h(context)),
          ...List.generate(
            itemCount,
            (_) => Padding(
              padding: EdgeInsets.only(bottom: 12.h(context)),
              child: _ReviewShimmerBox(
                height: 112.h(context),
                width: double.infinity,
                radius: 14.r(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductListShimmerCard extends StatelessWidget {
  const _ProductListShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE7E7E7),
      highlightColor: const Color(0xFFF8F8F8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r(context)),
          border: Border.all(color: const Color(0xFFF1F1F1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r(context)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.w(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ReviewShimmerBox(
                    height: 14.h(context),
                    width: double.infinity,
                    radius: 5.r(context),
                  ),
                  SizedBox(height: 8.h(context)),
                  _ReviewShimmerBox(
                    height: 12.h(context),
                    width: 72.w(context),
                    radius: 5.r(context),
                  ),
                  SizedBox(height: 10.h(context)),
                  _ReviewShimmerBox(
                    height: 18.h(context),
                    width: 82.w(context),
                    radius: 5.r(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewShimmerBox extends StatelessWidget {
  const _ReviewShimmerBox({
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
