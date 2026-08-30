import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hoodz/core/services/socket/user_order_socket_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/order_details_controller.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/live_tracking_map_panel.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/tracking_summary_card.dart';
import 'package:latlong2/latlong.dart';

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({super.key});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  late final OrderDetailsController _orderDetailsController;
  late final UserOrderSocketService _userOrderSocketService;
  late final LatLng? _fallbackDestination;
  String? _trackingOrderId;

  @override
  void initState() {
    super.initState();
    _orderDetailsController = Get.find<OrderDetailsController>();
    _userOrderSocketService = Get.find<UserOrderSocketService>();
    _fallbackDestination = _extractFallbackDestination(
      _orderDetailsController,
    );
    _trackingOrderId = _resolveOrderId();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureTrackingStarted();
    });
  }

  String? _resolveOrderId() {
    final orderId =
        _orderDetailsController.orderDetailsData?.id ??
        _orderDetailsController.orderDetailsData?.dataId;

    if (orderId == null || orderId.trim().isEmpty) {
      return null;
    }

    return orderId.trim();
  }

  Future<void> _ensureTrackingStarted() async {
    final orderId = _trackingOrderId ?? _resolveOrderId();
    if (orderId == null || orderId.isEmpty) {
      debugPrint('LiveTrackingScreen: order id not found, tracking skipped.');
      return;
    }

    _trackingOrderId = orderId;
    await _userOrderSocketService.startTracking(orderId: orderId);
    debugPrint('LiveTrackingScreen: tracking enabled for order $orderId');
  }


  String _distanceText(UserOrderTrackingLocation? trackingLocation) {
    final rider = trackingLocation?.riderLocation;
    final destination = trackingLocation?.destinationLocation;
    final fallbackDestination = _fallbackDestination;
    final destinationPoint = destination != null
        ? LatLng(destination.lat, destination.lng)
        : fallbackDestination;

    if (rider == null || destinationPoint == null) {
      return '--';
    }

    final meters = Geolocator.distanceBetween(
      rider.lat,
      rider.lng,
      destinationPoint.latitude,
      destinationPoint.longitude,
    );

    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }

    return '${meters.toStringAsFixed(0)} m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        final trackingLocation =
            _userOrderSocketService.currentTrackingLocation.value;
        final distanceText = _distanceText(trackingLocation);

        return Stack(
          children: [
            Positioned.fill(
              child: LiveTrackingMapPanel(
                expand: true,
                borderRadius: BorderRadius.zero,
                trackingLocation: trackingLocation,
                fallbackDestination: _fallbackDestination,
              ),
            ),
            SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    top: 12.h(context),
                    left: 12.w(context),
                    child: Material(
                      color: Colors.black.withOpacity(0.35),
                      shape: const CircleBorder(),
                      child: IconButton(
                        onPressed: Get.back,
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  if (_orderDetailsController.orderDetailsData?.rider != null)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          14.w(context),
                          0,
                          14.w(context),
                          14.h(context),
                        ),
                        child: TrackingSummaryCard(distanceText: distanceText),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

LatLng? _extractFallbackDestination(
  OrderDetailsController orderDetailsController,
) {
  final coordinates =
      orderDetailsController.orderDetailsData?.deliveryJob?.destination
          ?.coordinates;

  if (coordinates == null || coordinates.length < 2) {
    return null;
  }

  return LatLng(
    coordinates[1].toDouble(),
    coordinates[0].toDouble(),
  );
}
