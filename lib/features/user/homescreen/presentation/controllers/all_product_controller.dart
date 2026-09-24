import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/constants/app_strings.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/utils/auth_response_utils.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/login_required_dialog.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/homescreen/data/models/all_product_model.dart';
import 'package:hoodz/urls.dart';

class AllTrendingProductController extends GetxController {
  final NetworkCaller _networkCaller = Get.find<NetworkCaller>();

  final RxBool isLoading = false.obs;   
  final RxBool isLoadingMore = false.obs;
  final Rx<AllProductModel?> _productModel = Rx<AllProductModel?>(null);
  int _currentPage = 1;
  int _totalPage = 1;
  AllProductModel? get productModel => _productModel.value;
  List<AllProductItemModel> get products =>
      _productModel.value?.data ?? const [];
  bool get hasMoreDuas => _currentPage < _totalPage;
  String get apiPath => Urls.trendingProductUrl;

  @override
  void onInit() {
    super.onInit();
    getTrendingProduct();
  }

  final RxString title = ''.obs;
  final RxString image = ''.obs;
  final RxList<String> selectedColors = <String>[].obs;
  final RxList<String> selectedSizes = <String>[].obs;
  final Rx<RangeValues> selectedPriceRange = const RangeValues(0, 110).obs;

  final RxList<String> draftColors = <String>[].obs;
  final RxList<String> draftSizes = <String>[].obs;
  final Rx<RangeValues> draftPriceRange = const RangeValues(0, 110).obs;

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
    title.value = arguments?['title'] as String? ?? Strings.men.tr;
    image.value = arguments?['image'] as String? ?? '';
    syncDraftWithApplied();
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
    final hasAccessToken = accessToken?.trim().isNotEmpty == true;

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
      final response = hasAccessToken
          ? await _networkCaller.getRequest(
              apiPath,
              accessToken: accessToken,
              queryParams: buildQueryParams(page),
            )
          : await _networkCaller.getRequest(
              apiPath,
              queryParams: buildQueryParams(page),
            );

      if (isLoginRequiredResponse(response)) {
        showLoginRequiredDialog();
        return;
      }

      if (response.isSuccess) {
        final model = AllProductModel.fromJson(response.responseData);
        _currentPage = model.meta?.page ?? page;
        _totalPage = model.meta?.totalPage ?? _currentPage;

        if (loadMore && _productModel.value != null) {
          _productModel.value = AllProductModel(
            success: model.success,
            statusCode: model.statusCode,
            message: model.message,
            meta: model.meta,
            data: [..._productModel.value!.data, ...model.data],
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

  Map<String, dynamic> buildQueryParams(int page) {
    final queryParams = <String, dynamic>{
      'page': page,
    };

    if (includePriceFilter) {
      queryParams['minPrice'] = selectedPriceRange.value.start.round();
      queryParams['maxPrice'] = selectedPriceRange.value.end.round();
    }

    if (selectedColors.isNotEmpty) {
      queryParams['colors'] = selectedColors.join(',');
    }

    if (selectedSizes.isNotEmpty) {
      queryParams['sizes'] = selectedSizes.join(',');
    }

    return queryParams;
  }

  bool get includePriceFilter => true;
}
