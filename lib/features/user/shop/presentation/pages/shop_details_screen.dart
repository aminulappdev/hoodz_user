import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/app_cached_network_image.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/about_row_info.dart';
import 'package:hoodz/features/user/shop/presentation/controller/shop_details_controller.dart';
import 'package:hoodz/features/user/shop/presentation/widgets/shop_tag.dart';

class ShopDetailsScreen extends GetView<ShopDetailsController> {
  const ShopDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
 
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final shop = controller.shopData?.shop;
        final categories = controller.categories;
        final policies = controller.storePolicies;

        if (shop == null) {
          return const Center(child: Text('No shop details found'));
        }

        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AppCachedNetworkImage(
                      imageUrl: controller.shopCoverPhoto,
                      imageHeight: 240.h(context),
                      imageWidth: width,
                      imageFit: BoxFit.cover,
                      radius: 0,
                    ),
                    Positioned(
                      top: 16.h(context),
                      left: 16.w(context),
                      child: _BackButton(onTap: () => Navigator.pop(context)),
                    ),
                    Positioned(
                      left: 18.w(context),
                      bottom: -36.h(context),
                      child: CircleAvatar(
                        radius: 36.r(context),
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 32.r(context),
                          backgroundImage: controller.shopProfileAvatar.isEmpty
                              ? null
                              : NetworkImage(controller.shopProfileAvatar),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 48.h(context)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w(context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.shopName,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        fontSize: 22.sp(context),
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xff454545),
                                      ),
                                ),
                                SizedBox(height: 6.h(context)),
                                Wrap(
                                  spacing: 12.w(context),
                                  runSpacing: 6.h(context),
                                  children: [
                                    _MetaChip(label: controller.distanceText),
                                    if (controller.deliveryTimeText.isNotEmpty)
                                      _MetaChip(
                                        label: controller.deliveryTimeText,
                                      ),
                                  ],
                                ),
                                SizedBox(height: 6.h(context)),
                                Wrap(
                                  spacing: 12.w(context),
                                  runSpacing: 6.h(context),
                                  children: [
                                    _MetaChip(
                                      label:
                                          '${controller.ratingText} (${controller.shopData?.shop?.ratingCount ?? 0})',
                                    ),
                                    _MetaChip(label: controller.followersText),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 18.h(context)),
                      Text(
                        controller.shopDescription,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp(context),
                          height: 1.55,
                          color: const Color(0xff787878),
                        ),
                      ),
                      SizedBox(height: 20.h(context)),
                      AboutInfoRow(
                        label: 'Established',
                        value: controller.shopData?.shop?.createdAt == null
                            ? '-'
                            : controller.shopData!.shop!.createdAt!.year
                                  .toString(),
                      ),
                      AboutInfoRow(
                        label: 'Location',
                        value: controller.shopData?.shop?.address ?? '-',
                      ),
                      AboutInfoRow(
                        label: 'Rating',
                        value:
                            '${controller.ratingText} (${controller.shopData?.shop?.ratingCount ?? 0})',
                      ),
                      AboutInfoRow(
                        label: 'Followers',
                        value: controller.followersText,
                      ),
                      SizedBox(height: 20.h(context)),
                      Text(
                        'Category',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 15.sp(context),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff4A4A4A),
                        ),
                      ),
                      SizedBox(height: 12.h(context)),
                      categories.isEmpty
                          ? const Text('No categories available')
                          : Wrap(
                              spacing: 10.w(context),
                              runSpacing: 10.h(context),
                              children: categories
                                  .map(
                                    (category) => ShopTag(category: category),
                                  )
                                  .toList(),
                            ),
                      SizedBox(height: 24.h(context)),
                      Text(
                        'Store policies',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 15.sp(context),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff4A4A4A),
                        ),
                      ),
                      SizedBox(height: 10.h(context)),
                      policies.isEmpty
                          ? const Text('No store policies available')
                          : Column(
                              children: policies
                                  .map(
                                    (policy) => Padding(
                                      padding: EdgeInsets.only(
                                        bottom: 8.h(context),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: 6.h(context),
                                              right: 8.w(context),
                                            ),
                                            child: Container(
                                              height: 4.h(context),
                                              width: 4.w(context),
                                              decoration: const BoxDecoration(
                                                color: Color(0xff7A7A7A),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              policy,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    fontSize: 14.sp(context),
                                                    color: const Color(
                                                      0xff666666,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
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
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42.h(context),
        width: 42.w(context),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w(context),
        vertical: 8.h(context),
      ),
      decoration: BoxDecoration(
        color: const Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(999.r(context)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 12.sp(context),
          color: const Color(0xff6B6B6B),
        ),
      ),
    );
  }
}
