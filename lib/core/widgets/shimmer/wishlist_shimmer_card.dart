import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:shimmer/shimmer.dart';

class WishlistShimmerCard extends StatelessWidget {
  const  WishlistShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE7E7E7),
      highlightColor: const Color(0xFFF8F8F8),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFF1F1F1)),
          borderRadius: BorderRadius.circular(20.r(context)),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 96.w(context),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r(context)),
                  ),
                ),
                SizedBox(width: 12.w(context)),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 18.h(context),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.r(context)),
                        ),
                      ),
                      SizedBox(height: 10.h(context)),
                      Container(
                        height: 14.h(context),
                        width: 90.w(context),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.r(context)),
                        ),
                      ),
                      SizedBox(height: 14.h(context)),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: Container(
                      //         height: 36.h(context),
                      //         decoration: BoxDecoration(
                      //           color: Colors.white,
                      //           borderRadius: BorderRadius.circular(10.r(context)),
                      //         ),
                      //       ),
                      //     ),
                      //     SizedBox(width: 16.w(context)),
                      //     Container(
                      //       height: 18.h(context),
                      //       width: 18.w(context),
                      //       decoration: const BoxDecoration(
                      //         color: Colors.white,
                      //         shape: BoxShape.circle,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
