import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/features/user/orders/presentation/pages/customer_services_screen.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/payment_details_controller.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/live_tracking_map_panel.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/order_details_card.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/rider_info_card.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/tracking_summary_card.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/tracking_timeline_tile.dart';

class PaymentDetailsScreen extends GetView<PaymentDetailsController> {
  const PaymentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: CustomAppBar(label: 'Live Tracking'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const LiveTrackingMapPanel(),
              Transform.translate(
                offset: Offset(0, -18.h(context)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w(context)),
                  child: Column(
                    children: [
                      const TrackingSummaryCard(),
                      SizedBox(height: 12.h(context)),
                      RiderInfoCard(
                        imageUrl: controller.riderImageUrl,
                        riderName: controller.riderName,
                        rating: controller.riderRating,
                        vehicleId: controller.riderVehicleId,
                        phoneNumber: controller.riderPhoneNumber,
                      ),
                      SizedBox(height: 14.h(context)),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(
                          14.w(context),
                          16.h(context),
                          14.w(context),
                          8.h(context),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r(context)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x12000000),
                              blurRadius: 16,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order Timeline',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontSize: 18.sp(context),
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF444444),
                                  ),
                            ),
                            SizedBox(height: 14.h(context)),
                            ...List.generate(controller.timelineItems.length, (
                              index,
                            ) {
                              final item = controller.timelineItems[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 12.h(context)),
                                child: TrackingTimelineTile(
                                  title: item.title,
                                  trailingText: item.trailingText,
                                  state: item.state,
                                  showConnector:
                                      index !=
                                      controller.timelineItems.length - 1,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      SizedBox(height: 14.h(context)),
                      OrderDetailsCard(
                        orderNumber: controller.orderNumber,
                        itemsCount: controller.orderItemsCount,
                        paymentMethod: controller.paymentMethod,
                        totalAmount: controller.totalAmount,
                      ),
                      SizedBox(height: 14.h(context)),
                      DeliveryAddressCard(
                        buildingNumber: controller.buildingNumber,
                        floorNumber: controller.floorNumber,
                        apartmentNumber: controller.apartmentNumber,
                        addressLine: controller.addressLine,
                        note: controller.addressNote,
                      ),
                      SizedBox(height: 20.h(context)),
                      CustomButton(
                        text: 'Customer Service',
                        onPressed: () {
                          Get.to(CustomerServiceScreen());
                        },
                      ),
                      SizedBox(height: 24.h(context)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
