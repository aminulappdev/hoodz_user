import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/my_orders_controller.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/order_card.dart';

class OrderScreen extends GetView<MyOrdersController> {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyOrdersController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Orders',
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
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final orders = controller.orders;

                    if (orders.isEmpty) {
                      return Center(
                        child: Text(
                          'No orders here yet',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => controller.fetchOrders(forceRefresh: true),
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
                              if (controller.orderType(order) != 'Processing') {
                                return;
                              }                             
                              final orderId = controller.orderRawId(order);
                              if (orderId.isEmpty) {
                                return;
                              }

                              PageNavigationService.to(
                                context,
                                AppRoutes.paymentDetails,
                                arguments: {'orderId': orderId},
                              );
                            },
                            optionalOnTap: () {
                              PageNavigationService.to(
                                context,
                                AppRoutes.aiAssistant,
                                arguments: {
                                  'isShowBackButton': true,
                                  'title': 'Customer support',
                                  'subtitle': 'Online',
                                },
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
