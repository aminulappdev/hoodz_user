import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/product/presentation/controller/all_product_review_controller.dart';
import 'package:hoodz/features/user/product/presentation/widgets/rating_row.dart';

class ReviewSummaryCard extends StatelessWidget {
  const ReviewSummaryCard({super.key, required this.controller});
  final AllProductReviewController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r(context)),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.reviewTitle.tr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 15.sp(context),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF202020),
            ),
          ),
          SizedBox(height: 12.h(context)),
          const Divider(height: 1, color: Color(0xFFEAEAEA)),
          SizedBox(height: 12.h(context)),
          Row(
            children: [
              Text(
                '${Strings.totalReviews.tr}(${controller.totalReviews})',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 13.sp(context),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF303030),
                ),
              ),
              const Spacer(),
              StarRatingRow(rating: controller.displayedRating, size: 16.w(context)),
              SizedBox(width: 8.w(context)),
              Text(
                controller.displayedRating.toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp(context),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF202020),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h(context)),
          ...List.generate(controller.ratingCounts.length, (index) {
            final star = 5 - index;
            final count = controller.ratingCounts[index];
            final progress = controller.totalReviews == 0
                ? 0.0
                : count / controller.totalReviews;

            return Padding(
              padding: EdgeInsets.only(bottom: 12.h(context)),
              child: Row(
                children: [
                  SizedBox(
                    width: 52.w(context),
                    child: Text(
                      '$star ${Strings.stars.tr}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12.sp(context),
                        color: star >= 4
                            ? const Color(0xFF202020)
                            : const Color(0xFF9A9A9A),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w(context)),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r(context)),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6.h(context),
                        backgroundColor: const Color(0xFFE7E7E7),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          star >= 4 ? Colors.black : const Color(0xFFD6D6D6),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w(context)),
                  SizedBox(
                    width: 28.w(context),
                    child: Text(
                      '($count)',
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12.sp(context),
                        color: star >= 4
                            ? const Color(0xFF202020)
                            : const Color(0xFF9A9A9A),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
