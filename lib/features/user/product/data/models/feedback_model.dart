// lib/features/user/product/presentation/models/user_feedback_model.dart

class UserFeedbackModel {
  final String userName;
  final DateTime date;
  final double rating; // e.g. 4.0 out of 5
  final String comment;

  UserFeedbackModel({
    required this.userName,
    required this.date,
    required this.rating,
    required this.comment,
  });
}