import 'dart:async';

import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/homescreen/data/models/product_details_model.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/home_screen_controller.dart';
import 'package:hoodz/urls.dart';

class ProductDetailsController extends GetxController {
  final RxBool isLoading = false.obs;

  final NetworkCaller _networkCaller = Get.find<NetworkCaller>();

  final Rx<ProductDetailsModel?> _productDetailsModel =
      Rx<ProductDetailsModel?>(null);
  final Set<String> _trackedProductIds = <String>{};

  Rx<ProductDetailsModel?> get productDetailsModel => _productDetailsModel;

  ProductData? get productData => _productDetailsModel.value?.data;
 
  void updateSimilarProductWishlistStatus({ 
    required String productId,
    required bool isWishlisted,
  }) {
    final currentModel = _productDetailsModel.value;
    final currentData = currentModel?.data;

    if (currentModel == null || currentData == null) {
      return;
    }

    final updatedSimilarProducts = currentData.similarProducts
        .map(
          (product) => product.id == productId
              ? product.copyWith(isWishlisted: isWishlisted)
              : product,
        )
        .toList();

    _productDetailsModel.value = currentModel.copyWith(
      data: currentData.copyWith(similarProducts: updatedSimilarProducts),
    );
  }

  final List<String> languages = const ['en', 'bn'];

  final RxString selectedSize = 'XS'.obs;
 
  final RxInt selectedColorIndex = 0.obs;

  final RxString productIdData = ''.obs;
  String? _loadedProductId;

  @override
  void onInit() {
    super.onInit();

    _getRouteArguments();
  }

  void _getRouteArguments() =>
      initialize(Get.arguments as Map<String, dynamic>?);

  void initialize(Map<String, dynamic>? arguments) {
    final productId = arguments?['productId'];

    if (productId is String && productId.isNotEmpty) {
      if (_trackedProductIds.add(productId)) {
        unawaited(_trackProductViewed(productId));
      }

      if (_loadedProductId == productId) {
        if (_productDetailsModel.value == null && !isLoading.value) {
          loadProductData(force: true);
        }
        return;
      }

      _loadedProductId = productId;
      productIdData.value = productId;
      selectedSize.value = '';
      selectedColorIndex.value = 0;
      _productDetailsModel.value = null;
      loadProductData(force: true);
      return;
    }

      _showProductIdError();
  }

  Future<void> _trackProductViewed(String productId) async {
    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      return;
    }

    try {
      final response = await _networkCaller.patchRequest(
        Urls.getProductViewedUrlById(productId),
        accessToken: accessToken,
      );

      if (response.isSuccess && Get.isRegistered<HomeScreenController>()) {
        unawaited(Get.find<HomeScreenController>().getUserMeta());
      }
    } catch (_) {
      // View tracking should never block the product details screen.
    }
  }

  void _showProductIdError() {
    Get.snackbar(Strings.productLoadFailed.tr, Strings.productIdNotFound.tr);
  }

  void onSizeSelected(String size) {
    selectedSize.value = size;
    selectedColorIndex.value = 0;
  }

  void onColorSelected(int index) {
    selectedColorIndex.value = index;
  }

  Future<void> loadProductData({bool force = false}) async {
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
        Strings.productLoadFailed.tr,
        Strings.accessTokenNotFoundPleaseLoginAgain.tr,
      );
      return;
    }

    try {
      isLoading.value = true;

      final response = await _networkCaller.getRequest(
        Urls.getProductUrlById(productIdData.value),
        accessToken: accessToken,
      );

      if (response.isSuccess) {
        _productDetailsModel.value = ProductDetailsModel.fromJson(
          response.responseData,
        );
        _applyDefaultSelections(_productDetailsModel.value?.data);
      } else {
        Get.snackbar(Strings.productLoadFailed.tr, response.errorMessage);
      }
    } catch (e) {
      Get.snackbar(Strings.productLoadFailed.tr, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _applyDefaultSelections(ProductData? data) {
    final product = data?.product;
    if (product == null) {
      selectedSize.value = '';
      selectedColorIndex.value = 0;
      return;
    }

    final inventoryType = _normalizeInventoryType(product.inventoryType);
    if (inventoryType == 'size_color') {
      final sizeOptions = availableSizes;
      selectedSize.value = sizeOptions.isNotEmpty ? sizeOptions.first : '';
      selectedColorIndex.value = 0;
      return;
    }

    selectedSize.value = '';
    selectedColorIndex.value = 0;
  }

  String get inventoryType =>
      _normalizeInventoryType(productData?.product?.inventoryType);

  List<String> get availableSizes {
    final product = productData?.product;
    if (product == null || inventoryType != 'size_color') {
      return const [];
    }

    return _extractUniqueSizes(product.variants);
  }

  List<Map<String, String>> get availableColors {
    final product = productData?.product;
    if (product == null) {
      return const [];
    }

    if (inventoryType == 'single') {
      return const [];
    }

    final variants = _variantsForCurrentContext();
    final colors = variants
        .map(_extractVariantColor)
        .whereType<Map<String, String>>()
        .toList(growable: false);
    return _uniqueColors(colors);
  }

  String? get currentSelectedSize {
    if (inventoryType != 'size_color') {
      return null;
    }

    final sizes = availableSizes;
    if (sizes.isEmpty) {
      return null;
    }

    final normalized = selectedSize.value.trim();
    if (normalized.isNotEmpty && sizes.contains(normalized)) {
      return normalized;
    }

    return sizes.first;
  }

  Map<String, String>? get currentSelectedColor {
    final colors = availableColors;
    if (colors.isEmpty) {
      return null;
    }

    final safeIndex = selectedColorIndex.value.clamp(0, colors.length - 1).toInt();
    return colors[safeIndex];
  }

  Map<String, dynamic>? get currentSelectedVariant {
    final product = productData?.product;
    if (product == null) {
      return null;
    }

    if (inventoryType == 'single') {
      return null;
    }

    final variants = _normalizedVariants(product.variants);
    if (variants.isEmpty) {
      return null;
    }

    final selectedSizeValue = currentSelectedSize;
    final selectedColor = currentSelectedColor;

    for (final variant in variants) {
      final variantSize = _normalizeString(variant['size']);
      final variantColor = _extractVariantColor(variant);

      final sizeMatches = selectedSizeValue == null
          ? true
          : variantSize == selectedSizeValue;
      final colorMatches = selectedColor == null
          ? true
          : variantColor != null &&
              variantColor['code'] == selectedColor['code'] &&
              variantColor['name'] == selectedColor['name'];

      if (sizeMatches && colorMatches) {
        return variant;
      }
    }

    return variants.first;
  }

  int get currentSelectedQuantity {
    final product = productData?.product;
    if (product == null) {
      return 0;
    }

    if (inventoryType == 'single') {
      return _toInt(product.stock) ?? 0;
    }

    final variant = currentSelectedVariant;
    if (variant != null) {
      return _toInt(variant['quantity']) ?? 0;
    }

    return _toInt(product.stock) ?? 0;
  }

  bool get isCurrentSelectionInStock => currentSelectedQuantity > 0;

  String get stockStatusLabel => isCurrentSelectionInStock
      ? Strings.inStock.tr
      : Strings.outOfStock.tr;

  String? get currentSelectedSizePayload => currentSelectedSize;

  Map<String, String>? get currentSelectedColorPayload => currentSelectedColor;

  List<Map<String, dynamic>> _variantsForCurrentContext() {
    final product = productData?.product;
    if (product == null) {
      return const [];
    }

    final variants = _normalizedVariants(product.variants);
    if (inventoryType != 'size_color') {
      return variants;
    }

    final selected = currentSelectedSize;
    if (selected == null) {
      return variants;
    }

    return variants
        .where((variant) => _normalizeString(variant['size']) == selected)
        .toList(growable: false);
  }

  List<Map<String, dynamic>> _normalizedVariants(List<dynamic> variants) {
    return variants
        .whereType<Map>()
        .map((variant) => Map<String, dynamic>.from(variant))
        .toList(growable: false);
  }

  List<String> _extractUniqueSizes(List<dynamic> variants) {
    final sizes = <String>[];
    for (final variant in _normalizedVariants(variants)) {
      final size = _normalizeString(variant['size']);
      if (size != null && !sizes.contains(size)) {
        sizes.add(size);
      }
    }
    return sizes;
  }

  List<Map<String, String>> _uniqueColors(List<Map<String, String>> colors) {
    final unique = <String>{};
    final result = <Map<String, String>>[];

    for (final color in colors) {
      final code = _normalizeString(color['code']);
      final name = _normalizeString(color['name']);
      if (code == null || name == null) {
        continue;
      }

      final key = '$code|$name';
      if (unique.add(key)) {
        result.add({'code': code, 'name': name});
      }
    }

    return result;
  }

  Map<String, String>? _extractVariantColor(Map<String, dynamic> variant) {
    final colorValue = variant['color'];
    if (colorValue is Map<String, dynamic>) {
      final code = _normalizeString(colorValue['code']);
      final name = _normalizeString(colorValue['name']);
      if (code != null && name != null) {
        return {'code': code, 'name': name};
      }
    }

    if (colorValue is Map) {
      final colorMap = Map<String, dynamic>.from(colorValue);
      final code = _normalizeString(colorMap['code']);
      final name = _normalizeString(colorMap['name']);
      if (code != null && name != null) {
        return {'code': code, 'name': name};
      }
    }

    return null;
  }

  int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  String _normalizeInventoryType(dynamic value) {
    final normalized = _normalizeString(value)?.toLowerCase();
    return normalized ?? '';
  }

  String? _normalizeString(dynamic value) {
    final normalized = value?.toString().trim();
    return (normalized == null || normalized.isEmpty) ? null : normalized;
  }
}
