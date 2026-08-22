import 'package:get/get.dart';
import 'package:hoodz/core/constants/app_strings.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/home_screen_controller.dart';
import 'package:flutter/material.dart';

class AllBrandController extends GetxController {
  AllBrandController(this._homeController);

  final HomeScreenController _homeController;

  final RxString title = 'Men'.obs;
  final RxString image = ''.obs;
  final RxString selectedBrand = ''.obs;
  final RxString selectedColor = ''.obs;
  final RxString selectedSize = ''.obs;
  final Rx<RangeValues> selectedPriceRange = const RangeValues(0, 100).obs;

  final RxString draftBrand = ''.obs;
  final RxString draftColor = ''.obs;
  final RxString draftSize = ''.obs;
  final Rx<RangeValues> draftPriceRange = const RangeValues(0, 100).obs;

  List<String> get categories => const [
    'Men',
    'Women',
    'Shoes',
    'Bag',
    'Accessories',
  ];
  List<String> get colors => const ['Black', 'White', 'Red', 'Blue', 'Green'];
  List<String> get sizes => const ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  List<String> get headerAvatarImages => const [
    AppStrings.demoImageUrl,
    AppStrings.demoImageUrl,
  ];

  void initialize(Map<String, dynamic>? arguments) {
    title.value = arguments?['title'] as String? ?? 'Men';
    image.value = arguments?['image'] as String? ?? '';
    syncDraftWithApplied();
  }

  List<Map<String, String>> get visibleProducts {
    final selectedCategory = title.value;

    return _homeController.productList.where((product) {
      final category = product['category'] ?? '';
      final brand = product['brand'] ?? '';
      final color = product['color'] ?? '';
      final size = product['size'] ?? '';
      final price = _parsePrice(product['price']);
      final matchesCategory = category == selectedCategory;
      final matchesBrand =
          selectedBrand.value.isEmpty || brand == selectedBrand.value;
      final matchesColor =
          selectedColor.value.isEmpty || color == selectedColor.value;
      final matchesSize =
          selectedSize.value.isEmpty || size == selectedSize.value;
      final matchesPrice =
          price >= selectedPriceRange.value.start &&
          price <= selectedPriceRange.value.end;
      return matchesCategory &&
          matchesBrand &&
          matchesColor &&
          matchesSize &&
          matchesPrice;
    }).toList();
  }

  void syncDraftWithApplied() {
    draftBrand.value = selectedBrand.value;
    draftColor.value = selectedColor.value;
    draftSize.value = selectedSize.value;
    draftPriceRange.value = selectedPriceRange.value;
  }

  void selectDraftBrand(String value) {
    draftBrand.value = draftBrand.value == value ? '' : value;
  }

  void selectDraftColor(String value) {
    draftColor.value = draftColor.value == value ? '' : value;
  }

  void selectDraftSize(String value) {
    draftSize.value = draftSize.value == value ? '' : value;
  }

  void updateDraftPriceRange(RangeValues values) {
    draftPriceRange.value = values;
  }

  void applyFilters() {
    selectedBrand.value = draftBrand.value;
    selectedColor.value = draftColor.value;
    selectedSize.value = draftSize.value;
    selectedPriceRange.value = draftPriceRange.value;
  }

  void clearDraftFilters() {
    draftBrand.value = '';
    draftColor.value = '';
    draftSize.value = '';
    draftPriceRange.value = const RangeValues(0, 100);
  }

  void clearAppliedFilters() {
    clearDraftFilters();
    applyFilters();
  }

  void toggleBrand(String value) {
    selectedBrand.value = selectedBrand.value == value ? '' : value;
  }

  double _parsePrice(String? price) {
    if (price == null || price.isEmpty) {
      return 0;
    }

    final clean = price.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(clean) ?? 0;
  }
}
