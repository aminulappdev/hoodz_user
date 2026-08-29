import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/features/user/chat/presentation/controllers/chat_system_controller.dart';
import 'package:hoodz/features/user/orders/data/models/order_details_model.dart'
    as order_details;
import 'package:hoodz/features/user/orders/presentation/controllers/order_details_controller.dart';
import 'package:hoodz/features/user/orders/presentation/pages/customer_services_screen.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/live_tracking_map_panel.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/order_details_card.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/order_items_section.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/rider_info_card.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/tracking_summary_card.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/tracking_timeline_tile.dart';

class PaymentDetailsScreen extends StatefulWidget {
  const PaymentDetailsScreen({super.key});

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  late final OrderDetailsController _controller;
  late final ChatSystemController _chatSystemController;
  bool _hasRequestedLoad = false;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<OrderDetailsController>();
    _chatSystemController = Get.find<ChatSystemController>();
    _controller.clearOrderDetails();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrderDetails();
    });
  }

  void _loadOrderDetails() {
    if (_hasRequestedLoad) {
      return;
    }
    _hasRequestedLoad = true;

    final orderId = _extractOrderId(Get.arguments);
    if (orderId == null || orderId.isEmpty) {
      _hasRequestedLoad = false;
      return;
    }

    _controller.fetchOrderDetails(orderId: orderId).then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  String? _extractOrderId(dynamic arguments) {
    if (arguments is Map<String, dynamic>) {
      final value = arguments['orderId'];
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }

    return null;
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: CustomAppBar(label: 'Live Tracking'),
      body: SafeArea(
        child: Obx(() {
          final List<order_details.Item> orderItems =
              _controller.orderDetailsData?.items ??
              const <order_details.Item>[];

          if (_controller.isLoading.value &&
              _controller.orderDetailsData == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
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
                          onTap: () {
                            _chatSystemController.createSingleChat(
                              participantId: '6a5d9e075de489e8e2995305',
                            );
                          },
                          imageUrl: _controller.riderImageUrl,
                          riderName: _controller.riderName,
                          rating: _controller.riderRating,
                          vehicleId: _controller.riderVehicleId,
                          phoneNumber: _controller.riderPhoneNumber,
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
                              ...List.generate(
                                _controller.timelineItems.length,
                                (index) {
                                  final item = _controller.timelineItems[index];
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 12.h(context),
                                    ),
                                    child: TrackingTimelineTile(
                                      title: item.title,
                                      trailingText: item.trailingText,
                                      state: item.state,
                                      showConnector:
                                          index !=
                                          _controller.timelineItems.length - 1,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 14.h(context)),
                        OrderDetailsCard(
                          orderNumber: _controller.orderNumber,
                          itemsCount: _controller.orderItemsCount,
                          paymentMethod: _controller.paymentMethod,
                          totalAmount: _controller.totalAmount,
                        ),
                        SizedBox(height: 14.h(context)),
                        if (orderItems.isNotEmpty) ...[
                          OrderItemsSection(items: orderItems),
                          SizedBox(height: 14.h(context)),
                        ],
                        DeliveryAddressCard(
                          buildingNumber: _controller.buildingNumber,
                          floorNumber: _controller.floorNumber,
                          apartmentNumber: _controller.apartmentNumber,
                          addressLine: _controller.addressLine,
                          note: _controller.addressNote,
                        ),
                        SizedBox(height: 20.h(context)),
                        CustomButton(
                          text: 'Customer Service',
                          onPressed: () {
                            final orderId =
                                _controller.orderDetailsData?.id ??
                                _controller.orderDetailsData?.dataId ??
                                '';

                            if (_controller.hasGrievance) {
                              if (orderId.isEmpty) {
                                return;
                              }

                              _chatSystemController.createOrderSupportChat(
                                orderId: orderId,
                              );
                              return;
                            }

                            Get.to(
                              () => const CustomerServiceScreen(),
                              arguments: {'orderId': orderId},
                            );
                          },
                        ),
                        SizedBox(height: 24.h(context)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
