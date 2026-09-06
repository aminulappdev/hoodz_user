import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/core/widgets/shimmer/product_list_shimmer.dart';
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
      appBar: CustomAppBar(label: controller.title.value),
      body: SafeArea(
        child: Obx(
          () {
            if (controller.isLoading.value &&
                controller.allReviewModel.value == null) {
              return const ProductReviewShimmer();
            }

            final feedbacks = controller.feedbacks;

            return RefreshIndicator(
              onRefresh: () => controller.fetchAllReviews(force: true),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                      Strings.usersReview.tr,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 18.sp(context),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF202020),
                      ),
                    ),
                    SizedBox(height: 12.h(context)),
                    Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: ReviewDropdown(
                              value: controller.selectedSort.value,
                              items: controller.sortFilters,
                              onChanged: controller.updateSort,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h(context)),
                    if (feedbacks.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w(context)),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(14.r(context)),
                          border: Border.all(color: const Color(0xFFEAEAEA)),
                        ),
                        child: Center(child: Text(Strings.noReviewsFound.tr)),
                      )
                    else
                      ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: feedbacks.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 12.h(context)),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.all(12.w(context)),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F8F8),
                              borderRadius: BorderRadius.circular(14.r(context)),
                              border: Border.all(
                                color: const Color(0xFFEAEAEA),
                              ),
                            ),
                            child: UserFeedbackCard(
                              feedback: feedbacks[index],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
