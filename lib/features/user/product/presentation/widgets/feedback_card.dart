// lib/features/user/product/presentation/widgets/user_feedback_card.dart

import 'package:flutter/material.dart';
import 'package:hoodz/core/services/others/image_preview_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/app_cached_network_image.dart';
import 'package:hoodz/features/user/product/data/models/feedback_model.dart';
import 'package:hoodz/features/user/product/presentation/widgets/rating_row.dart';
import 'package:intl/intl.dart';

class UserFeedbackCard extends StatelessWidget {
  final UserFeedbackModel feedback;

  const UserFeedbackCard({super.key, required this.feedback});

  Future<void> _showImagePreview({
    required BuildContext context,
    required List<String> images,
    int initialIndex = 0,
  }) async {
    await ImagePreviewService.show(
      context: context,
      images: images,
      initialIndex: initialIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.h(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: name + stars on opposite ends
          Row(
            children: [
              Text(
                feedback.userName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp(context),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff2D2D2D),
                ),
              ),
              const Spacer(), // pushes stars to the right edge
              StarRatingRow(rating: feedback.rating, size: 14.w(context)),
            ],
          ),
          SizedBox(height: 4.h(context)),
          Text(
            DateFormat('d MMMM y').format(feedback.date), // "6 February 2022"
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 12.sp(context),
              color: const Color(0xff9B9B9B),
            ),
          ),
          SizedBox(height: 4.h(context)),
          Text(
            feedback.comment,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 13.sp(context),
              height: 1.6,
              color: const Color(0xff7B7B7B),
            ),
          ),
          if (feedback.images.isNotEmpty) ...[
            SizedBox(height: 10.h(context)),
            SizedBox(
              height: 74.h(context),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: feedback.images.length,
                separatorBuilder: (context, index) => SizedBox(
                  width: 8.w(context),
                ),
                itemBuilder: (context, index) {
                  final imageUrl = feedback.images[index];
                  return GestureDetector(
                    onTap: () {
                      _showImagePreview(
                        context: context,
                        images: feedback.images,
                        initialIndex: index,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r(context)),
                      child: AppCachedNetworkImage(
                        imageUrl: imageUrl,
                        imageHeight: 74.h(context),
                        imageWidth: 74.w(context),
                        imageFit: BoxFit.cover,
                        radius: 10.r(context),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          const Divider(
            color: Color(0xffEAEAEA),
          ), // thin separator like the image
        ],
      ),
    );
  }
}
