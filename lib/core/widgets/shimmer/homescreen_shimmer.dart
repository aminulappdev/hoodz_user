import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:shimmer/shimmer.dart';

class HomeShimmerBox extends StatelessWidget {
  const HomeShimmerBox({
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

class HomeCategoryShimmer extends StatelessWidget {
  const HomeCategoryShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.h(context),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        separatorBuilder: (_, _) => SizedBox(width: 10.w(context)),
        itemBuilder: (_, _) => HomeShimmerBox(
          height: 120.h(context),
          width: 92.w(context),
          radius: 14.r(context),
        ),
      ),
    );
  }
}

class HomeBrandListShimmer extends StatelessWidget {
  const HomeBrandListShimmer({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: 8.h(context)),
          child: HomeShimmerBox(
            height: 82.h(context),
            width: double.infinity,
            radius: 14.r(context),
          ),
        ),
      ),
    );
  }
}

class HomeCampaignShimmer extends StatelessWidget {
  const HomeCampaignShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        20.w(context),
        16.h(context),
        20.w(context),
        24.h(context),
      ),
      children: [
        HomeShimmerBox(
          height: 180.h(context),
          width: double.infinity,
          radius: 14.r(context),
        ),
        SizedBox(height: 18.h(context)),
        HomeShimmerBox(
          height: 22.h(context),
          width: 180.w(context),
          radius: 6.r(context),
        ),
        SizedBox(height: 16.h(context)),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14.w(context),
            mainAxisSpacing: 14.h(context),
            childAspectRatio: 0.7,
          ),
          itemBuilder: (_, _) => HomeShimmerBox(
            height: 240.h(context),
            width: double.infinity,
            radius: 16.r(context),
          ),
        ),
      ],
    );
  }
}

class HomeFilterShimmer extends StatelessWidget {
  const HomeFilterShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeShimmerBox(
            height: 20.h(context),
            width: 150.w(context),
            radius: 6.r(context),
          ),
          SizedBox(height: 20.h(context)),
          ...List.generate(
            5,
            (_) => Padding(
              padding: EdgeInsets.only(bottom: 18.h(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeShimmerBox(
                    height: 16.h(context),
                    width: 90.w(context),
                    radius: 5.r(context),
                  ),
                  SizedBox(height: 10.h(context)),
                  Wrap(
                    spacing: 8.w(context),
                    runSpacing: 8.h(context),
                    children: List.generate(
                      3,
                      (_) => HomeShimmerBox(
                        height: 34.h(context),
                        width: 76.w(context),
                        radius: 18.r(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
