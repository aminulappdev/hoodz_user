import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:shimmer/shimmer.dart';

class ProfileContentShimmer extends StatelessWidget {
  const ProfileContentShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileShimmerLine(
            height: 18.h(context),
            width: 210.w(context),
          ),
          SizedBox(height: 18.h(context)),
          ...List.generate(
            10,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: 12.h(context)),
              child: _ProfileShimmerLine(
                height: 13.h(context),
                width: index % 3 == 0 ? double.infinity : 260.w(context),
              ),
            ),
          ),
          SizedBox(height: 8.h(context)),
          _ProfileShimmerLine(
            height: 13.h(context),
            width: double.infinity,
          ),
          SizedBox(height: 12.h(context)),
          _ProfileShimmerLine(
            height: 13.h(context),
            width: 220.w(context),
          ),
        ],
      ),
    );
  }
}

class ProfileHeaderShimmer extends StatelessWidget {
  const ProfileHeaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            _ProfileShimmerLine(
              height: 186.h(context),
              width: width,
              radius: 0,
            ),
            Positioned(
              bottom: -52.h(context),
              child: _ProfileShimmerLine(
                height: 112.h(context),
                width: 112.w(context),
                radius: 56.r(context),
              ),
            ),
          ],
        ),
        SizedBox(height: 68.h(context)),
        _ProfileShimmerLine(
          height: 22.h(context),
          width: 120.w(context),
          radius: 6.r(context),
        ),
        SizedBox(height: 10.h(context)),
        _ProfileShimmerLine(
          height: 14.h(context),
          width: 180.w(context),
          radius: 5.r(context),
        ),
      ],
    );
  }
}

class _ProfileShimmerLine extends StatelessWidget {
  const _ProfileShimmerLine({
    required this.height,
    required this.width,
    this.radius = 5,
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
