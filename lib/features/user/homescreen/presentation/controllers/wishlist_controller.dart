import 'package:get/get.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/home_screen_controller.dart';
import 'package:hoodz/urls.dart';

class WishListController extends GetxController {
  WishListController(this._networkCaller);
  final RxMap<String, bool> _wishlistStates = <String, bool>{}.obs;
  final RxSet<String> _togglingProductIds = <String>{}.obs;
  final NetworkCaller _networkCaller;
  final HomeScreenController _homeScreenController =
      Get.find<HomeScreenController>();

  bool isProductWishlisted(String? productId, {bool fallback = false}) {
    if (productId == null || productId.isEmpty) {
      return fallback;
    }

    return _wishlistStates[productId] ?? fallback;
  }

  bool isTogglingWishlist(String? productId) {
    if (productId == null || productId.isEmpty) {
      return false;
    }

    return _togglingProductIds.contains(productId);
  }

  Future<bool?> toggleProductWishlist({
    required String productId,
    required bool currentValue,
    String modelType = 'product',
  }) async {
    if (productId.isEmpty || _togglingProductIds.contains(productId)) {
      return null;
    }

    final nextValue = !isProductWishlisted(productId, fallback: currentValue);

    _togglingProductIds.add(productId);
    _wishlistStates[productId] = nextValue;

    try {
      final response = await _networkCaller.postRequest(

        Urls.getWishlistToggleUrlById(productId),
        body: {'modelType': modelType},
        accessToken: MySharedPref.getAccessToken(),
      );

      if (!response.isSuccess) {
        _wishlistStates[productId] = currentValue;
        Get.snackbar('Wishlist Update Failed', response.errorMessage);
        return null;
      }

      final serverValue = _extractWishlistedState(response.responseData);
      if (serverValue != null) {
        _wishlistStates[productId] = serverValue;
        _homeScreenController.updateWishlistStatus(
          productId: productId,
          isWishlisted: serverValue,
        );
        return serverValue;
      }
    } finally {
      _togglingProductIds.remove(productId);
    }

    return _wishlistStates[productId];
  }

  bool? _extractWishlistedState(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      final directValue = responseData['isWishlisted'];
      if (directValue is bool) {
        return directValue;
      }

      final nestedData = responseData['data'];
      if (nestedData is Map<String, dynamic>) {
        final nestedValue = nestedData['isWishlisted'];
        if (nestedValue is bool) {
          return nestedValue;
        }

        final addedValue = nestedData['added'];
        if (addedValue is bool) {
          return addedValue;
        }
      }
    }

    return null;
  }
  @override
  void onClose() {
    super.onClose();
  }
}
