import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:get/get.dart';

class PaymentSuccessfullController extends GetxController {
  PaymentSuccessfullController()
      : orderConfirmedLabel = _formatCurrentDate();

  final String orderConfirmedLabel;
  final RxnString _orderId = RxnString();
  bool _hasTriggeredOrdersRefresh = false;

  String? get orderId => _orderId.value;
  bool get hasTriggeredOrdersRefresh => _hasTriggeredOrdersRefresh;

  void setOrderId(String? value) {
    final normalized = value?.trim();
    _orderId.value = normalized == null || normalized.isEmpty ? null : normalized;
  }

  void clearOrderId() {
    _orderId.value = null;
  }

  void markOrdersRefreshTriggered() {
    _hasTriggeredOrdersRefresh = true;
  }

  final List<OrderTimelineItem> timelineItems = [
    OrderTimelineItem(
      title: Strings.orderConfirmed.tr,
      timeLabel: '',
      state: OrderTimelineState.upcoming,
    ),
    OrderTimelineItem(
      title: Strings.orderPrepared.tr,
      timeLabel: Strings.upcoming.tr,
      state: OrderTimelineState.upcoming,
    ),
    OrderTimelineItem(
      title: Strings.riderAssigned.tr,
      timeLabel: Strings.upcoming.tr,
      state: OrderTimelineState.upcoming,
    ),
    OrderTimelineItem(
      title: Strings.onTheWay.tr,
      timeLabel: Strings.upcoming.tr,
      state: OrderTimelineState.upcoming,
    ),
    OrderTimelineItem(
      title: Strings.nearby.tr,
      timeLabel: Strings.upcoming.tr,
      state: OrderTimelineState.upcoming,
    ),
    OrderTimelineItem(
      title: Strings.delivered.tr,
      timeLabel: Strings.upcoming.tr,
      state: OrderTimelineState.upcoming,
    ),
  ];

  static String _formatCurrentDate() {
    final now = DateTime.now();
    const monthNames = <String>[
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

    final month = monthNames[now.month - 1];
    return '${now.day.toString().padLeft(2, '0')} $month ${now.year}';
  }
}

class OrderTimelineItem {
  final String title;
  final String timeLabel;
  final OrderTimelineState state;

  const OrderTimelineItem({
    required this.title,
    required this.timeLabel,
    required this.state,
  });
}

enum OrderTimelineState { completed, upcoming }
