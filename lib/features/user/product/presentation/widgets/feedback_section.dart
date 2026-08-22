// lib/features/user/product/presentation/widgets/user_feedback_section.dart

import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/product/data/models/feedback_model.dart';
import 'package:hoodz/features/user/product/presentation/widgets/feedback_card.dart';

class UserFeedbackSection extends StatelessWidget {
  final List<UserFeedbackModel> feedbacks;

  const UserFeedbackSection({super.key, required this.feedbacks});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.w(context)),
          decoration: BoxDecoration(
            color: Color(0xFFF3F3F3),
            borderRadius: BorderRadius.circular(12.h(context)),
            border: Border.all(
              color: const Color(0xFFE7E7E7),
              width: 1.w(context),
            ),
          ),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: feedbacks.length,
            itemBuilder: (context, index) {
              return UserFeedbackCard(feedback: feedbacks[index]);
            },
          ),
        ),
      ],
    );
  }
}
