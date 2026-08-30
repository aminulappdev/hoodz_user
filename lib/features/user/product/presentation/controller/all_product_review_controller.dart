import 'package:get/get.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/urls.dart';
import 'package:hoodz/features/user/homescreen/data/models/all_review_mdel.dart';
import 'package:hoodz/features/user/product/data/models/feedback_model.dart';

class AllProductReviewController extends GetxController {
  AllProductReviewController() : _networkCaller = Get.find<NetworkCaller>();

  final NetworkCaller _networkCaller;

  final RxString title = 'Reviews'.obs;
  final RxString selectedSort = 'latest'.obs;
  final RxBool isLoading = false.obs;
  final Rxn<AllReviewModel> allReviewModel = Rxn<AllReviewModel>();

  String? _productId;
  String? _loadedProductId;

  final List<String> sortFilters = const [
    'latest',
    'highest',
    'lowest',
  ];

  void initialize(Map<String, dynamic>? arguments) {
    final nextTitle = arguments?['title']?.toString().trim();
    final nextProductId = arguments?['productId']?.toString().trim();

    if (nextTitle != null && nextTitle.isNotEmpty) {
      title.value = nextTitle;
    }

    if (nextProductId == null || nextProductId.isEmpty) {
      return;
    }

    final hasSameProduct = _loadedProductId == nextProductId &&
        allReviewModel.value != null;

    _productId = nextProductId;
    if (hasSameProduct) {
      return;
    }

    _loadedProductId = nextProductId;
    fetchAllReviews();
  }

  Future<void> fetchAllReviews({bool force = false}) async {
    final productId = _productId;
    if (productId == null || productId.isEmpty) {
      return;
    }

    if (isLoading.value && !force) {
      return;
    }

    isLoading.value = true;
    try {
      final response = await _networkCaller.getRequest(
        Urls.getProductReviewsUrlById(productId),
        queryParams: {'sort': selectedSort.value},
      );

      if (response.isSuccess) {
        final rawData = response.responseData;
        final json = rawData is Map<String, dynamic>
            ? rawData
            : Map<String, dynamic>.from(rawData as Map);
        allReviewModel.value = AllReviewModel.fromJson(json);
      } else {
        showAppToast(
          message: response.errorMessage,
          isError: true,
        );
      }
    } catch (e) {
      showAppToast(
        message: e.toString(),
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  int get totalReviews {
    final data = allReviewModel.value?.data;
    return data?.ratingCount ?? data?.reviews.length ?? 0;
  }

  double get displayedRating {
    return (allReviewModel.value?.data?.avgRating ?? 0).toDouble();
  }

  double get averageRating => displayedRating;

  List<int> get ratingCounts {
    final analysis = allReviewModel.value?.data?.reviewAnalysis;
    return [
      analysis?.excellent ?? 0,
      analysis?.veryGood ?? 0,
      analysis?.good ?? 0,
      analysis?.fair ?? 0,
      analysis?.poor ?? 0,
    ];
  }

  List<UserFeedbackModel> get feedbacks {
    final reviews = allReviewModel.value?.data?.reviews ?? const <Review>[];

    return reviews.map((review) {
      return UserFeedbackModel(
        userName: review.user?.name ?? 'Anonymous',
        date: review.createdAt ?? DateTime.now(),
        rating: (review.rating ?? 0).toDouble(),
        comment: review.review ?? '',
        images: review.files,
      );
    }).toList(growable: false);
  }

  void updateSort(String? value) {
    if (value == null) return;
    selectedSort.value = value;
    fetchAllReviews(force: true);
  }
}
