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
      title: 'Order Confirmed',
      timeLabel: '',
      state: OrderTimelineState.upcoming,
    ),
    OrderTimelineItem(
      title: 'Order Prepared',
      timeLabel: 'Upcoming', 
      state: OrderTimelineState.upcoming,
    ),
    OrderTimelineItem(
      title: 'Rider Assigned',
      timeLabel: 'Upcoming',
      state: OrderTimelineState.upcoming,
    ),
    OrderTimelineItem(
      title: 'On the way',
      timeLabel: 'Upcoming',
      state: OrderTimelineState.upcoming,
    ),
    OrderTimelineItem(
      title: 'Nearby',
      timeLabel: 'Upcoming',
      state: OrderTimelineState.upcoming,
    ),
    OrderTimelineItem(
      title: 'Delivered',
      timeLabel: 'Upcoming',
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
