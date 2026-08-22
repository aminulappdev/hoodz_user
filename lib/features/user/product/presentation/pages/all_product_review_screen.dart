import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/features/user/product/presentation/controller/all_product_review_controller.dart';
import 'package:hoodz/features/user/product/presentation/widgets/feedback_card.dart';
import 'package:hoodz/features/user/product/presentation/widgets/review_dropdown.dart';
import 'package:hoodz/features/user/product/presentation/widgets/review_summary_card.dart';

class AllProductReviewScreen extends GetView<AllProductReviewController> {
  const AllProductReviewScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final routeArguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    controller.initialize(routeArguments);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(label: 'Product Review'),
      body: SafeArea(
        child: Obx(
          () => SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              16.w(context),
              8.h(context),
              16.w(context),
              24.h(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReviewSummaryCard(controller: controller),
                SizedBox(height: 16.h(context)),
                Text(
                  "User's Review",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 18.sp(context),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF202020),
                  ),
                ),
                SizedBox(height: 12.h(context)),
                Row(
                  children: [
                    Expanded(
                      child: ReviewDropdown(
                        value: controller.selectedReviewFilter.value,
                        items: controller.reviewFilters,
                        onChanged: controller.updateReviewFilter,
                      ),
                    ),
                    SizedBox(width: 10.w(context)),
                    Expanded(
                      child: ReviewDropdown(
                        value: controller.selectedRatingFilter.value,
                        items: controller.ratingFilters,
                        onChanged: controller.updateRatingFilter,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h(context)),
                ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.feedbacks.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: 12.h(context)),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(12.w(context)),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8F8),
                        borderRadius: BorderRadius.circular(14.r(context)),
                        border: Border.all(color: const Color(0xFFEAEAEA)),
                      ),
                      child: UserFeedbackCard(
                        feedback: controller.feedbacks[index],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
