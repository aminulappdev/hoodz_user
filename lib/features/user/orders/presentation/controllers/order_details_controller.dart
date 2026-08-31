import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/others/show_loader.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/orders/data/models/order_details_model.dart'
    as order_details;
import 'package:hoodz/features/user/payment/presentation/controllers/payment_details_controller.dart'
    as tracking;
import 'package:hoodz/urls.dart';

class OrderDetailsController extends GetxController {
  OrderDetailsController() : _networkCaller = Get.find<NetworkCaller>();

  final NetworkCaller _networkCaller;
 
  final RxBool isLoading = false.obs;
  final Rxn<order_details.OrderDetailsModel> _orderDetailsModel =
      Rxn<order_details.OrderDetailsModel>();
  String? _pendingOrderId;
  String? _loadedOrderId;

  order_details.OrderDetailsModel? get orderDetailsModel =>
      _orderDetailsModel.value;

  order_details.Data? get orderDetailsData => _orderDetailsModel.value?.data;

  String get riderImageUrl =>
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e';
  String get riderName => 'Shahid Hasan';
  String get riderRating => '4.7';
  String get riderVehicleId => 'E2561'; 
  String get riderPhoneNumber => '+880124 65664';

  String get orderNumber {
    final id = orderDetailsData?.id ?? orderDetailsData?.dataId;
    if (id == null || id.isEmpty) {
      return '#${Strings.notAvailable.tr}';
    }

    return '#$id';
  }

  String get orderItemsCount {
    final count = orderDetailsData?.totalOrderItems ??
        orderDetailsData?.items.length ??
        0;
    return '$count ${Strings.items.tr}';
  }

  String get paymentMethod {
    final paymentStatus =
        orderDetailsData?.paymentStatus?.toLowerCase() ?? '';
    if (paymentStatus.contains('paid')) {
      return Strings.debitCreditCard.tr;
    }
    if (paymentStatus.contains('wallet')) {
      return Strings.wallet.tr;
    }
    return Strings.cashOnDelivery.tr;
  }

  String get totalAmount =>
      '\$${(orderDetailsData?.totalAmount ?? 0).toDouble().toStringAsFixed(2)}';

  String get buildingNumber =>
      (orderDetailsData?.billingDetails?.buildingNo ?? 0).toString();

  String get floorNumber =>
      (orderDetailsData?.billingDetails?.floorNo ?? 0).toString();

  String get apartmentNumber =>
      (orderDetailsData?.billingDetails?.apartment ?? 0).toString();

  String get addressLine {
    final billing = orderDetailsData?.billingDetails;
    final parts = <String>[
      billing?.address ?? '',
      billing?.city ?? '',
      billing?.country ?? '',
    ]
        .where((part) => part.trim().isNotEmpty)
        .map((part) => part.trim())
        .toList();

    if (parts.isNotEmpty) {
      return parts.join(', ');
    }

    return billing?.address?.trim().isNotEmpty == true
        ? billing!.address!
        : Strings.notAvailable.tr;
  }

  String get addressNote =>
      orderDetailsData?.billingDetails?.note?.toString() ?? Strings.notAvailable.tr;

  bool get hasGrievance => orderDetailsData?.hasGrievance ?? false;

  List<tracking.TrackingTimelineItem> get timelineItems {
    final data = orderDetailsData;
    final steps = <_TimelineStep>[
      _TimelineStep(Strings.orderConfirmed.tr, _toDateTime(data?.confirmedAt)),
      _TimelineStep(Strings.orderPrepared.tr, _toDateTime(data?.processedAt)),
      _TimelineStep(Strings.riderAssigned.tr, _toDateTime(data?.riderAssignedAt)),
      _TimelineStep(Strings.onTheWay.tr, _toDateTime(data?.pickedUpAt)),
      _TimelineStep(Strings.onTheWay.tr, _toDateTime(data?.onTheWayAt)),
      _TimelineStep(Strings.delivered.tr, _toDateTime(data?.deliveredAt)),
    ];

    final cancelledAt = _toDateTime(data?.cancelledAt);
    if (cancelledAt != null) {
      steps.add(_TimelineStep(Strings.cancelled.tr, cancelledAt));
    }

    final activeIndex = steps.lastIndexWhere((step) => step.date != null);

    return steps.asMap().entries.map((entry) {
      final index = entry.key;
      final step = entry.value;
      final hasDate = step.date != null;

      final state = activeIndex == -1
          ? tracking.TrackingTimelineState.pending
          : index == activeIndex
              ? tracking.TrackingTimelineState.active
              : index < activeIndex && hasDate
                  ? tracking.TrackingTimelineState.completed
                  : tracking.TrackingTimelineState.pending;

      return tracking.TrackingTimelineItem(
        title: step.title,
        trailingText: hasDate ? _formatDateTime(step.date) : Strings.upcoming.tr,
        state: state,
      );
    }).toList();
  }

  void setPendingOrderId(String? orderId) {
    _pendingOrderId = orderId;
  }

  Future<bool> fetchOrderDetails({String? orderId}) async {
    final resolvedOrderId = orderId ?? _pendingOrderId;
    if (resolvedOrderId == null || resolvedOrderId.isEmpty) {
      showAppToast(message: Strings.orderIdNotFound.tr, isError: true);
      return false;
    }

    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      showAppToast(
        message: Strings.accessTokenNotFoundPleaseLoginAgain.tr,
        isError: true,
      );
      return false;
    }

    bool isSuccess = false;

    await showLoadingOverLay(
      msg: Strings.loading.tr,
      asyncFunction: () async {
        isSuccess = await _fetchOrderDetailsResolved(
          resolvedOrderId: resolvedOrderId,
          accessToken: accessToken,
          showLoaderState: true,
          showErrorMessages: true,
        );
      },
    );

    return isSuccess;
  }

  Future<bool> refreshOrderDetailsSilently({String? orderId}) async {
    final resolvedOrderId = orderId ?? _pendingOrderId;
    if (resolvedOrderId == null || resolvedOrderId.isEmpty) {
      return false;
    }

    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      return false;
    }

    return _fetchOrderDetailsResolved(
      resolvedOrderId: resolvedOrderId,
      accessToken: accessToken,
      showLoaderState: false,
      showErrorMessages: false,
    );
  }

  void clearOrderDetails() {
    _orderDetailsModel.value = null;
    _loadedOrderId = null;
  }

  Future<bool> _fetchOrderDetailsResolved({
    required String resolvedOrderId,
    required String accessToken,
    required bool showLoaderState,
    required bool showErrorMessages,
  }) async {
    if (showLoaderState) {
      isLoading.value = true;
    }

    try {
      final response = await _networkCaller.getRequest(
        Urls.getOrderDetailsUrlById(resolvedOrderId),
        accessToken: accessToken,
      );

      if (!response.isSuccess) {
        if (showErrorMessages) {
          showAppToast(message: response.errorMessage, isError: true);
        }
        return false;
      }

      final responseData = response.responseData;
      if (responseData is! Map<String, dynamic>) {
        if (showErrorMessages) {
          showAppToast(
            message: Strings.requestFailed.tr,
            isError: true,
          );
        }
        return false;
      }

      _orderDetailsModel.value =
          order_details.OrderDetailsModel.fromJson(responseData);
      _loadedOrderId = resolvedOrderId;
      _pendingOrderId = resolvedOrderId;
      return true;
    } finally {
      if (showLoaderState) {
        isLoading.value = false;
      }
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Upcoming';
    }

    return DateFormat('d MMM, y - h:mm a').format(dateTime.toLocal());
  }

  DateTime? _toDateTime(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.tryParse(value.toString());
  }
}

class _TimelineStep {
  const _TimelineStep(this.title, this.date);

  final String title;
  final DateTime? date;
}
