import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/core/widgets/shimmer/payment_shimmer.dart';
import 'package:hoodz/features/user/profile/data/models/notification_model.dart';
import 'package:hoodz/features/user/profile/presentation/controller/notification_controller.dart';
import 'package:hoodz/features/user/profile/presentation/widgets/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late final NotificationController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<NotificationController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(label: Strings.notification.tr),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.notificationModel == null) {
            return const NotificationListShimmer();
          }

          if (controller.notifications.isEmpty) {
            return RefreshIndicator(
              onRefresh: controller.refreshNotifications,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: 220.h(context)),
                  Center(child: Text(Strings.noNotificationsFound.tr)),
                ],
              ),
            );
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 120) {
                controller.getNotifications(loadMore: true);
              }
              return false;
            },
            child: RefreshIndicator(
              onRefresh: controller.refreshNotifications,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  16.w(context),
                  12.h(context),
                  16.w(context),
                  20.h(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.notifications.any((item) => item.read == false))
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: GestureDetector(
                          onTap: controller.markAllAsDone,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 12.h(context)),
                            child: Text(
                              Strings.markAsDone.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: const Color(0xFFFF6A00),
                                    fontSize: 13.sp(context),
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    _NotificationList(
                      notifications: controller.notifications,
                    ),
                    if (controller.isLoadingMore.value) ...[
                      SizedBox(height: 8.h(context)),
                      const Center(child: CircularProgressIndicator()),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NotificationList extends StatelessWidget {
  const _NotificationList({
    required this.notifications,
  });

  final List<Datum> notifications;

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...notifications.map(
          (item) => Padding(
            padding: EdgeInsets.only(bottom: 10.h(context)),
            child: RiderNotificationItemCard(
              title: item.message ?? '',
              description: item.description ?? '',
              time: _formatNotificationTime(item.date),
              isRead: item.read == true,
              highlighted: item.read == false,
            ),
          ),
        ),
        SizedBox(height: 8.h(context)),
      ],
    );
  }

  String _formatNotificationTime(DateTime? date) {
    if (date == null) {
      return '';
    }

    final localDate = date.toLocal();
    final day = localDate.day.toString().padLeft(2, '0');
    final month = localDate.month.toString().padLeft(2, '0');
    final year = localDate.year.toString();
    final hour = localDate.hour.toString().padLeft(2, '0');
    final minute = localDate.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }
}

class NotificationListShimmer extends StatelessWidget {
  const NotificationListShimmer({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        16.w(context),
        12.h(context),
        16.w(context),
        20.h(context),
      ),
      child: Column(
        children: List.generate(
          itemCount,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 10.h(context)),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 12.w(context),
                vertical: 12.h(context),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2.r(context)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PaymentShimmerBox(
                    height: 36.h(context),
                    width: 36.w(context),
                    radius: 18.r(context),
                    circle: true,
                  ),
                  SizedBox(width: 12.w(context)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: PaymentShimmerBox(
                                height: 14.h(context),
                                width: double.infinity,
                                radius: 4.r(context),
                              ),
                            ),
                            SizedBox(width: 16.w(context)),
                            PaymentShimmerBox(
                              height: 12.h(context),
                              width: 82.w(context),
                              radius: 4.r(context),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h(context)),
                        PaymentShimmerBox(
                          height: 12.h(context),
                          width: double.infinity,
                          radius: 4.r(context),
                        ),
                        SizedBox(height: 7.h(context)),
                        PaymentShimmerBox(
                          height: 12.h(context),
                          width: 210.w(context),
                          radius: 4.r(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
