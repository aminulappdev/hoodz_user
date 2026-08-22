// lib/features/user/product/presentation/widgets/user_feedback_card.dart

import 'package:flutter/material.dart';
import 'package:hoodz/features/user/product/data/models/feedback_model.dart';
import 'package:hoodz/features/user/product/presentation/widgets/rating_row.dart';
import 'package:intl/intl.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class UserFeedbackCard extends StatelessWidget {
  final UserFeedbackModel feedback;

  const UserFeedbackCard({super.key, required this.feedback});

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
          const Divider(
            color: Color(0xffEAEAEA),
          ), // thin separator like the image
        ],
      ),
    );
  }
}
