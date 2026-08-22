import 'package:get/get.dart';
import 'package:hoodz/features/user/product/data/models/feedback_model.dart';

class AllProductReviewController extends GetxController {
  final RxString title = 'Reviews'.obs;
  final RxString selectedReviewFilter = 'Most Relevant'.obs;
  final RxString selectedRatingFilter = 'Star rating'.obs;

  final List<String> reviewFilters = const [
    'Most Relevant',
    'Newest',
    'Oldest',
  ];

  final List<String> ratingFilters = const [
    'Star rating', 
    '5 Stars',
    '4 Stars',
    '3 Stars',
    '2 Stars',
    '1 Star',
  ];

  final List<int> ratingCounts = const [62, 5, 0, 0, 0];

  int get totalReviews => ratingCounts.fold(0, (sum, count) => sum + count);
  double get displayedRating => 5.0;

  double get averageRating {
    const weights = [5, 4, 3, 2, 1];
    double weightedSum = 0;

    for (var index = 0; index < ratingCounts.length; index++) {
      weightedSum += ratingCounts[index] * weights[index];
    }

    return totalReviews == 0 ? 0 : weightedSum / totalReviews;
  }

  final List<UserFeedbackModel> feedbacks = [
    UserFeedbackModel(
      userName: 'Annisa Azalea',
      date: DateTime(2022, 2, 6),
      rating: 4,
      comment:
          'In molestie sed dui nisi, egestas facilisis non. Pharetra, blandit tellus nisl ultrices egestas dui in suspendisse.',
    ),
    UserFeedbackModel(
      userName: 'Joko Rakabuming',
      date: DateTime(2022, 2, 6),
      rating: 4,
      comment:
          'In molestie sed dui nisi, egestas facilisis non. Pharetra, blandit tellus nisl ultrices egestas dui in suspendisse.',
    ),
    UserFeedbackModel(
      userName: 'Savannah Nguyen',
      date: DateTime(2022, 2, 6),
      rating: 4,
      comment:
          'In molestie sed dui nisi, egestas facilisis non. Pharetra, blandit tellus nisl ultrices egestas dui in suspendisse.',
    ),
    UserFeedbackModel(
      userName: 'Marvin McKinney',
      date: DateTime(2022, 2, 5),
      rating: 5,
      comment:
          'Really happy with the fabric quality and fit. Delivery was quick and the color matched the photos.',
    ),
  ];

  void initialize(Map<String, dynamic>? arguments) {
    title.value = arguments?['title'] as String? ?? 'Reviews';
  }

  void updateReviewFilter(String? value) {
    if (value == null) return;
    selectedReviewFilter.value = value;
  }

  void updateRatingFilter(String? value) {
    if (value == null) return;
    selectedRatingFilter.value = value;
  }
}
