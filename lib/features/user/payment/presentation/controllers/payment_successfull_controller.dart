import 'package:get/get.dart';

class PaymentSuccessfullController extends GetxController {
  final List<OrderTimelineItem> timelineItems = const [
    OrderTimelineItem(
      title: 'Order Confirmed',
      timeLabel: '2:30 PM',
      state: OrderTimelineState.completed,
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
