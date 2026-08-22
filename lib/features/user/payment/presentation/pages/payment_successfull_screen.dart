import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/payment_successfull_controller.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/estimated_delivery_card.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/order_timeline_tile.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/success_card.dart';

class PaymentSuccessfullScreen extends GetView<PaymentSuccessfullController> {
  const PaymentSuccessfullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            14.w(context),
            8.h(context),
            14.w(context),
            20.h(context),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 18.h(context)),
                      SuccessCard(),
                      SizedBox(height: 18.h(context)),
                      const EstimatedDeliveryCard(),
                      SizedBox(height: 22.h(context)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Order Timeline',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontSize: 18.sp(context),
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF444444),
                              ),
                        ),
                      ),
                      SizedBox(height: 14.h(context)),
                      ...List.generate(controller.timelineItems.length, (
                        index,
                      ) {
                        final item = controller.timelineItems[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h(context)),
                          child: OrderTimelineTile(
                            title: item.title,
                            timeLabel: item.timeLabel,
                            state: item.state,
                            showConnector:
                                index != controller.timelineItems.length - 1,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h(context)),
              CustomButton(
                text: 'Order Details',
                onPressed: () {
                  PageNavigationService.to(context, AppRoutes.paymentDetails);
                },
              ),
              SizedBox(height: 10.h(context)),
              TextButton(
                onPressed: () {
                  PageNavigationService.offAll(context, AppRoutes.userDashboard);
                },
                child: Text(
                  'Back to Homepage',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 15.sp(context),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF505050),
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
