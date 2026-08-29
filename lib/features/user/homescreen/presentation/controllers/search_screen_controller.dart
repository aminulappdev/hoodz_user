import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/others/location_selection_service.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/homescreen/data/models/initial_search_model.dart';
import 'package:hoodz/features/user/homescreen/data/models/product_search_model.dart'
    as product_search;
import 'package:hoodz/features/user/homescreen/data/models/search_product_model.dart'
    as search_product;
import 'package:hoodz/urls.dart';

class SearchScreenController extends GetxController {
  SearchScreenController()
      : _networkCaller = Get.find<NetworkCaller>(),
        _locationService = Get.find<LocationSelectionService>();

  final NetworkCaller _networkCaller;
  final LocationSelectionService _locationService;

  final RxString selectedCategory = ''.obs;
  final RxString selectedFilterCategory = ''.obs;
  final RxList<String> selectedFilterCategories = <String>[].obs;
  final RxString selectedBrand = ''.obs;
  final RxString selectedColor = ''.obs;
  final RxString selectedSize = ''.obs;
  final RxList<String> selectedSizes = <String>[].obs;
  final RxString selectedGender = 'All'.obs;
  final Rx<RangeValues> deliveryRange = const RangeValues(0, 55).obs;
  final Rx<RangeValues> distanceRange = const RangeValues(0, 10).obs;

  final RxBool isLoading = false.obs;
  final RxBool isSuggestionLoading = false.obs;
  final RxBool isProductLoading = false.obs;
  final RxBool isDiscoveryVisible = true.obs;
  final RxBool showProductResults = false.obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController searchTextController = TextEditingController();
  final Rx<InitialSearchModel?> _searchModel = Rx<InitialSearchModel?>(null);
  final RxList<product_search.Suggestion> _suggestions =
      <product_search.Suggestion>[].obs;
  final Rx<product_search.ProductSearchModel?> _suggestionModel =
      Rx<product_search.ProductSearchModel?>(null);
  final Rx<search_product.SearchProductModel?> _productModel =
      Rx<search_product.SearchProductModel?>(null);
  Timer? _suggestionDebounce;

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

  InitialSearchModel? get searchModel => _searchModel.value;
  product_search.ProductSearchModel? get suggestionModel => _suggestionModel.value;
  List<product_search.Suggestion> get suggestions => _suggestions;
  List<search_product.Datum> get searchProducts => _productModel.value?.data ?? const [];
  List<Category> get categories => _searchModel.value?.data?.categories ?? const [];
  List<History> get histories => _searchModel.value?.data?.histories ?? const [];
  List<FeaturedVendor> get featuredVendors =>
      _searchModel.value?.data?.featuredVendors ?? const [];

  @override
  void onInit() {
    super.onInit();
    fetchSearchData();
  }

  @override
  void onClose() {
    _suggestionDebounce?.cancel();
    searchTextController.dispose();
    super.onClose();
  }

  void toggleDiscoveryVisibility() {
    isDiscoveryVisible.value = !isDiscoveryVisible.value;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void selectFilterCategory(String category) {
    if (selectedFilterCategories.contains(category)) {
      selectedFilterCategories.remove(category);
    } else {
      selectedFilterCategories.add(category);
    }

    selectedFilterCategory.value = selectedFilterCategories.join(',');
  }

  void selectBrand(String brand) {
    selectedBrand.value = brand;
  }

  void selectColor(String color) {
    selectedColor.value = selectedColor.value == color ? '' : color;
  }

  void selectSize(String size) {
    if (selectedSizes.contains(size)) {
      selectedSizes.remove(size);
    } else {
      selectedSizes.add(size);
    }

    selectedSize.value = selectedSizes.join(',');
  }

  void selectGender(String gender) {
    selectedGender.value = selectedGender.value == gender ? 'All' : gender;
  }

  void updateDeliveryRange(RangeValues values) {
    deliveryRange.value = values;
  }

  void updateDistanceRange(RangeValues values) {
    distanceRange.value = values;
  }

  void clearFilters() {
    selectedFilterCategory.value = '';
    selectedFilterCategories.clear();
    selectedBrand.value = '';
    selectedColor.value = '';
    selectedSize.value = '';
    selectedSizes.clear();
    selectedGender.value = 'All';
    deliveryRange.value = const RangeValues(0, 55);
    distanceRange.value = const RangeValues(0, 10);
  }

  void updateSearchQuery(String value) {
    final normalizedQuery = value.trim();
    searchQuery.value = normalizedQuery;
    _suggestionDebounce?.cancel();

    if (normalizedQuery.isEmpty) {
      _suggestions.clear();
      _suggestionModel.value = null;
      _productModel.value = null;
      showProductResults.value = false;
      fetchSearchData(query: '');
      return;
    }

    showProductResults.value = false;
    _suggestionModel.value = null;
    _productModel.value = null;
    _suggestionDebounce = Timer(
      const Duration(milliseconds: 300),
      () => fetchSearchSuggestions(normalizedQuery),
    );
  }

  void fillSearchText(String value) {
    _suggestionDebounce?.cancel();
    searchTextController.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
    searchQuery.value = value;
  }

  void useHistoryQuery(String value) {
    fillSearchText(value);
    fetchSearchData(query: value);
  }

  void clearSearchText() {
    fillSearchText('');
    _suggestionDebounce?.cancel();
    _suggestions.clear();
    _suggestionModel.value = null;
    _productModel.value = null;
    showProductResults.value = false;
    fetchSearchData(query: '');
  }

  Future<void> clearSearchHistory() async {
    final accessToken = MySharedPref.getAccessToken();
    final response = await _networkCaller.deleteRequest(
      Urls.searchUrl,
      accessToken: accessToken,
    );

    if (!response.isSuccess) {
      showAppToast(message: response.errorMessage, isError: true);
      return;
    }

    await _refreshInitialSearchData(accessToken);
  }

  Future<void> fetchSearchData({String? query}) async {
    final normalizedQuery = (query ?? searchTextController.text).trim();
    searchQuery.value = normalizedQuery;

    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    try {
      final accessToken = MySharedPref.getAccessToken();
      final queryParams = <String, dynamic>{};

      if (normalizedQuery.isNotEmpty) {
        // Different backends use different search param keys, so send the common ones.
        queryParams.addAll({
          'search': normalizedQuery,
          'query': normalizedQuery,
          'q': normalizedQuery,
        });
      }

      final response = await _networkCaller.getRequest(
        Urls.searchUrl,
        accessToken: accessToken,
        queryParams: queryParams.isEmpty ? null : queryParams,
      );

      if (response.isSuccess) {
        final model = InitialSearchModel.fromJson(response.responseData);
        _searchModel.value = model;

        final loadedCategories = model.data?.categories ?? const [];
        if (loadedCategories.isNotEmpty) {
          final firstTitle = loadedCategories.first.title;
          final currentSelected = selectedCategory.value.trim();
          final hasCurrentSelection = loadedCategories.any(
            (category) => category.title?.trim() == currentSelected,
          );

          if (firstTitle != null &&
              firstTitle.trim().isNotEmpty &&
              !hasCurrentSelection) {
            selectedCategory.value = firstTitle;
          }
        }
        return;
      }

      showAppToast(message: response.errorMessage, isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSearchSuggestions(String searchTerm) async {
    final normalizedQuery = searchTerm.trim();
    if (normalizedQuery.isEmpty || isSuggestionLoading.value) {
      return;
    }

    isSuggestionLoading.value = true;

    try {
      final accessToken = MySharedPref.getAccessToken();
      final response = await _networkCaller.getRequest(
        Urls.searchDataUrl,
        accessToken: accessToken,
        queryParams: {'searchTerm': normalizedQuery},
      );

      if (response.isSuccess) {
        final model = product_search.ProductSearchModel.fromJson(
          response.responseData,
        );
        _suggestionModel.value = model;
        _suggestions.assignAll(model.data?.suggestions ?? const []);
        return;
      }

      showAppToast(message: response.errorMessage, isError: true);
    } finally {
      isSuggestionLoading.value = false;
    }
  }

  Future<void> fetchSearchProducts({String? query}) async {
    await fetchSearchProductsWithFilters(query: query);
  }

  Future<void> fetchSearchProductsWithFilters({
    String? query,
    int? minPrice,
    int? maxPrice,
    String? category,
    String? brand,
    String? color,
    String? size,
    String? gender,
    int? maxDistance,
  }) async {
    final normalizedQuery = _resolveSearchTerm(query);
    final hasFilters =
        minPrice != null ||
        maxPrice != null ||
        (category?.trim().isNotEmpty ?? false) ||
        (brand?.trim().isNotEmpty ?? false) ||
        (color?.trim().isNotEmpty ?? false) ||
        (size?.trim().isNotEmpty ?? false) ||
        ((gender?.trim().isNotEmpty ?? false) &&
            gender!.trim().toLowerCase() != 'all') ||
        maxDistance != null;

    if (normalizedQuery.isNotEmpty) {
      searchQuery.value = normalizedQuery;
    }

    if ((!hasFilters && normalizedQuery.isEmpty) || isProductLoading.value) {
      return;
    }

    _suggestionDebounce?.cancel();
    showProductResults.value = true;
    isProductLoading.value = true;

    try {
      if (normalizedQuery.isNotEmpty) {
        await _trackSearchHistory(normalizedQuery);
      }
      final location = await _getSearchLocation();
      final accessToken = MySharedPref.getAccessToken();
      final response = await _networkCaller.getRequest(
        Urls.searchProductsUrl,
        accessToken: accessToken,
        queryParams: _buildProductSearchParams(
          searchTerm: normalizedQuery,
          minPrice: minPrice,
          maxPrice: maxPrice,
          category: category,
          brand: brand,
          color: color,
          size: size,
          gender: gender,
          maxDistance: maxDistance,
          latitude: location.latitude,
          longitude: location.longitude,
        ),
      );

      if (response.isSuccess) {
        final model = search_product.SearchProductModel.fromJson(
          response.responseData,
        );
        _productModel.value = model;
        _suggestions.clear();
        return;
      }

      showAppToast(message: response.errorMessage, isError: true);
    } finally {
      isProductLoading.value = false;
    }
  }

  Map<String, dynamic> _buildProductSearchParams({
    String? searchTerm,
    int? minPrice,
    int? maxPrice,
    String? category,
    String? brand,
    String? color,
    String? size,
    String? gender,
    int? maxDistance,
    required double latitude,
    required double longitude,
  }) {
    final params = <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
    };

    if (searchTerm != null && searchTerm.trim().isNotEmpty) {
      params['searchTerm'] = searchTerm.trim();
    }

    if (minPrice != null) {
      params['minPrice'] = minPrice;
    }

    if (maxPrice != null) {
      params['maxPrice'] = maxPrice;
    }

    if (category != null && category.trim().isNotEmpty) {
      params['category'] = category.trim();
    }

    if (brand != null && brand.trim().isNotEmpty) {
      params['brand'] = brand.trim();
    }

    if (color != null && color.trim().isNotEmpty) {
      params['color'] = color.trim();
    }

    if (size != null && size.trim().isNotEmpty) {
      params['size'] = size.trim();
    }

    if (gender != null &&
        gender.trim().isNotEmpty &&
        gender.trim().toLowerCase() != 'all') {
      params['gender'] = gender.trim().toLowerCase();
    }

    if (maxDistance != null) {
      params['maxDistance'] = maxDistance;
    }

    return params;
  }

  String _resolveSearchTerm(String? query) {
    final candidates = [
      query,
      searchTextController.text,
      searchQuery.value,
    ];

    for (final candidate in candidates) {
      final normalized = candidate?.trim() ?? '';
      if (normalized.isNotEmpty) {
        return normalized;
      }
    }

    return '';
  }

  Future<LocationAddress> _getSearchLocation() async {
    try {
      return await _locationService.getCurrentLocation();
    } catch (_) {
      return LocationSelectionService.fallbackLocation;
    }
  }

  Future<void> _trackSearchHistory(String query) async {
    final accessToken = MySharedPref.getAccessToken();
    final response = await _networkCaller.postRequest(
      Urls.searchUrl,
      accessToken: accessToken,
      body: {
        'query': query,
        'source': 'manual',
      },
    );

    if (response.isSuccess) {
      await _refreshInitialSearchData(accessToken);
    }
  }

  Future<void> _refreshInitialSearchData(String? accessToken) async {
    final response = await _networkCaller.getRequest(
      Urls.searchUrl,
      accessToken: accessToken,
    );

    if (!response.isSuccess) {
      return;
    }

    final model = InitialSearchModel.fromJson(response.responseData);
    _searchModel.value = model;

    final loadedCategories = model.data?.categories ?? const [];
    if (loadedCategories.isEmpty) {
      return;
    }

    final firstTitle = loadedCategories.first.title;
    final currentSelected = selectedCategory.value.trim();
    final hasCurrentSelection = loadedCategories.any(
      (category) => category.title?.trim() == currentSelected,
    );

    if (firstTitle != null &&
        firstTitle.trim().isNotEmpty &&
        !hasCurrentSelection) {
      selectedCategory.value = firstTitle;
    }
  }
}
