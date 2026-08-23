import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:shimmer/shimmer.dart';

class ShopProductRecommendationShimmer extends StatelessWidget {
  const ShopProductRecommendationShimmer({super.key, this.itemCount = 2});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h(context),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        separatorBuilder: (_, __) => SizedBox(width: 12.w(context)),
        itemBuilder: (context, index) {
          return const _RecommendationShimmerCard();
        },
      ),
    );
  }
}

class ShopProductGridShimmer extends StatelessWidget {
  const ShopProductGridShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
   Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w(context),
        mainAxisSpacing: 12.h(context),
        childAspectRatio: 0.68,
      ),
      itemBuilder: (context, index) {
        return const _GridShimmerCard();
      },
    );
  }
}

class _RecommendationShimmerCard extends StatelessWidget {
  const _RecommendationShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE7E7E7),
      highlightColor: const Color(0xFFF8F8F8),
      child: Container(
        width: 180.w(context),
        padding: EdgeInsets.all(10.w(context)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r(context)),
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
                  borderRadius: BorderRadius.circular(16.r(context)),
                ),
              ),
            ),
            SizedBox(height: 12.h(context)),
            Container(
              height: 14.h(context),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.r(context)),
              ),
            ),
            SizedBox(height: 8.h(context)),
            Container(
              height: 12.h(context),
              width: 90.w(context),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.r(context)),
              ),
            ),
            SizedBox(height: 12.h(context)),
            Container(
              height: 18.h(context),
              width: 70.w(context),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.r(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridShimmerCard extends StatelessWidget {
  const _GridShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE7E7E7),
      highlightColor: const Color(0xFFF8F8F8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r(context)),
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
                    top: Radius.circular(18.r(context)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.w(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14.h(context),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.r(context)),
                    ),
                  ),
                  SizedBox(height: 8.h(context)),
                  Container(
                    height: 12.h(context),
                    width: 70.w(context),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.r(context)),
                    ),
                  ),
                  SizedBox(height: 10.h(context)),
                  Container(
                    height: 18.h(context),
                    width: 80.w(context),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.r(context)),
                    ),
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
