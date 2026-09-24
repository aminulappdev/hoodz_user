import 'package:hoodz/features/user/homescreen/presentation/controllers/all_product_controller.dart';
import 'package:hoodz/urls.dart';

class AiRecommendedProductController extends AllTrendingProductController {
  bool _hasAppliedPriceFilter = false;

  @override
  String get apiPath => Urls.aiRecommendedProductUrl;

  @override
  bool get includePriceFilter => _hasAppliedPriceFilter;

  @override
  void applyFilters() {
    _hasAppliedPriceFilter = true;
    super.applyFilters();
  }

  @override
  void clearAppliedFilters() {
    _hasAppliedPriceFilter = false;
    clearDraftFilters();
    selectedColors.value = List<String>.from(draftColors);
    selectedSizes.value = List<String>.from(draftSizes);
    selectedPriceRange.value = draftPriceRange.value;
    getTrendingProduct();
  }
}
