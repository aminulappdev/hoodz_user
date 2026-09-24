import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/utils/auth_response_utils.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/login_required_dialog.dart';
import 'package:hoodz/core/utils/order_status_label.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/orders/data/models/my_order_model.dart';
import 'package:hoodz/urls.dart';

class MyOrdersController extends GetxController {
  MyOrdersController() : _networkCaller = Get.find<NetworkCaller>();

  final NetworkCaller _networkCaller;

  bool isLoading = false;
  int selectedStatusIndex = 0;
  MyOrderModel? _myOrderModel;
  final List<Datum> _orders = [];
  final Map<String, MyOrderModel> _cachedModels = {};
  int _requestSerial = 0;

  List<String> get orderStatuses => [
        Strings.active.tr,
        Strings.completed.tr,
        Strings.cancelled.tr,
      ];

  final List<String> _filters = const [
    'active',
    'completed',
    'cancelled',
  ];

  MyOrderModel? get myOrderModel => _myOrderModel;

  List<Datum> get orders => _orders;

  String get currentFilter => _filters[selectedStatusIndex];

  @override
  void onInit() {
    super.onInit();
    fetchOrders(forceRefresh: true);
  }

  Future<void> refreshOrdersSilently() async {
    await fetchOrders(forceRefresh: true);
  }

  void changeStatus(int index) {
    if (index == selectedStatusIndex) {
      return;
    }

    selectedStatusIndex = index;
    final cachedModel = _cachedModels[currentFilter];
    if (cachedModel != null) {
      _myOrderModel = cachedModel;
      _orders
        ..clear()
        ..addAll(cachedModel.data);
      update();
      return;
    }

    fetchOrders();
  }

  Future<void> fetchOrders({bool forceRefresh = false}) async {
    final accessToken = MySharedPref.getAccessToken();
    final hasAccessToken = accessToken?.trim().isNotEmpty == true;

    if (!forceRefresh) {
      final cachedModel = _cachedModels[currentFilter];
      if (cachedModel != null) {
        _myOrderModel = cachedModel;
        _orders
          ..clear()
          ..addAll(cachedModel.data);
        update();
        return;
      }
    }

    final requestId = ++_requestSerial;
    isLoading = true;
    update();
    try {
      final response = hasAccessToken
          ? await _networkCaller.getRequest(
              Urls.myOrdersUrl,
              accessToken: accessToken,
              queryParams: {'filter': currentFilter},
            )
          : await _networkCaller.getRequest(
              Urls.myOrdersUrl,
              queryParams: {'filter': currentFilter},
            );

      if (isLoginRequiredResponse(response)) {
        _showLoginRequiredDialog();
        return;
      }

      if (!response.isSuccess) {
        showAppToast(message: response.errorMessage, isError: true);
        return;
      }

      final responseData = response.responseData;
      if (requestId != _requestSerial) {
        return;
      }

      try {
        if (responseData is Map<String, dynamic>) {
          final model = MyOrderModel.fromJson(responseData);
          _cachedModels[currentFilter] = model;
          _myOrderModel = model;
          _orders
            ..clear()
            ..addAll(model.data);
          update();
          return;
        }

        if (responseData is List) {
          final model = MyOrderModel(
            success: true,
            statusCode: response.statusCode,
            message: null,
            meta: null,
            data: responseData
                .whereType<Map<String, dynamic>>()
                .map(Datum.fromJson)
                .toList(),
          );
          _cachedModels[currentFilter] = model;
          _myOrderModel = model;
          _orders
            ..clear()
            ..addAll(model.data);
          update();
          return;
        }

        showAppToast(
          message: 'Invalid order response received.',
          isError: true,
        );
      } catch (e) {
        showAppToast(
          message: 'Failed to parse orders: $e',
          isError: true,
        );
      }
    } finally {
      isLoading = false;
      update();
    }
  }

  void _showLoginRequiredDialog() {
    showLoginRequiredDialog();
  }

  String orderImage(Datum order) {
    return order.items.isNotEmpty &&
            order.items.first.product?.banner?.isNotEmpty == true
        ? order.items.first.product!.banner!
        : 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab';
  }

  String orderName(Datum order) {
    final productTitle = order.items.isNotEmpty
        ? order.items.first.product?.displayTitle
        : null;

    return productTitle?.isNotEmpty == true
        ? productTitle!
        : 'Order ${order.id ?? order.datumId ?? ''}'.trim();
  }

  String orderDate(Datum order) {
    final createdAt = order.createdAt;
    if (createdAt == null) {
      return 'N/A';
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final day = createdAt.day.toString().padLeft(2, '0');
    final month = months[createdAt.month - 1];
    final year = createdAt.year;
    return '$day $month $year';
  }

  String orderId(Datum order) {
    final id = order.datumId ?? order.id ?? '';
    if (id.isEmpty) {
      return '#N/A';
    }

    return id.startsWith('#') ? id : '#$id';
  }

  String orderRawId(Datum order) {
    return order.id ?? order.datumId ?? '';
  }

  String orderPrice(Datum order) {
    final amount = order.totalAmount ?? 0;
    return amount.toDouble().toStringAsFixed(2);
  }

  String orderType(Datum order) {
    final status = (order.status ?? '').toLowerCase();
    if (status.contains('cancel')) {
      return 'cancelled';
    }

    if (status.contains('complete') || status.contains('deliver')) {
      return 'completed';
    }

    return 'processing';
  }

  String orderStatusLabel(Datum order) {
    return OrderStatusLabel.from(order.status);
  }

  int orderItemCount(Datum order) {
    return order.totalItem ?? order.items.length;
  }
}
