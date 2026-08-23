import 'package:get/get.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/wishlist/data/models/wishlist_model.dart';
import 'package:hoodz/urls.dart';

class WishlistController extends GetxController {
  WishlistController(this._networkCaller);

  final NetworkCaller _networkCaller;
  final RxBool isLoading = false.obs;
  final RxSet<String> _deletingItemIds = <String>{}.obs;
  final Rx<WishlistModel?> _wishlistModel = Rx<WishlistModel?>(null);

  WishlistModel? get wishlistModel => _wishlistModel.value;
  List<WishlistItemModel> get items => _wishlistModel.value?.data ?? const [];
  bool isDeleting(String itemId) => _deletingItemIds.contains(itemId);

  @override
  void onInit() {
    super.onInit();
    getWishlist();
  }

  Future<void> getWishlist() async {
    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      showAppToast(
        message: 'Access token not found. Please login again.',
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
        return;
      }

      showAppToast(message: response.errorMessage, isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteWishlistItem(String itemId) async {
    if (itemId.isEmpty || _deletingItemIds.contains(itemId)) {
      return;
    }

    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      showAppToast(
        message: 'Access token not found. Please login again.',
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
}
