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
import 'package:hoodz/features/user/orders/presentation/controllers/order_summary_controller.dart';
import 'package:hoodz/features/user/profile/data/models/user_profile_model.dart'
    as user_profile;
import 'package:hoodz/features/user/profile/presentation/controller/profile_controller.dart';
import 'package:hoodz/urls.dart';

class ProductOrderController extends GetxController {
  ProductOrderController()
      : _networkCaller = Get.find<NetworkCaller>(),
        _cartController = Get.find<CartController>(),
        _profileController = Get.find<ProfileController>(),
        _orderSummaryController = Get.find<OrderSummaryController>();

  final NetworkCaller _networkCaller;
  final CartController _cartController;
  final ProfileController _profileController;
  final OrderSummaryController _orderSummaryController;

  final RxBool isLoading = false.obs;
  final RxList<String> createdOrderIds = <String>[].obs;

  Future<bool> createProductOrder({
    String? deliveryType,
    String? voucherCode,
    int? redeemCoins,
    String? note,
  }) async {
    if (_orderSummaryController.orderSummaryData == null) {
      showAppToast(
        message: 'Order summary not found. Please create summary again.',
        isError: true,
      );
      return false;
    }

    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      showAppToast(
        message: 'Access token not found. Please login again.',
        isError: true,
      );
      return false;
    }

    final items = _buildItemsPayload();
    if (items.isEmpty) {
      showAppToast(message: 'Cart is empty.', isError: true);
      return false;
    }

    final orderData = <String, dynamic>{
      'deliveryType': deliveryType ?? 'regular',
      'billingDetails': _buildBillingDetails(note: note),
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

    await showLoadingOverLay(
      msg: 'Creating order...',
      asyncFunction: () async {
        isLoading.value = true;

        try {
          final response = await _networkCaller.postRequest(
            Urls.orderUrl,
            accessToken: accessToken,
            body: body,
          );

          if (!response.isSuccess) {
            showAppToast(message: response.errorMessage, isError: true);
            return;
          }

          final ids = _extractOrderIds(response.responseData);
          createdOrderIds.assignAll(ids);

          // Keep the controller's order summary data available for follow-up
          // screens, but log the newly created order ids for debugging.
          // ignore: avoid_print
          print('Created order ids: $ids');

          isSuccess = true;
        } finally {
          isLoading.value = false;
        }
      },
    );

    return isSuccess;
  }

  List<Map<String, dynamic>> _buildItemsPayload() {
    final orderSummaryItems = _buildItemsPayloadFromOrderSummary();
    if (orderSummaryItems.isNotEmpty) {
      return orderSummaryItems;
    }

    final cartItems = _cartController.cartItems;
    if (cartItems.isEmpty) {
      return const [];
    }

    return cartItems.map((item) {
      return {
        'product': _resolveProductId(item),
        'quantity': item.quantity ?? 1,
        'size': _normalizeString(item.size),
        'color': _buildColorPayload(item.color),
      };
    }).toList(growable: false);
  }

  List<Map<String, dynamic>> _buildItemsPayloadFromOrderSummary() {
    final summaryOrders = _orderSummaryController.orderSummaryData?.orders;
    if (summaryOrders == null || summaryOrders.isEmpty) {
      return const [];
    }

    final items = <Map<String, dynamic>>[];
    for (final order in summaryOrders) {
      for (final item in order.items) {
        final productId =
            _normalizeString(item.productId) ?? _normalizeString(item.product?.id);
        if (productId == null) {
          continue;
        }

        final payload = <String, dynamic>{
          'product': productId,
          'quantity': item.quantity ?? 1,
        };

        final size = _normalizeString(item.size);
        if (size != null) {
          payload['size'] = size;
        }

        final color = _buildOrderSummaryColorPayload(item.color);
        if (color != null) {
          payload['color'] = color;
        }

        items.add(payload);
      }
    }

    return items;
  }

  Map<String, dynamic>? _buildBillingDetails({String? note}) {
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
      'note': _normalizeString(note),
    };
  }

  Map<String, dynamic>? _buildDeliveryLocation(
    user_profile.Location? location,
  ) {
    final coordinates = location?.coordinates;
    if (coordinates == null || coordinates.length < 2) {
      return null;
    }

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

  Map<String, dynamic>? _buildOrderSummaryColorPayload(
    order_summary.Color? color,
  ) {
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

  List<String> _extractOrderIds(dynamic responseData) {
    final directIds = <String>{};

    if (responseData is Map) {
      final data = responseData['data'];

      if (data is Map) {
        final orders = data['orders'];
        if (orders is Iterable) {
          for (final order in orders) {
            if (order is Map && order['_id'] != null) {
              directIds.add(order['_id'].toString());
            }
          }
        }

        if (directIds.isNotEmpty) {
          return directIds.toList(growable: false);
        }

        if (data['_id'] != null) {
          return <String>[data['_id'].toString()];
        }
      }

      if (data is Iterable) {
        for (final item in data) {
          if (item is Map && item['_id'] != null) {
            directIds.add(item['_id'].toString());
          }
        }

        if (directIds.isNotEmpty) {
          return directIds.toList(growable: false);
        }
      }

      if (responseData['_id'] != null) {
        return <String>[responseData['_id'].toString()];
      }
    }

    final fallbackIds = <String>{};

    void visit(dynamic value) {
      if (value is Map) {
        for (final entry in value.entries) {
          final entryValue = entry.value;
          if (entry.key.toString() == '_id' && entryValue != null) {
            fallbackIds.add(entryValue.toString());
          }
          visit(entryValue);
        }
        return;
      }

      if (value is Iterable) {
        for (final entry in value) {
          visit(entry);
        }
      }
    }

    visit(responseData);
    return fallbackIds.toList(growable: false);
  }
}
