import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/core/constants/app_strings.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/shop/data/models/get_shop_product_model.dart';
import 'package:hoodz/urls.dart';

class AllProductInfoController extends GetxController {
  AllProductInfoController();
 
  final NetworkCaller _networkCaller = Get.find<NetworkCaller>();

  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final Rx<GetShopProductModel?> _productModel = Rx<GetShopProductModel?>(null);

  int _currentPage = 1;
  int _totalPage = 1;
  String? _loadedShopId;

  final RxString title = ''.obs;
  final RxString image = ''.obs;
  final RxString shopId = ''.obs;
  final RxString category = ''.obs;
  final RxString brandType = ''.obs;

  final RxList<String> selectedColors = <String>[].obs;
  final RxList<String> selectedSizes = <String>[].obs;
  final Rx<RangeValues> selectedPriceRange = const RangeValues(0, 110).obs;

  final RxList<String> draftColors = <String>[].obs;
  final RxList<String> draftSizes = <String>[].obs;
  final Rx<RangeValues> draftPriceRange = const RangeValues(0, 110).obs;

  GetShopProductModel? get productModel => _productModel.value;
  List<AllProduct> get recommendedProducts =>
      _productModel.value?.data?.recommends ?? const [];
  List<AllProduct> get products =>
      _productModel.value?.data?.allProducts ?? const [];
  bool get hasMoreDuas => _currentPage < _totalPage;
  String get apiPath => Urls.getShopProductsUrlById(shopId.value);

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

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    initialize(arguments is Map<String, dynamic> ? arguments : null);
  }

  void initialize(Map<String, dynamic>? arguments) {
    title.value = arguments?['title'] as String? ?? 'Men';
    image.value = arguments?['image'] as String? ?? '';
    shopId.value =
        _extractShopId(arguments?['shopId'] ?? arguments?['reference']) ?? '';
    category.value = (arguments?['category'] as String? ?? '').trim();
    brandType.value = (arguments?['brandType'] as String? ?? '').trim();
    syncDraftWithApplied();

    if (shopId.value.isEmpty) {
      return;
    }

    if (_loadedShopId == shopId.value && productModel != null) {
      return;
    }

    _loadedShopId = shopId.value;
    getTrendingProduct();
  }

  void syncDraftWithApplied() {
    draftColors.assignAll(selectedColors);
    draftSizes.assignAll(selectedSizes);
    draftPriceRange.value = selectedPriceRange.value;
  }

  void selectDraftColor(String value) {
    if (draftColors.contains(value)) {
      draftColors.remove(value);
    } else {
      draftColors.add(value);
    }
  }

  void selectDraftSize(String value) {
    if (draftSizes.contains(value)) {
      draftSizes.remove(value);
    } else {
      draftSizes.add(value);
    }
  }

  void updateDraftPriceRange(RangeValues values) {
    draftPriceRange.value = values;
  }

  void applyFilters() {
    selectedColors.assignAll(draftColors);
    selectedSizes.assignAll(draftSizes);
    selectedPriceRange.value = draftPriceRange.value;
    getTrendingProduct();
  }

  void clearDraftFilters() {
    draftColors.clear();
    draftSizes.clear();
    draftPriceRange.value = const RangeValues(0, 110);
  }

  void clearAppliedFilters() {
    clearDraftFilters();
    applyFilters();
  }

  Future<void> getTrendingProduct({bool loadMore = false}) async {
    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      showAppToast(
        message: 'Access token not found. Please login again.',
        isError: true,
      );
      return;
    }

    if (loadMore) {
      if (isLoading.value || isLoadingMore.value || !hasMoreDuas) {
        return;
      }
    } else {
      if (isLoading.value) {
        return;
      }

      _resetDuas();
    }

    final page = loadMore ? _currentPage + 1 : 1;

    if (loadMore) {
      isLoadingMore.value = true;
    } else {
      isLoading.value = true;
    }

    try {
      final queryParams = _buildQueryParams(page);

      if (category.value.trim().isNotEmpty) {
        queryParams['category'] = category.value.trim();
      }

      if (brandType.value.trim().isNotEmpty) {
        queryParams['brandType'] = brandType.value.trim();
      }

      final response = await _networkCaller.getRequest(
        apiPath,
        accessToken: accessToken,
        queryParams: queryParams,
      );

      if (response.isSuccess) {
        final model = GetShopProductModel.fromJson(response.responseData);
        _currentPage = _toInt(model.meta?.page) ?? page;
        _totalPage = _toInt(model.meta?.totalPage) ?? _currentPage;

        if (loadMore && _productModel.value != null) {
          final currentModel = _productModel.value!;
          _productModel.value = GetShopProductModel(
            success: model.success,
            statusCode: model.statusCode,
            message: model.message,
            meta: model.meta,
            data: Data(
              recommends: model.data?.recommends ?? currentModel.data?.recommends ?? const [],
              allProducts: [
                ...?currentModel.data?.allProducts,
                ...?model.data?.allProducts,
              ],
            ),
          );
        } else {
          _productModel.value = model;
        }
        return;
      }

      showAppToast(message: response.errorMessage, isError: true);
    } finally {
      if (loadMore) {
        isLoadingMore.value = false;
      } else {
        isLoading.value = false;
      }
    }
  }

  void _resetDuas() {
    _currentPage = 1;
    _totalPage = 1;
    _productModel.value = null;
  }

  String? _extractShopId(dynamic rawValue) {
    if (rawValue is! String || rawValue.isEmpty) {
      return null;
    }

    final value = rawValue.trim();
    if (value.startsWith('http://') || value.startsWith('https://')) {
      final uri = Uri.tryParse(value);
      final segments = uri?.pathSegments.where((segment) => segment.isNotEmpty);
      if (segments == null || segments.isEmpty) {
        return null;
      }
      return segments.last;
    }

    return value;
  }

  int? _toInt(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is double) {
      return value.toInt();
    }
    return int.tryParse(value.toString());
  }

  Map<String, dynamic> _buildQueryParams(int page) {
    final queryParams = <String, dynamic>{
      'page': page,
      'minPrice': selectedPriceRange.value.start.round(),
      'maxPrice': selectedPriceRange.value.end.round(),
    };

    if (selectedColors.isNotEmpty) {
      queryParams['colors'] = selectedColors.join(',');
    }

    if (selectedSizes.isNotEmpty) {
      queryParams['sizes'] = selectedSizes.join(',');
    }

    return queryParams;
  }
}
