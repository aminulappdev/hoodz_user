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
 
  final RxInt selectedColorIndex = 1.obs;

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
      if (_loadedProductId == productId) {
        if (_productDetailsModel.value == null && !isLoading.value) {
          loadProductData(force: true);
        }
        return;
      }

      _loadedProductId = productId;
      productIdData.value = productId;
      selectedSize.value = 'XS';
      selectedColorIndex.value = 1;
      _productDetailsModel.value = null;
      loadProductData(force: true);
      return;
    }

    _showProductIdError();
  }

  void _showProductIdError() {
    Get.snackbar('Product Load Failed', 'Product ID not found.');
  }

  void onSizeSelected(String size) {
    selectedSize.value = size;
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
        'Profile Load Failed',
        'Access token not found. Please login again.',
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
      } else {
        Get.snackbar('Product Load Failed', response.errorMessage);
      }
    } catch (e) {
      Get.snackbar('Product Load Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
