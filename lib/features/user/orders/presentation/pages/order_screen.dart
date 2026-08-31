import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/features/user/orders/data/models/my_order_model.dart'
    as order_model;
import 'package:hoodz/features/user/orders/presentation/controllers/order_summary_controller.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/my_orders_controller.dart';
import 'package:hoodz/features/user/orders/presentation/pages/customer_services_screen.dart';
import 'package:hoodz/features/user/orders/presentation/pages/check_out_screen.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/order_card.dart';
import 'package:hoodz/features/user/chat/presentation/controllers/chat_system_controller.dart';

class OrderScreen extends GetView<MyOrdersController> {
  const OrderScreen({super.key});

  List<Map<String, dynamic>> _buildReorderItemsPayload(
    order_model.Datum order,
  ) {
    final items = <Map<String, dynamic>>[];

    for (final item in order.items) {
      final productId = item.product?.id?.trim();
      if (productId == null || productId.isEmpty) {
        continue;
      }

      final payload = <String, dynamic>{
        'product': productId,
        'quantity': item.quantity ?? 1,
      };

      final size = item.size?.trim();
      if (size != null && size.isNotEmpty) {
        payload['size'] = size;
      }

      final colorCode = item.color?.code?.trim();
      final colorName = item.color?.name?.trim();
      if (colorCode != null &&
          colorCode.isNotEmpty &&
          colorName != null &&
          colorName.isNotEmpty) {
        payload['color'] = {'code': colorCode, 'name': colorName};
      }

      items.add(payload);
    }

    return items;
  }

  Future<void> _handleReorder(order_model.Datum order) async {
    final items = _buildReorderItemsPayload(order);
    if (items.isEmpty) {
      showAppToast(
        message: Strings.reorderItemsNotFoundForThisOrder.tr,
        isError: true,
      );
      return;
    }

    final orderSummaryController = Get.find<OrderSummaryController>();
    final isSuccess = await orderSummaryController.createOrderSummary(
      itemsOverride: items,
      onSuccessNavigate: () {
        Get.to(() => const CheckoutScreen());
      },
    );

    if (!isSuccess) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyOrdersController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            Strings.orders.tr,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h(context)),
              Row(
                children: List.generate(controller.orderStatuses.length, (
                  index,
                ) {
                  final isSelected = controller.selectedStatusIndex == index;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => controller.changeStatus(index),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.orderStatuses[index],
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontSize: 14.sp(context),
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? const Color(0xFFF75908)
                                      : const Color(0xFF7A7A7A),
                                ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10.h(context)),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            height: 2.h(context),
                            width: double.infinity,
                            color: isSelected
                                ? const Color(0xFFF75908)
                                : const Color(0xFFE8E8E8),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 20.h(context)),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (controller.isLoading && controller.orders.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final orders = controller.orders;

                    if (orders.isEmpty) {
                      return Center(
                        child: Text(
                          Strings.noOrdersHereYet.tr,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () =>
                          controller.fetchOrders(forceRefresh: true),
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: orders.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: 16.h(context)),
                        itemBuilder: (context, i) {
                          final order = orders[i];
                          return OrderCard(
                            imageUrl: controller.orderImage(order),
                            name: controller.orderName(order),
                            date: controller.orderDate(order),
                            orderID: controller.orderId(order),
                            price: controller.orderPrice(order),
                            type: controller.orderType(order),
                            item: controller.orderItemCount(order),
                            onTap: () {
                              final orderType = controller.orderType(order);

                              if (orderType == 'processing') {
                                final orderId = controller.orderRawId(order);
                                if (orderId.isEmpty) {
                                  return;
                                }

                                PageNavigationService.to(
                                  context,
                                  AppRoutes.paymentDetails,
                                  arguments: {'orderId': orderId},
                                );
                                return;
                              }

                              if (orderType == 'cancelled') {
                                _handleReorder(order);
                              }
                            },
                            onReorder: () => _handleReorder(order),
                            optionalOnTap: () {
                              final orderId = controller.orderRawId(order);
                              if (orderId.isEmpty) {
                                showAppToast(
                                  message: Strings.orderIdNotFound.tr,
                                  isError: true,
                                );
                                return;
                              }

                              final hasGrievance = order.hasGrievance ?? false;

                              if (hasGrievance) {
                                Get.find<ChatSystemController>()
                                    .createOrderSupportChat(orderId: orderId);
                                return;
                              }

                              Get.to(
                                () => const CustomerServiceScreen(),
                                arguments: {'orderId': orderId},
                              );
                            },
                          ); 
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
