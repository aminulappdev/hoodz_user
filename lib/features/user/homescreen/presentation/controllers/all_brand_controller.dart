import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/others/location_selection_service.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/all_product_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/home_screen_controller.dart';
import 'package:hoodz/features/user/shop/data/models/category_brand_model.dart';
import 'package:hoodz/urls.dart';

class AllBrandController extends AllTrendingProductController {
  AllBrandController(this._homeController, this._locationService);

  final HomeScreenController _homeController;
  final LocationSelectionService _locationService;
  final NetworkCaller _networkCaller = Get.find<NetworkCaller>();
 
  final RxBool isBrandTypesLoading = false.obs;
  final RxBool isCategoryShopsLoading = false.obs;
  final RxString brandType = 'local'.obs;
  final RxString selectedCategoryId = ''.obs;
  final RxString selectedCategoryTitle = ''.obs;
  final RxString selectedCategoryIcon = ''.obs;
  final RxList<CategoryBrandItemModel> brandCategories =
      <CategoryBrandItemModel>[].obs;
  final RxList<CategoryBrandItemModel> brandShops =
      <CategoryBrandItemModel>[].obs;

  String? _loadedBrandType;
  String? _loadedCategoryId;
  double _latitude = LocationSelectionService.fallbackLocation.latitude;
  double _longitude = LocationSelectionService.fallbackLocation.longitude;

  HomeScreenController get homeController => _homeController;

  String get pageTitle => title.value.trim().isEmpty
      ? _prettyBrandType(brandType.value)
      : title.value.tr;

  @override
  void onInit() {
    final arguments = Get.arguments;
    initialize(arguments is Map<String, dynamic> ? arguments : null);
  }

  void initialize(Map<String, dynamic>? arguments) {
    super.initialize(arguments);

    final resolvedBrandType = _resolveBrandType(
      arguments?['brandType'] ?? arguments?['value'] ?? title.value,
    );
    final resolvedLatitude =
        _toDouble(arguments?['latitude']) ??
        _toDouble(arguments?['lat']) ??
        LocationSelectionService.fallbackLocation.latitude;
    final resolvedLongitude =
        _toDouble(arguments?['longitude']) ??
        _toDouble(arguments?['lng']) ??
        LocationSelectionService.fallbackLocation.longitude;

    brandType.value = resolvedBrandType;
    _latitude = resolvedLatitude;
    _longitude = resolvedLongitude;

    if (_loadedBrandType != resolvedBrandType) {
      _loadedBrandType = resolvedBrandType;
      _loadedCategoryId = null;
      selectedCategoryId.value = '';
      selectedCategoryTitle.value = '';
      selectedCategoryIcon.value = '';
      brandCategories.clear();
      brandShops.clear();
      loadBrandTypeCategories(force: true);
      return;
    }

    if (brandCategories.isEmpty && !isBrandTypesLoading.value) {
      loadBrandTypeCategories(force: true);
    }
  }

  String _resolveBrandType(dynamic rawValue) {
    final value = (rawValue ?? '').toString().trim().toLowerCase();
    if (value.contains('international')) {
      return 'international';
    }
    if (value.contains('trend')) {
      return 'trending';
    }
    if (value.contains('new')) {
      return 'new';
    }
    if (value.contains('local')) {
      return 'local';
    }
    if (value == 'intl') {
      return 'international';
    }
    return value.isEmpty ? 'local' : value;
  }

  String _prettyBrandType(String value) {
    switch (value) {
      case 'international':
        return Strings.internationalBrand.tr;
      case 'trending':
        return Strings.trendingNow.tr;
      case 'new':
        return Strings.newArrivals.tr;
      default:
        return Strings.localBrand.tr;
    }
  }

  Future<void> loadBrandTypeCategories({bool force = false}) async {
    if (isBrandTypesLoading.value) {
      return;
    }

    if (!force && brandCategories.isNotEmpty) {
      return;
    }

    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      Get.snackbar(
        Strings.categoryLoadFailed.tr,
        Strings.accessTokenNotFoundPleaseLoginAgain.tr,
      );
      return;
    }

    try {
      isBrandTypesLoading.value = true;
      final response = await _networkCaller.getRequest(
        Urls.getBrandTypeCategoriesUrl(brandType.value),
        accessToken: accessToken,
      );

      if (response.isSuccess) {
        final model = CategoryBrandModel.fromJson(response.responseData);
        brandCategories.assignAll(model.data);
        return;
      }

      Get.snackbar(Strings.categoryLoadFailed.tr, response.errorMessage);
    } catch (e) {
      Get.snackbar(Strings.categoryLoadFailed.tr, e.toString());
    } finally {
      isBrandTypesLoading.value = false;
    }
  }

  Future<void> selectCategory(CategoryBrandItemModel category) async {
    final categoryId = category.id?.trim() ?? '';
    if (categoryId.isEmpty) {
      return;
    }

    selectedCategoryId.value = categoryId;
    selectedCategoryTitle.value = category.displayTitle;
    selectedCategoryIcon.value = category.displayImage;

    if (_loadedCategoryId == categoryId && brandShops.isNotEmpty) {
      return;
    }

    _loadedCategoryId = categoryId;
    await loadCategoryShops(
      categoryId: categoryId,
      categoryTitle: category.displayTitle,
      force: true,
    );
  }

  Future<void> loadCategoryShops({
    required String categoryId,
    required String categoryTitle,
    bool force = false,
  }) async {
    if (isCategoryShopsLoading.value) {
      return;
    }

    if (!force && _loadedCategoryId == categoryId && brandShops.isNotEmpty) {
      return;
    }

    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      Get.snackbar(
        Strings.shopLoadFailed.tr,
        Strings.accessTokenNotFoundPleaseLoginAgain.tr,
      );
      return;
    }

    try {
      isCategoryShopsLoading.value = true;
      final response = await _networkCaller.getRequest(
        Urls.getCategoryShopsUrl(categoryId),
        accessToken: accessToken,
        queryParams: {
          'brandType': brandType.value,
          'latitude': _latitude,
          'longitude': _longitude,
          'category': categoryTitle,
        },
      );

      if (response.isSuccess) {
        final model = CategoryBrandModel.fromJson(response.responseData);
        brandShops.assignAll(model.data);
        return;
      }

      Get.snackbar(Strings.shopLoadFailed.tr, response.errorMessage);
    } catch (e) {
      Get.snackbar(Strings.shopLoadFailed.tr, e.toString());
    } finally {
      isCategoryShopsLoading.value = false;
    }
  }

  double? _toDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
  }
}
