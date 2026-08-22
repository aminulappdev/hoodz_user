import 'package:get/get.dart';

class PaymentDetailsController extends GetxController {
  final String riderImageUrl = 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e';
  final String riderName = 'Shahid Hasan';
  final String riderRating = '4.7';
  final String riderVehicleId = 'E2561';
  final String riderPhoneNumber = '+880124 65664';
  final String orderNumber = '#ORDNYPHXBOME';
  final String orderItemsCount = '3 items';
  final String paymentMethod = 'Cash on Delivery';
  final String totalAmount = '\$656.02';
  final String buildingNumber = '324';
  final String floorNumber = '3rd';
  final String apartmentNumber = '5';
  final String addressLine = 'New York, NY 002';
  final String addressNote =
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using Content here.';

  final List<TrackingTimelineItem> timelineItems = const [
    TrackingTimelineItem(
      title: 'Order Confirmed',
      trailingText: '2:30 PM',
      state: TrackingTimelineState.completed,
    ),
    TrackingTimelineItem(
      title: 'Order Prepared',
      trailingText: '2:45 PM',
      state: TrackingTimelineState.completed,
    ),
    TrackingTimelineItem(
      title: 'Rider Assigned',
      trailingText: '3:00 PM',
      state: TrackingTimelineState.completed,
    ),
    TrackingTimelineItem(
      title: 'On the Way',
      trailingText: '3:00 PM',
      state: TrackingTimelineState.completed,
    ),
    TrackingTimelineItem(
      title: 'Nearby',
      trailingText: 'In 15 min',
      state: TrackingTimelineState.active,
    ),
    TrackingTimelineItem(
      title: 'Delivered',
      trailingText: 'Pending',
      state: TrackingTimelineState.pending,
    ),
  ];
}

class TrackingTimelineItem {
  final String title;
  final String trailingText;
  final TrackingTimelineState state;

  const TrackingTimelineItem({
    required this.title,
    required this.trailingText,
    required this.state,
  });
}

enum TrackingTimelineState { completed, active, pending }
