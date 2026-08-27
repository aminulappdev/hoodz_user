import 'package:get/get.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/others/show_loader.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/orders/data/models/my_cart_model.dart'
    as cart_model;
import 'package:hoodz/features/user/orders/data/models/order_summary_model.dart'
    as order_summary;
import 'package:hoodz/features/user/orders/presentation/controllers/cart_controller.dart';
import 'package:hoodz/features/user/profile/data/models/user_profile_model.dart'
    as user_profile;
import 'package:hoodz/features/user/profile/presentation/controller/profile_controller.dart';
import 'package:hoodz/urls.dart';

class OrderSummaryController extends GetxController {
  OrderSummaryController()
      : _networkCaller = Get.find<NetworkCaller>(),
        _cartController = Get.find<CartController>(),
        _profileController = Get.find<ProfileController>();

  final NetworkCaller _networkCaller;
  final CartController _cartController;
  final ProfileController _profileController;

  final RxBool isLoading = false.obs;
  final Rxn<order_summary.OrderSummaryModel> _orderSummaryModel =
      Rxn<order_summary.OrderSummaryModel>();
  String _lastDeliveryType = 'regular';
  String? _lastVoucherCode;
  int? _lastRedeemCoins;
  String? _lastNote;
  List<Map<String, dynamic>>? _lastItemsPayload;
  _OrderItemsSource _lastItemsSource = _OrderItemsSource.none;

  order_summary.OrderSummaryModel? get orderSummaryModel =>
      _orderSummaryModel.value;

  order_summary.Data? get orderSummaryData => _orderSummaryModel.value?.data;

  Future<bool> createOrderSummary({
    String deliveryType = 'regular',
    String? voucherCode,
    int? redeemCoins,
    String? note,
    List<Map<String, dynamic>>? itemsOverride,
    void Function()? onSuccessNavigate,
  }) async {
    _lastDeliveryType = deliveryType;
    _lastVoucherCode = voucherCode;
    _lastRedeemCoins = redeemCoins;
    _lastNote = note;

    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      showAppToast(
        message: 'Access token not found. Please login again.',
        isError: true,
      );
      return false;
    }

    if (itemsOverride != null) {
      _lastItemsPayload = itemsOverride;
      _lastItemsSource = _OrderItemsSource.override;
    }

    final cartItemsPayload = _buildItemsPayload();
    if (itemsOverride == null && cartItemsPayload.isNotEmpty) {
      _lastItemsPayload = cartItemsPayload;
      _lastItemsSource = _OrderItemsSource.cart;
    }

    final items = itemsOverride ??
        (_lastItemsSource == _OrderItemsSource.override
            ? _lastItemsPayload
            : cartItemsPayload.isNotEmpty
                ? cartItemsPayload
                : _lastItemsPayload) ??
        const <Map<String, dynamic>>[];
    if (items.isEmpty) {
      showAppToast(message: 'Cart is empty.', isError: true);
      return false;
    }

    final orderData = <String, dynamic>{
      'deliveryType': deliveryType,
      'billingDetails': _buildBillingDetails(),
    };

    if (voucherCode != null && voucherCode.trim().isNotEmpty) {
      orderData['voucherCode'] = voucherCode.trim();
    }
    if (redeemCoins != null) {
      orderData['redeemCoins'] = redeemCoins;
    }

    final body = <String, dynamic>{
      'items': items,
      'orderData': orderData,
    };

    bool isSuccess = false;
    bool shouldNavigate = false;

    await showLoadingOverLay(
      msg: 'Creating order summary...',
      asyncFunction: () async {
        isLoading.value = true;

        try {
          final response = await _networkCaller.postRequest(
            Urls.orderSummaryUrl,
            accessToken: accessToken,
            body: body,
          );

          if (!response.isSuccess) {
            showAppToast(message: response.errorMessage, isError: true);
            return;
          }

          final responseData = response.responseData;
          if (responseData is! Map<String, dynamic>) {
            showAppToast(
              message: 'Invalid order summary response.',
              isError: true,
            );
            return;
          }

          _orderSummaryModel.value =
              order_summary.OrderSummaryModel.fromJson(responseData);
          isSuccess = true;
          shouldNavigate = onSuccessNavigate != null;
        } finally {
          isLoading.value = false;
        }
      },
    );

    if (isSuccess && shouldNavigate && onSuccessNavigate != null) {
      onSuccessNavigate();
    }

    return isSuccess;
  }

  Future<bool> refreshOrderSummary() async {
    return createOrderSummary(
      deliveryType: _lastDeliveryType,
      voucherCode: _lastVoucherCode,
      redeemCoins: _lastRedeemCoins,
      note: _lastNote,
      itemsOverride: _lastItemsSource == _OrderItemsSource.override
          ? _lastItemsPayload
          : null,
    );
  }

  List<Map<String, dynamic>> _buildItemsPayload() {
    return _cartController.cartItems.map((item) {
      return {
        'product': _resolveProductId(item),
        'quantity': item.quantity ?? 1,
        'size': _normalizeString(item.size),
        'color': _buildColorPayload(item.color),
      };
    }).toList(growable: false);
  }

  Map<String, dynamic>? _buildBillingDetails() {
    final userData = _profileController.userData;
    final deliveryAddress = userData?.deliveryAddress;
    final deliveryLocation = deliveryAddress?.location;

    return {
      'name': _normalizeString(userData?.name),
      'address': _normalizeString(deliveryAddress?.name) ??
          _normalizeString(userData?.address),
      'phoneNumber': _resolvePhoneNumber(userData),
      'email': _normalizeString(userData?.email),
      'buildingNo': deliveryAddress?.buildingNo,
      'floorNo': deliveryAddress?.floorNo,
      'apartment': deliveryAddress?.apartment,
      'city': _normalizeString(deliveryAddress?.city),
      'country': _normalizeString(deliveryAddress?.country),
      'deliveryLocation': _buildDeliveryLocation(deliveryLocation),
      'note': _lastNote,
    };
  }

  Map<String, dynamic>? _buildDeliveryLocation(
    user_profile.Location? location,
  ) {
    final coordinates = location?.coordinates;
    if (coordinates == null || coordinates.length < 2) {
      return null;
    }

    // Backend stores geo coordinates as [longitude, latitude].
    final longitude = coordinates[0].toDouble();
    final latitude = coordinates[1].toDouble();

    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  Map<String, dynamic>? _buildColorPayload(cart_model.Color? color) {
    final code = _normalizeString(color?.code);
    final name = _normalizeString(color?.name);

    if (code == null && name == null) {
      return null;
    }

    return {
      'code': code,
      'name': name,
    };
  }

  String? _resolveProductId(cart_model.Item item) {
    return _normalizeString(item.productId) ?? _normalizeString(item.product?.id);
  }

  String? _resolvePhoneNumber(user_profile.Data? userData) {
    final phone = _normalizeString(userData?.phone);
    if (phone == null) {
      return null;
    }

    if (phone.startsWith('+')) {
      return phone;
    }

    final countryCode = _normalizeString(userData?.countryCode);
    if (countryCode == null) {
      return phone;
    }

    final normalizedCountryCode = countryCode.startsWith('+')
        ? countryCode
        : '+$countryCode';
    return '$normalizedCountryCode$phone';
  }

  String? _normalizeString(String? value) {
    final normalized = value?.trim();
    return (normalized == null || normalized.isEmpty) ? null : normalized;
  }

  void clearOrderSummary() {
    _orderSummaryModel.value = null;
    _lastItemsPayload = null;
    _lastItemsSource = _OrderItemsSource.none;
  }
}

enum _OrderItemsSource {
  none,
  cart,
  override,
}
