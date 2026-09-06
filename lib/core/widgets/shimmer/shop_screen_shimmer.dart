import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:shimmer/shimmer.dart';

class ShopScreenShimmer extends StatelessWidget {
  const ShopScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ShopHeaderShimmer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h(context)),
                _BoxShimmer(
                  height: 86.h(context),
                  width: double.infinity,
                  radius: 14.r(context),
                ),
                SizedBox(height: 20.h(context)),
                _BoxShimmer(
                  height: 20.h(context),
                  width: 150.w(context),
                  radius: 6.r(context),
                ),
                SizedBox(height: 12.h(context)),
                const ShopRecommendationShimmer(),
                SizedBox(height: 18.h(context)),
                _BoxShimmer(
                  height: 42.h(context),
                  width: double.infinity,
                  radius: 12.r(context),
                ),
                SizedBox(height: 20.h(context)),
                const ShopGridShimmer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShopDetailsShimmer extends StatelessWidget {
  const ShopDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _BoxShimmer(
                  height: 240.h(context),
                  width: double.infinity,
                  radius: 0,
                ),
                Positioned(
                  top: 16.h(context),
                  left: 16.w(context),
                  child: _BoxShimmer(
                    height: 42.h(context),
                    width: 42.w(context),
                    radius: 21.r(context),
                  ),
                ),
                Positioned(
                  left: 18.w(context),
                  bottom: -36.h(context),
                  child: _BoxShimmer(
                    height: 72.h(context),
                    width: 72.w(context),
                    radius: 36.r(context),
                  ),
                ),
              ],
            ),
            SizedBox(height: 58.h(context)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BoxShimmer(
                    height: 24.h(context),
                    width: 180.w(context),
                    radius: 6.r(context),
                  ),
                  SizedBox(height: 12.h(context)),
                  Row(
                    children: [
                      _BoxShimmer(
                        height: 28.h(context),
                        width: 82.w(context),
                        radius: 14.r(context),
                      ),
                      SizedBox(width: 10.w(context)),
                      _BoxShimmer(
                        height: 28.h(context),
                        width: 100.w(context),
                        radius: 14.r(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h(context)),
                  ...List.generate(
                    4,
                    (index) => Padding(
                      padding: EdgeInsets.only(bottom: 8.h(context)),
                      child: _BoxShimmer(
                        height: 13.h(context),
                        width: index.isEven
                            ? double.infinity
                            : 270.w(context),
                        radius: 5.r(context),
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h(context)),
                  _BoxShimmer(
                    height: 110.h(context),
                    width: double.infinity,
                    radius: 14.r(context),
                  ),
                  SizedBox(height: 20.h(context)),
                  _BoxShimmer(
                    height: 18.h(context),
                    width: 110.w(context),
                    radius: 5.r(context),
                  ),
                  SizedBox(height: 12.h(context)),
                  Wrap(
                    spacing: 10.w(context),
                    runSpacing: 10.h(context),
                    children: List.generate(
                      4,
                      (_) => _BoxShimmer(
                        height: 32.h(context),
                        width: 82.w(context),
                        radius: 16.r(context),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h(context)),
                  _BoxShimmer(
                    height: 150.h(context),
                    width: double.infinity,
                    radius: 14.r(context),
                  ),
                  SizedBox(height: 24.h(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShopRecommendationShimmer extends StatelessWidget {
  const ShopRecommendationShimmer({super.key, this.itemCount = 2});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h(context),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        separatorBuilder: (_, _) => SizedBox(width: 12.w(context)),
        itemBuilder: (_, _) => _BoxShimmer(
          height: 100.h(context),
          width: 180.w(context),
          radius: 20.r(context),
        ),
      ),
    );
  }
}

class ShopGridShimmer extends StatelessWidget {
  const ShopGridShimmer({super.key, this.itemCount = 4});

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
      itemBuilder: (_, _) => _BoxShimmer(
        height: 240.h(context),
        width: double.infinity,
        radius: 18.r(context),
      ),
    );
  }
}

class _ShopHeaderShimmer extends StatelessWidget {
  const _ShopHeaderShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BoxShimmer(
          height: 240.h(context),
          width: double.infinity,
          radius: 0,
        ),
        Transform.translate(
          offset: Offset(0, -18.h(context)),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              18.w(context),
              0,
              28.w(context),
              18.h(context),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _BoxShimmer(
                  height: 86.h(context),
                  width: 86.w(context),
                  radius: 43.r(context),
                ),
                SizedBox(width: 18.w(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _BoxShimmer(
                        height: 22.h(context),
                        width: 150.w(context),
                        radius: 6.r(context),
                      ),
                      SizedBox(height: 10.h(context)),
                      _BoxShimmer(
                        height: 12.h(context),
                        width: 190.w(context),
                        radius: 5.r(context),
                      ),
                      SizedBox(height: 8.h(context)),
                      _BoxShimmer(
                        height: 12.h(context),
                        width: 140.w(context),
                        radius: 5.r(context),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w(context)),
                _BoxShimmer(
                  height: 40.h(context),
                  width: 90.w(context),
                  radius: 10.r(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BoxShimmer extends StatelessWidget {
  const _BoxShimmer({
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
