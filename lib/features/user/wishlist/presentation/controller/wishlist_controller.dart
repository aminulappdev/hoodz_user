import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/home_screen_controller.dart';
import 'package:hoodz/features/user/wishlist/data/models/wishlist_model.dart';
import 'package:hoodz/urls.dart';

class WishlistController extends GetxController {
  WishlistController(this._networkCaller);

  final NetworkCaller _networkCaller;
  final HomeScreenController _homeScreenController =
      Get.find<HomeScreenController>();
  final RxMap<String, bool> _wishlistStates = <String, bool>{}.obs;
  final RxSet<String> _togglingProductIds = <String>{}.obs;
  final RxBool isLoading = false.obs;
  final RxSet<String> _deletingItemIds = <String>{}.obs;
  final Rx<WishlistModel?> _wishlistModel = Rx<WishlistModel?>(null);

  WishlistModel? get wishlistModel => _wishlistModel.value;
  List<WishlistItemModel> get items => _wishlistModel.value?.data ?? const [];
  bool isDeleting(String itemId) => _deletingItemIds.contains(itemId);

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

  @override
  void onInit() {
    super.onInit();
    getWishlist();
  }

  Future<void> getWishlist() async {
    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      showAppToast(
        message: Strings.accessTokenNotFoundPleaseLoginAgain.tr,
        isError: true,
      );
      return;
    }

    if (isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;

      final response = await _networkCaller.getRequest(
        Urls.wishlistUrl,
        accessToken: accessToken,
      );

      if (response.isSuccess) {
        _wishlistModel.value = WishlistModel.fromJson(response.responseData);
        _rebuildWishlistStatesFromItems();
        return;
      }

      showAppToast(message: response.errorMessage, isError: true);
    } finally {
      isLoading.value = false;
    }
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
        Get.snackbar(Strings.wishlistUpdateFailed.tr, response.errorMessage);
        return null;
      }

      final serverValue = _extractWishlistedState(response.responseData);
      final resolvedValue = serverValue ?? nextValue;
      _wishlistStates[productId] = resolvedValue;
      if (modelType == 'product') {
        _homeScreenController.updateWishlistStatus(
          productId: productId,
          isWishlisted: resolvedValue,
        );
        await syncProductWishlistedState(
          productId: productId,
          isWishlisted: resolvedValue,
        );
      } else {
        await getWishlist();
      }
      return resolvedValue;
    } finally {
      _togglingProductIds.remove(productId);
    }
  }

  Future<void> deleteWishlistItem(String itemId) async {
    if (itemId.isEmpty || _deletingItemIds.contains(itemId)) {
      return;
    }

    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      showAppToast(
        message: Strings.accessTokenNotFoundPleaseLoginAgain.tr,
        isError: true,
      );
      return;
    }

    final currentModel = _wishlistModel.value;
    final currentItems = currentModel?.data ?? const <WishlistItemModel>[];
    final updatedItems = currentItems
        .where((item) => item.id != itemId)
        .toList();

    _deletingItemIds.add(itemId);
    if (currentModel != null) {
      _wishlistModel.value = WishlistModel(
        success: currentModel.success,
        statusCode: currentModel.statusCode,
        message: currentModel.message,
        data: updatedItems,
      );
    }

    try {
      final response = await _networkCaller.deleteRequest(
        Urls.getWishlistUrlById(itemId),
        accessToken: accessToken,
      );

      if (response.isSuccess) {
        String? deletedProductId;
        for (final item in currentItems) {
          if (item.id == itemId) {
            deletedProductId = item.product?.id;
            break;
          }
        }
        if (deletedProductId != null && deletedProductId.isNotEmpty) {
          _homeScreenController.updateWishlistStatus(
            productId: deletedProductId,
            isWishlisted: false,
          );
          _wishlistStates[deletedProductId] = false;
        }
        return;
      }

      if (currentModel != null) {
        _wishlistModel.value = currentModel;
      }
      showAppToast(message: response.errorMessage, isError: true);
    } finally {
      _deletingItemIds.remove(itemId);
    }
  }

  Future<void> syncProductWishlistedState({
    required String productId,
    required bool isWishlisted,
  }) {
    final currentModel = _wishlistModel.value;
    if (currentModel == null) {
      if (isWishlisted) {
        return getWishlist();
      }
      return Future.value();
    }

    if (isWishlisted) {
      return getWishlist();
    }

    final updatedItems = currentModel.data
        .where((item) => item.product?.id != productId)
        .toList();

    _wishlistModel.value = WishlistModel(
      success: currentModel.success,
      statusCode: currentModel.statusCode,
      message: currentModel.message,
      data: updatedItems,
    );
    _wishlistStates[productId] = isWishlisted;
    return Future.value();
  }

  void _rebuildWishlistStatesFromItems() {
    final currentItems =
        _wishlistModel.value?.data ?? const <WishlistItemModel>[];
    _wishlistStates.clear();

    for (final item in currentItems) {
      final productId = item.product?.id;
      if (productId != null && productId.isNotEmpty) {
        _wishlistStates[productId] = true;
      }
    }
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
}
