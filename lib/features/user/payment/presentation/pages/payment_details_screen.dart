import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/core/services/socket/user_order_socket_service.dart';
import 'package:hoodz/features/user/chat/presentation/controllers/chat_system_controller.dart';
import 'package:hoodz/features/user/orders/data/models/order_details_model.dart'
    as order_details;
import 'package:hoodz/features/user/orders/presentation/controllers/order_details_controller.dart';
import 'package:hoodz/features/user/orders/presentation/pages/customer_services_screen.dart';
import 'package:hoodz/features/user/payment/presentation/pages/live_tracking_screen.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/order_details_card.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/order_items_section.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/rider_info_card.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/tracking_timeline_tile.dart';
 
class PaymentDetailsScreen extends StatefulWidget { 
  const PaymentDetailsScreen({super.key});

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  late final OrderDetailsController _controller;
  late final ChatSystemController _chatSystemController;
  late final UserOrderSocketService _userOrderSocketService;
  late final Worker _socketEventWorker;
  bool _hasRequestedLoad = false;
  bool _isRefreshingFromSocket = false;
  String? _orderId; 

  @override
  void initState() {
    super.initState();
    _controller = Get.find<OrderDetailsController>();
    _chatSystemController = Get.find<ChatSystemController>();
    _userOrderSocketService = Get.find<UserOrderSocketService>();
    _controller.clearOrderDetails();
    _orderId = _extractOrderId(Get.arguments);
    _socketEventWorker = ever<String>(
      _userOrderSocketService.lastEventName,
      _handleSocketEvent,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrderDetails();
    });
  }

  @override
  void dispose() {
    _socketEventWorker.dispose();
    super.dispose();
  }

  void _loadOrderDetails() {
    if (_hasRequestedLoad) {
      return;
    }
    _hasRequestedLoad = true;

    final orderId = _orderId;
    if (orderId == null || orderId.isEmpty) {
      _hasRequestedLoad = false;
      return;
    }

    unawaited(_ensureSocketTracking(orderId));
    _controller.fetchOrderDetails(orderId: orderId).then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Future<void> _refreshOrderDetails() async {
    final orderId = _orderId ?? _extractOrderId(Get.arguments);
    if (orderId == null || orderId.isEmpty) {
      return;
    }

    _orderId = orderId;
    _hasRequestedLoad = false;
    await _controller.fetchOrderDetails(orderId: orderId);

    if (!mounted) {
      return;
    }

    setState(() {});
    _ensureSocketTracking(orderId);
  }

  Future<void> _ensureSocketTracking(String orderId) async {
    if (orderId.trim().isEmpty) {
      return;
    }

    await _userOrderSocketService.ensureReady();
    await _userOrderSocketService.startTracking(orderId: orderId);
  }

  void _handleSocketEvent(String eventName) {
    const refreshEvents = <String>{
      'job:rider-assigned',
      'job:picked-up',
      'job:on-the-way',
      'job:otp-sent',
      'job:otp-verified',
      'job:delivered',
      'ride:request-rating',
    };

    if (!refreshEvents.contains(eventName)) {
      return;
    }

    unawaited(_refreshOrderDetailsFromSocket(eventName));
  }

  Future<void> _refreshOrderDetailsFromSocket(String eventName) async {
    if (_isRefreshingFromSocket) {
      return;
    }

    final orderId = _orderId ?? _extractOrderId(Get.arguments);
    if (orderId == null || orderId.isEmpty) {
      return;
    }

    _isRefreshingFromSocket = true;
    try {
      debugPrint('PaymentDetailsScreen: socket event $eventName -> refresh order $orderId');
      await _controller.refreshOrderDetailsSilently(orderId: orderId);

      if (!mounted) {
        return;
      }

      setState(() {});
    } finally {
      _isRefreshingFromSocket = false;
    }
  }

  String _formatRiderRating(num? rating) {
    if (rating == null) {
      return '0';
    }

    return rating % 1 == 0 ? rating.toInt().toString() : rating.toString();
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
      appBar: CustomAppBar(label: 'Order Details'),
      body: SafeArea(
        child: Obx(() {
          final List<order_details.Item> orderItems =
              _controller.orderDetailsData?.items ??
              const <order_details.Item>[];

          if (_controller.isLoading.value &&
              _controller.orderDetailsData == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: _refreshOrderDetails,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w(context)),
                    child: Column(
                      children: [
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
                              ...List.generate(_controller.timelineItems.length,
                                  (index) {
                                final item = _controller.timelineItems[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 12.h(context)),
                                  child: TrackingTimelineTile(
                                    title: item.title,
                                    trailingText: item.trailingText,
                                    state: item.state,
                                    showConnector:
                                        index !=
                                        _controller.timelineItems.length - 1,
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                        if (_controller.orderDetailsData?.rider != null) ...[
                          SizedBox(height: 14.h(context)),
                          Builder(
                            builder: (context) {
                              final rider = _controller.orderDetailsData?.rider;
                              final riderId = rider?.id?.trim() ?? '';
                              final orderId =
                                  _controller.orderDetailsData?.id ??
                                  _controller.orderDetailsData?.dataId ??
                                  '';

                              return RiderInfoCard(
                                liveTrackingButtonHeight: 40.h(context),
                                liveTrackingButtonWidth: 200.w(context),
                                onMessageTap: () {
                                  if (riderId.isEmpty) {
                                    return;
                                  }

                                  _chatSystemController.createSingleChat(
                                    participantId: riderId,
                                  );
                                },
                                onLiveTrackingTap: () {
                                  if (orderId.isNotEmpty) {
                                    _userOrderSocketService.startTracking(
                                      orderId: orderId,
                                    );
                                  }

                                  Get.to(() => const LiveTrackingScreen());
                                },
                                imageUrl: rider?.profileAvatar?.trim().isNotEmpty ==
                                        true
                                    ? rider!.profileAvatar!
                                    : _controller.riderImageUrl,
                                riderName: rider?.name?.trim().isNotEmpty == true
                                    ? rider!.name!
                                    : _controller.riderName,
                                rating: _formatRiderRating(rider?.avgRating),
                                vehicleId: rider?.vehicle?.trim().isNotEmpty ==
                                        true
                                    ? rider!.vehicle!
                                    : _controller.riderVehicleId,
                                phoneNumber: rider?.phone?.trim().isNotEmpty ==
                                        true
                                    ? rider!.phone!
                                    : _controller.riderPhoneNumber,
                              );
                            },
                          ),
                        ],
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
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
