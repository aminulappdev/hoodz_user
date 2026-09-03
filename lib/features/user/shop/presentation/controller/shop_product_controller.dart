import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/utils/auth_response_utils.dart';
import 'package:hoodz/core/utils/login_required_dialog.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/shop/data/models/shop_product_model.dart';
import 'package:hoodz/urls.dart';

class ShopProductController extends GetxController {
  ShopProductController();

  final NetworkCaller _networkCaller = Get.find<NetworkCaller>();

  final RxBool isLoading = false.obs;
  final RxBool isProductsLoading = false.obs;
  final Rx<ShopProductModel?> _shopProductModel = Rx<ShopProductModel?>(null);
  final RxList<AllProduct> _recommendedProducts = <AllProduct>[].obs;
  final RxList<AllProduct> _allProducts = <AllProduct>[].obs;
  final RxString shopIdData = ''.obs;
  final RxString selectedCategory = ''.obs;
  String? _loadedShopId;

  ShopProductModel? get shopProductModel => _shopProductModel.value;
  Data? get shopProductsData => _shopProductModel.value?.data;

  List<AllProduct> get recommendedProducts => _recommendedProducts;

  List<AllProduct> get allProducts => _allProducts;

  void updateWishlistStatus({
    required String productId,
    required bool isWishlisted,
  }) {
    List<AllProduct> updateProducts(List<AllProduct> products) {
      return products
          .map(
            (product) => product.id == productId
                ? product.copyWith(isWishlisted: isWishlisted)
                : product,
          )
          .toList();
    }

    _recommendedProducts.assignAll(updateProducts(_recommendedProducts));
    _allProducts.assignAll(updateProducts(_allProducts));

    final currentModel = _shopProductModel.value;
    final currentData = currentModel?.data;
    if (currentModel == null || currentData == null) {
      return;
    }

    _shopProductModel.value = currentModel.copyWith(
      data: currentData.copyWith(
        recommends: updateProducts(currentData.recommends),
        allProducts: updateProducts(currentData.allProducts),
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    initialize(arguments is Map<String, dynamic> ? arguments : null);
  }

  void initialize(
    Map<String, dynamic>? arguments, {
    bool forceRefresh = false,
  }) {
    final rawShopId = arguments?['shopId'] ?? arguments?['reference'];
    final shopId = _extractShopId(rawShopId);

    if (shopId == null || shopId.isEmpty) {
      _showShopIdError();
      return;
    }

    final isSameShop = _loadedShopId == shopId;

    if (!isSameShop) {
      _loadedShopId = shopId;
      shopIdData.value = shopId;
      selectedCategory.value = '';
      _shopProductModel.value = null;
      _recommendedProducts.clear();
      _allProducts.clear();
    }

    if (isSameShop && _shopProductModel.value != null && !forceRefresh) {
      return;
    }

    loadShopProducts(
      force: true,
      updateRecommended: !isSameShop || forceRefresh,
    );
  }

  void selectCategory(String category) {
    final normalizedCategory = category.trim();
    if (selectedCategory.value == normalizedCategory) {
      clearCategory();
      return;
    }

    selectedCategory.value = normalizedCategory;
    loadShopProducts(
      force: true,
      category: normalizedCategory,
      updateRecommended: false,
    );
  }

  void clearCategory() {
    if (selectedCategory.value.isEmpty) {
      return;
    }

    selectedCategory.value = '';
    loadShopProducts(force: true, updateRecommended: false);
  }

  void _showShopIdError() {
    Get.snackbar(Strings.shopLoadFailed.tr, Strings.shopIdNotFound.tr);
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

  Future<void> loadShopProducts({
    bool force = false,
    String? category,
    bool updateRecommended = false,
  }) async {
    if (isProductsLoading.value) {
      return;
    }

    if (!force && _shopProductModel.value != null && !updateRecommended) {
      return;
    }

    if (shopIdData.value.isEmpty) {
      return;
    }

    final accessToken = MySharedPref.getAccessToken();
    final hasAccessToken = accessToken?.trim().isNotEmpty == true;

    try {
      isProductsLoading.value = true;
      if (updateRecommended) {
        isLoading.value = true;
      }

      final queryParameters = <String, String>{};
      final normalizedCategory =
          category?.trim() ?? selectedCategory.value.trim();
      if (normalizedCategory.isNotEmpty) {
        queryParameters['category'] = normalizedCategory;
      }

      final uri = Uri.parse(Urls.getShopProductsUrlById(shopIdData.value));
      final requestUrl = queryParameters.isEmpty
          ? uri.toString()
          : uri.replace(queryParameters: queryParameters).toString();

      final response = hasAccessToken
          ? await _networkCaller.getRequest(
              requestUrl,
              accessToken: accessToken,
            )
          : await _networkCaller.getRequest(requestUrl);

      if (hasAccessToken && isLoginRequiredResponse(response)) {
        showLoginRequiredDialog();
        return;
      }

      if (response.isSuccess) {
        final model = ShopProductModel.fromJson(response.responseData);
        _shopProductModel.value = model;

        if (updateRecommended || _recommendedProducts.isEmpty) {
          _recommendedProducts.assignAll(model.data?.recommends ?? const []);
        }

        _allProducts.assignAll(model.data?.allProducts ?? const []);
      } else {
        Get.snackbar(Strings.shopLoadFailed.tr, response.errorMessage);
      }
    } catch (e) {
      Get.snackbar(Strings.shopLoadFailed.tr, e.toString());
    } finally {
      isProductsLoading.value = false;
      isLoading.value = false;
    }
  }
}
