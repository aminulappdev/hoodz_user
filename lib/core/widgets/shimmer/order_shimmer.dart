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
