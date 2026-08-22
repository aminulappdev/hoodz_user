import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/core/constants/app_strings.dart';

class SearchScreenController extends GetxController {
  final RxString selectedCategory = 'Men'.obs;
  final RxString selectedFilterCategory = 'Men'.obs;
  final RxString selectedBrand = ''.obs;
  final RxString selectedColor = 'Black'.obs;
  final RxString selectedSize = 'XS'.obs;
  final RxString selectedGender = 'All'.obs;
  final Rx<RangeValues> deliveryRange = const RangeValues(0, 55).obs;
  final Rx<RangeValues> distanceRange = const RangeValues(0, 10).obs;

  final List<String> categories = const [
    'Men',
    'Women',
    'Shoes',
    'Bags',
    'Accessories',
  ];

  final List<String> filterCategories = const [
    'Men',
    'Women',
    'Shoes',
    'Bags',
    'Accessories',
    'Sportswear',
    'Streetwear',
  ];

  final List<String> brands = const ['Nike', 'Adidas', 'Puma', 'Zara', 'Gucci'];
  final List<String> colors = const ['Black', 'White', 'Red', 'Blue', 'Green'];
  final List<String> sizes = const ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  final List<String> genders = const ['All', 'Men', 'Women', 'Unisex'];

  final List<Map<String, String>> featuredVendors = const [
    {
      'image': AppStrings.demoImageUrl,
      'name': 'Urban Style',
      'rating': '4.5',
      'reviews': '(1k)',
      'time': '20-25 min',
      'delivery': 'Free',
    },
    {
      'image': AppStrings.demoImageUrl,
      'name': 'Urban Style',
      'rating': '4.5',
      'reviews': '(1k)',
      'time': '20-25 min',
      'delivery': 'Free',
    },
  ];

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void selectFilterCategory(String category) {
    selectedFilterCategory.value = category;
  }

  void selectBrand(String brand) {
    selectedBrand.value = brand;
  }

  void selectColor(String color) {
    selectedColor.value = color;
  }

  void selectSize(String size) {
    selectedSize.value = size;
  }

  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  void updateDeliveryRange(RangeValues values) {
    deliveryRange.value = values;
  }

  void updateDistanceRange(RangeValues values) {
    distanceRange.value = values;
  }

  void clearFilters() {
    selectedFilterCategory.value = 'Men';
    selectedBrand.value = '';
    selectedColor.value = 'Black';
    selectedSize.value = 'XS';
    selectedGender.value = 'All';
    deliveryRange.value = const RangeValues(0, 55);
    distanceRange.value = const RangeValues(0, 10);
  }
}
