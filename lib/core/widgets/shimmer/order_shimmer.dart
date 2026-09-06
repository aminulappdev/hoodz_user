import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:shimmer/shimmer.dart';

class OrderListShimmer extends StatelessWidget {
  const OrderListShimmer({
    super.key,
    this.itemCount = 4,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => SizedBox(height: 16.h(context)),
      itemBuilder: (context, index) {
        return const _OrderShimmerCard();
      },
    );
  }
}

class CartListShimmer extends StatelessWidget {
  const CartListShimmer({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        20.w(context),
        8.h(context),
        20.w(context),
        220.h(context),
      ),
      itemCount: itemCount,
      separatorBuilder: (_, _) => SizedBox(height: 18.h(context)),
      itemBuilder: (_, _) => const _CartShimmerCard(),
    );
  }
}

class SavedLocationListShimmer extends StatelessWidget {
  const SavedLocationListShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const Divider(
        height: 1,
        thickness: 1,
        color: Color(0xFFEDEDED),
      ),
      itemBuilder: (_, _) => Padding(
        padding: EdgeInsets.fromLTRB(
          16.w(context),
          14.h(context),
          20.w(context),
          14.h(context),
        ),
        child: Row(
          children: [
            _OrderShimmerBox(
              height: 20.h(context),
              width: 20.w(context),
              radius: 10.r(context),
            ),
            SizedBox(width: 12.w(context)),
            _OrderShimmerBox(
              height: 22.h(context),
              width: 22.w(context),
              radius: 11.r(context),
            ),
            SizedBox(width: 12.w(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _OrderShimmerBox(
                    height: 14.h(context),
                    width: 120.w(context),
                    radius: 5.r(context),
                  ),
                  SizedBox(height: 7.h(context)),
                  _OrderShimmerBox(
                    height: 12.h(context),
                    width: double.infinity,
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

class _CartShimmerCard extends StatelessWidget {
  const _CartShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE8E8E8),
      highlightColor: const Color(0xFFF8F8F8),
      child: Container(
        height: 136.h(context),
        padding: EdgeInsets.all(12.w(context)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r(context)),
          border: Border.all(color: const Color(0xFFF1F1F1)),
        ),
        child: Row(
          children: [
            Container(
              width: 100.w(context),
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r(context)),
              ),
            ),
            SizedBox(width: 12.w(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _OrderShimmerBox(
                    height: 16.h(context),
                    width: double.infinity,
                    radius: 6.r(context),
                  ),
                  SizedBox(height: 10.h(context)),
                  _OrderShimmerBox(
                    height: 12.h(context),
                    width: 100.w(context),
                    radius: 5.r(context),
                  ),
                  SizedBox(height: 10.h(context)),
                  _OrderShimmerBox(
                    height: 18.h(context),
                    width: 74.w(context),
                    radius: 6.r(context),
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

class _OrderShimmerBox extends StatelessWidget {
  const _OrderShimmerBox({
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
      baseColor: const Color(0xFFE8E8E8),
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

class _OrderShimmerCard extends StatelessWidget {
  const _OrderShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE8E8E8),
      highlightColor: const Color(0xFFF8F8F8),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.w(context)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r(context)),
          border: Border.all(color: const Color(0xFFF1F1F1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80.w(context),
                  height: 80.h(context),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r(context)),
                  ),
                ),
                SizedBox(width: 12.w(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 16.h(context),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r(context)),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w(context)),
                          Container(
                            height: 22.h(context),
                            width: 74.w(context),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999.r(context)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h(context)),
                      Container(
                        height: 12.h(context),
                        width: 110.w(context),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.r(context)),
                        ),
                      ),
                      SizedBox(height: 8.h(context)),
                      Container(
                        height: 12.h(context),
                        width: 88.w(context),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.r(context)),
                        ),
                      ),
                      SizedBox(height: 10.h(context)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 12.h(context),
                            width: 90.w(context),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6.r(context)),
                            ),
                          ),
                          Container(
                            height: 12.h(context),
                            width: 56.w(context),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6.r(context)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h(context)),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48.h(context),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.r(context)),
                    ),
                  ),
                ),
                SizedBox(width: 12.w(context)),
                Expanded(
                  child: Container(
                    height: 48.h(context),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.r(context)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
