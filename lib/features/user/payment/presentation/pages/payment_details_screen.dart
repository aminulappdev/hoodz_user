import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/core/widgets/shimmer/payment_shimmer.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/core/services/socket/user_order_socket_service.dart';
import 'package:hoodz/features/user/chat/presentation/controllers/chat_system_controller.dart';
import 'package:hoodz/features/user/orders/data/models/order_details_model.dart'
    as order_details;
import 'package:hoodz/features/user/orders/presentation/controllers/order_details_controller.dart';
import 'package:hoodz/features/user/orders/presentation/pages/customer_services_screen.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/payment_details_controller.dart'
    as tracking;
import 'package:hoodz/features/user/payment/presentation/pages/live_tracking_screen.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/order_details_card.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/order_items_section.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/rider_info_card.dart';
 
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
      appBar: CustomAppBar(label: Strings.orderDetails.tr),
      body: SafeArea(
        child: Obx(() {
          final List<order_details.Item> orderItems =
              _controller.orderDetailsData?.items ??
              const <order_details.Item>[];

          if (_controller.isLoading.value &&
              _controller.orderDetailsData == null) {
            return const PaymentDetailsShimmer();
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
                        _OrderTimelineProgressCard(
                          orderDetails: _controller.orderDetailsData,
                          timelineItems: _controller.timelineItems,
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
                        text: Strings.customerSupport.tr,
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

class _OrderTimelineProgressCard extends StatelessWidget {
  const _OrderTimelineProgressCard({
    required this.orderDetails,
    required this.timelineItems,
  });

  final order_details.Data? orderDetails;
  final List<tracking.TrackingTimelineItem> timelineItems;

  static const _green = Color(0xFF12B76A);
  static const _mutedLine = Color(0xFFE9ECEF);

  @override
  Widget build(BuildContext context) {
    final steps = _buildSteps();
    final activeIndex = _activeStepIndex(steps);
    final shopName = orderDetails?.author?.name?.trim();
    final bottomTitle = _bottomTitle(steps, activeIndex);
    final bottomSubtitle = _isDelivered(steps)
        ? 'Your order has been delivered'
        : '${shopName?.isNotEmpty == true ? shopName! : 'Style Hut'} is on it! They\'re getting things ready';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20.w(context),
        20.h(context),
        20.w(context),
        16.h(context),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r(context)),
        border: Border.all(color: const Color(0xFFE9EEF2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Order Timeline',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 24.sp(context),
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF363636),
                      ),
                ),
              ),
              SizedBox(width: 12.w(context)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w(context),
                  vertical: 7.h(context),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9F8F1),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFC8EEDC)),
                ),
                child: Text(
                  _isDelivered(steps) ? 'Done' : 'On time',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp(context),
                        fontWeight: FontWeight.w800,
                        color: _green,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 28.h(context)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(steps.length, (index) {
              final step = steps[index];
              return Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _TimelineStepView(
                        step: step,
                      ),
                    ),
                    if (index != steps.length - 1)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 16.h(context)),
                          child: Container(
                            height: 2.h(context),
                            color: step.isCompleted || step.isActive
                                ? _green
                                : _mutedLine,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          SizedBox(height: 20.h(context)),
          const Divider(height: 1, thickness: 1, color: Color(0xFFECEFF2)),
          SizedBox(height: 20.h(context)),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bottomTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 18.sp(context),
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF3A3A3A),
                          ),
                    ),
                    SizedBox(height: 7.h(context)),
                    Text(
                      bottomSubtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 16.sp(context),
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF878787),
                            height: 1.25,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 34,
                color: Color(0xFF7B8087),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<_ProgressStep> _buildSteps() {
    final orderPreparedTitle = Strings.orderPrepared.tr.trim().toLowerCase();
    final nearbyTitle = Strings.nearby.tr.trim().toLowerCase();
    final filteredItems = timelineItems.where((item) {
      final title = item.title.trim().toLowerCase();
      return title != orderPreparedTitle && title != nearbyTitle;
    }).toList(growable: false);
    final uniqueItems = <String, tracking.TrackingTimelineItem>{};

    for (final item in filteredItems) {
      final key = item.title.trim().toLowerCase();
      final current = uniqueItems[key];
      if (current == null ||
          _statePriority(item.state) > _statePriority(current.state)) {
        uniqueItems[key] = item;
      }
    }

    if (uniqueItems.isEmpty) {
      return [
        _ProgressStep(
          label: Strings.orderConfirmed.tr,
          icon: Icons.check_rounded,
          state: tracking.TrackingTimelineState.active,
        ),
      ];
    }

    return uniqueItems.values.map((item) {
      return _ProgressStep(
        label: item.title,
        icon: _iconForTitle(item.title),
        state: item.state,
      );
    }).toList(growable: false);
  }

  int _statePriority(tracking.TrackingTimelineState state) {
    switch (state) {
      case tracking.TrackingTimelineState.active:
        return 3;
      case tracking.TrackingTimelineState.completed:
        return 2;
      case tracking.TrackingTimelineState.pending:
        return 1;
    }
  }

  int _activeStepIndex(List<_ProgressStep> steps) {
    final activeIndex = steps.indexWhere((step) => step.isActive);
    if (activeIndex != -1) {
      return activeIndex;
    }

    final lastCompletedIndex = steps.lastIndexWhere((step) => step.isCompleted);
    if (lastCompletedIndex != -1) {
      return lastCompletedIndex;
    }

    return 0;
  }

  bool _isDelivered(List<_ProgressStep> steps) {
    return steps.any((step) {
      return step.label.toLowerCase().contains('deliver') && step.isCompleted;
    });
  }

  String _bottomTitle(List<_ProgressStep> steps, int activeIndex) {
    if (steps.isEmpty || activeIndex < 0 || activeIndex >= steps.length) {
      return 'Preparing your order';
    }

    return steps[activeIndex].isPending
        ? 'Preparing your order'
        : steps[activeIndex].label;
  }

  IconData _iconForTitle(String title) {
    final normalized = title.toLowerCase();
    if (normalized.contains('deliver') || normalized.contains('confirm')) {
      return Icons.check_rounded;
    }
    if (normalized.contains('rider')) {
      return Icons.person_outline_rounded;
    }
    if (normalized.contains('way')) {
      return Icons.near_me_outlined;
    }
    if (normalized.contains('pick')) {
      return Icons.inventory_2_outlined;
    }
    if (normalized.contains('cancel')) {
      return Icons.close_rounded;
    }
    return Icons.inventory_2_outlined;
  }
}

class _TimelineStepView extends StatelessWidget {
  const _TimelineStepView({
    required this.step,
  });

  final _ProgressStep step;

  static const _green = Color(0xFF12B76A);

  @override
  Widget build(BuildContext context) {
    final circleColor =
        step.isCompleted || step.isActive ? _green : const Color(0xFFF4F4F4);
    final iconColor =
        step.isCompleted || step.isActive ? Colors.white : const Color(0xFF8E949B);
    final textColor = step.isActive || step.isCompleted
        ? const Color(0xFF3A3A3A)
        : const Color(0xFF888888);

    return Column(
      children: [
        Container(
          width: 38.w(context),
          height: 38.w(context),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: circleColor,
            border: Border.all(
              color: step.isCompleted || step.isActive
                  ? Colors.white
                  : const Color(0xFFF2F2F2),
              width: 4,
            ),
            boxShadow: step.isCompleted || step.isActive
                ? const [
                    BoxShadow(
                      color: Color(0x2212B76A),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            step.icon,
            size: 19.sp(context),
            color: iconColor,
          ),
        ),
        SizedBox(height: 10.h(context)),
        Text(
          step.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp(context),
                fontWeight: step.isActive || step.isCompleted
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: textColor,
              ),
        ),
      ],
    );
  }
}

class _ProgressStep {
  const _ProgressStep({
    required this.label,
    required this.icon,
    required this.state,
  });

  final String label;
  final IconData icon;
  final tracking.TrackingTimelineState state;

  bool get isCompleted => state == tracking.TrackingTimelineState.completed;
  bool get isActive => state == tracking.TrackingTimelineState.active;
  bool get isPending => state == tracking.TrackingTimelineState.pending;
}
