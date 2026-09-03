import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/utils/auth_response_utils.dart';
import 'package:hoodz/core/utils/login_required_dialog.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/shop/data/models/shop_details_model.dart';
import 'package:hoodz/urls.dart';

class ShopDetailsController extends GetxController {
  ShopDetailsController();

  final NetworkCaller _networkCaller = Get.find<NetworkCaller>();

  final RxBool isLoading = false.obs;
  final Rx<ShopDetailsModel?> _shopDetailsModel = Rx<ShopDetailsModel?>(null);
  final RxString shopIdData = ''.obs;
  String? _loadedShopId;

  ShopDetailsModel? get shopDetailsModel => _shopDetailsModel.value;
  Data? get shopData => _shopDetailsModel.value?.data;

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

    if (forceRefresh || _loadedShopId != shopId) {
      _loadedShopId = shopId;
      shopIdData.value = shopId;
      _shopDetailsModel.value = null;
    }

    loadShopData(force: true);
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

  Future<void> loadShopData({bool force = false}) async {
    if (isLoading.value) {
      return;
    }

    if (!force && _shopDetailsModel.value != null) {
      return;
    }

    if (shopIdData.value.isEmpty) {
      return;
    }

    final accessToken = MySharedPref.getAccessToken();
    final hasAccessToken = accessToken?.trim().isNotEmpty == true;

    try {
      isLoading.value = true;

      final response = hasAccessToken
          ? await _networkCaller.getRequest(
              Urls.getShopDetailsUrlById(shopIdData.value),
              accessToken: accessToken,
            )
          : await _networkCaller.getRequest(
              Urls.getShopDetailsUrlById(shopIdData.value),
            );

      if (hasAccessToken && isLoginRequiredResponse(response)) {
        showLoginRequiredDialog();
        return;
      }

      if (response.isSuccess) {
        _shopDetailsModel.value = ShopDetailsModel.fromJson(
          response.responseData,
        );
      } else {
        Get.snackbar(Strings.shopLoadFailed.tr, response.errorMessage);
      }
    } catch (e) {
      Get.snackbar(Strings.shopLoadFailed.tr, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  String get shopName => shopData?.shop?.name ?? '';

  String get shopDescription => shopData?.shop?.description ?? '';

  String get shopCoverPhoto => shopData?.shop?.coverPhoto ?? '';

  String get shopProfileAvatar => shopData?.shop?.profileAvatar ?? '';

  String get distanceText {
    final distanceKm = shopData?.distance?.distanceKm;
    final durationMinutes = shopData?.distance?.durationMinutes;

    final distanceValue = distanceKm?.toString() ?? '0';
    final durationValue = durationMinutes?.toString() ?? '0';
    return '$distanceValue km, $durationValue min';
  }

  String get ratingText => (shopData?.shop?.avgRating ?? 0).toString();

  String get followersText => (shopData?.shop?.followers ?? 0).toString();

  String get deliveryTimeText {
    final minTime = shopData?.policies?.deliveryMinTime?.time?.toString() ?? '';
    final minUnit = shopData?.policies?.deliveryMinTime?.unit ?? '';
    final maxTime = shopData?.policies?.deliveryMaxTime?.time?.toString() ?? '';
    final maxUnit = shopData?.policies?.deliveryMaxTime?.unit ?? '';

    if (minTime.isEmpty && maxTime.isEmpty) {
      return '';
    }

    return '$minTime$minUnit - $maxTime$maxUnit';
  }

  List<String> get categories =>
      shopData?.categories
          .map((category) => category.title ?? '')
          .where((title) => title.isNotEmpty)
          .toList() ??
      const [];

  List<String> get storePolicies {
    final policies = shopData?.policies;
    if (policies == null) {
      return const [];
    }

    final items = <String>[];

    if (policies.isInstantDeliveryAvailable == true) {
      items.add(Strings.instantDeliveryAvailable.tr);
    }

    final openingTime = _formatTime(policies.openingTime);
    final closingTime = _formatTime(policies.closingTime);
    if (openingTime.isNotEmpty || closingTime.isNotEmpty) {
      items.add('${Strings.openPrefix.tr} $openingTime - $closingTime');
    }

    if (policies.weekends.isNotEmpty) {
      items.add('${Strings.weekend.tr}: ${policies.weekends.join(', ')}');
    }

    final returnPolicy = _formatTime(
      policies.returnPolicyTime?.time?.toString(),
      unit: policies.returnPolicyTime?.unit,
    );
    if (returnPolicy.isNotEmpty) {
      items.add('${Strings.returnPolicy.tr}: $returnPolicy');
    }

    return items;
  }

  String _formatTime(String? value, {String? unit}) {
    if (value == null || value.isEmpty) {
      return '';
    }
    return unit == null || unit.isEmpty ? value : '$value $unit';
  }
}
