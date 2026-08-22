import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/homescreen/data/models/product_details_model.dart';
import 'package:hoodz/urls.dart';

class ProductDetailsController extends GetxController {
  final RxBool isLoading = false.obs;

  final NetworkCaller _networkCaller = Get.find<NetworkCaller>();

  final Rx<ProductDetailsModel?> _productDetailsModel =
      Rx<ProductDetailsModel?>(null);

  Rx<ProductDetailsModel?> get productDetailsModel =>
      _productDetailsModel;

  ProductData? get productData =>
      _productDetailsModel.value?.data;

  final List<String> languages = const [
    'en',
    'bn',
  ];

  final RxString selectedSize = 'XS'.obs;

  final RxInt selectedColorIndex = 1.obs;

  final RxString productIdData = ''.obs;

  final List<String> sizes = const [
    'XS',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
  ];

  final List<Color> colors = const [
    Colors.black,
    Color(0xff233F93),
    Color(0xff7D8595),
    Color(0xffD7B88F),
  ];

  final List<Map<String, String>> productList = [
    {
      'id': '1',
      'image':
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab',
      'name': 'Classic Black T-Shirt',
      'price': '\$45.00',
      'rating': '4.7',
      'isFavorite': 'false',
    },
  ];

  @override
  void onInit() {
    super.onInit();

    _getRouteArguments();
  }

  void _getRouteArguments() {
    final arguments = Get.arguments;

    if (arguments is Map<String, dynamic>) {
      final productId = arguments['productId'];

      if (productId is String && productId.isNotEmpty) {
        productIdData.value = productId;

        loadProductData();
      } else {
        _showProductIdError();
      }
    } else {
      _showProductIdError();
    }
  }

  void _showProductIdError() {
    Get.snackbar(
      'Product Load Failed',
      'Product ID not found.',
    );
  }

  void onSizeSelected(String size) {
    selectedSize.value = size;
  }

  void onColorSelected(int index) {
    selectedColorIndex.value = index;
  }

  Future<void> loadProductData({
    bool force = false,
  }) async {
    if (isLoading.value) {
      return;
    }

    if (!force && _productDetailsModel.value != null) {
      return;
    }

    if (productIdData.value.isEmpty) {
      return;
    }

    final accessToken = MySharedPref.getAccessToken();

    if (accessToken == null || accessToken.isEmpty) {
      Get.snackbar(
        'Profile Load Failed',
        'Access token not found. Please login again.',
      );
      return;
    }

    try {
      isLoading.value = true;

      final response = await _networkCaller.getRequest(
        Urls.getProductUrlById(
          productIdData.value,
        ),
        accessToken: accessToken,
      );

      if (response.isSuccess) {
        _productDetailsModel.value =
            ProductDetailsModel.fromJson(
          response.responseData,
        );
      } else {
        Get.snackbar(
          'Product Load Failed',
          response.errorMessage,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Product Load Failed',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}