import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/core/services/socket/user_order_socket_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/order_details_controller.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/live_tracking_map_panel.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/tracking_summary_card.dart';

class LiveTrackingScreen extends StatelessWidget {
  const LiveTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderDetailsController = Get.find<OrderDetailsController>();
    final userOrderSocketService = Get.find<UserOrderSocketService>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        final trackingLocation =
            userOrderSocketService.currentTrackingLocation.value;

        return Stack(
          children: [
            Positioned.fill(
              child: LiveTrackingMapPanel(
                expand: true,
                borderRadius: BorderRadius.zero,
                trackingLocation: trackingLocation,
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
                  if (orderDetailsController.orderDetailsData?.rider != null)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          14.w(context),
                          0,
                          14.w(context),
                          14.h(context),
                        ),
                        child: const TrackingSummaryCard(),
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
