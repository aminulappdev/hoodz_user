import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/utils/auth_response_utils.dart';
import 'package:hoodz/core/utils/login_required_dialog.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/urls.dart';

class ShoConnectionControoler extends GetxController {
  ShoConnectionControoler();

  final NetworkCaller _networkCaller = Get.find<NetworkCaller>();

  final RxBool isFollowing = false.obs;
  final RxBool isLoading = false.obs;
  final RxString shopIdData = ''.obs;

  String? _boundShopId;

  void bindShop({required String shopId, required bool initialFollowing}) {
    final normalizedShopId = shopId.trim();
    if (normalizedShopId.isEmpty) {
      return;
    }

    final isNewShop = _boundShopId != normalizedShopId;
    _boundShopId = normalizedShopId;
    shopIdData.value = normalizedShopId;

    if (isNewShop) {
      isFollowing.value = initialFollowing;
    }
  }

  Future<void> toggleFollow() async {
    final shopId = _boundShopId;
    if (shopId == null || shopId.isEmpty) {
      Get.snackbar(Strings.actionFailed.tr, Strings.shopIdNotFound.tr);
      return;
    }

    if (isLoading.value) {
      return;
    }

    final accessToken = MySharedPref.getAccessToken();
    final hasAccessToken = accessToken?.trim().isNotEmpty == true;

    final previousValue = isFollowing.value;
    final nextValue = !previousValue;
    isFollowing.value = nextValue;
    isLoading.value = true;

    try {
      final requestUrl = nextValue
          ? Urls.getShopFollowUrlById(shopId)
          : Urls.getShopUnfollowUrlById(shopId);

      final response = hasAccessToken
          ? await _networkCaller.postRequest(
              requestUrl,
              accessToken: accessToken,
            )
          : await _networkCaller.postRequest(requestUrl);

      if (isLoginRequiredResponse(response)) {
        isFollowing.value = previousValue;
        showLoginRequiredDialog();
        return;
      }

      if (!response.isSuccess) {
        isFollowing.value = previousValue;
        Get.snackbar(Strings.actionFailed.tr, response.errorMessage);
      }
    } catch (e) {
      isFollowing.value = previousValue;
      Get.snackbar(Strings.actionFailed.tr, e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
