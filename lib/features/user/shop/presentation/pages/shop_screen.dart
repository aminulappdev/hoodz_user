import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/shop/presentation/controller/shop_controller.dart';
import 'package:hoodz/features/user/shop/presentation/widgets/shop_header_section.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/about_section.dart';
import 'package:hoodz/features/user/product/presentation/widgets/product_section.dart';

class ShopScreen extends GetView<ShopController> {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: Colors.white,
      body: Obx(
        () => Column( 
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShopHeader(
              shopName: controller.shopName.value,
              distance: controller.distance.value,
              deliveryTime: controller.deliveryTime.value,
              rating: controller.rating.value.toString(),
              likes: controller.likes.value,
              followers: controller.followers.value,
              description: controller.description.value,
              categories: controller.categories.toList(),
            ),
            Transform.translate(
              offset: Offset(0, -18.h(context)),
              child: _ShopTabBar(
                selectedIndex: controller.selectedTabIndex.value,
                onTabSelected: controller.changeTab,
              ),
            ),
            SizedBox(height: 0.h(context)),
            if (controller.selectedTabIndex.value == 0)
              ProductSection(
                recommendedItems: controller.productList.take(4).toList(),
                products: controller.productList,
              )
            else
              AboutSection(
                shopName: controller.shopName.value,
                description: controller.description.value,
                establishedYear: controller.establishedYear.value,
                location: controller.location.value,
                ratingSummary: controller.ratingSummary.value,
                followers: controller.followers.value,
                categories: controller.categories.toList(),
                storePolicies: controller.storePolicies,
              ),
          ],
        ),
      ),
    );
  }
}

class _ShopTabBar extends StatelessWidget {
  const _ShopTabBar({required this.selectedIndex, required this.onTabSelected});

  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    const tabs = ['Products', 'About'];

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xffEFEFEF))),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;
          return Expanded(
            child: InkWell(
              onTap: () => onTabSelected(index),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14.h(context)),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected
                          ? const Color(0xffFF6B1A)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  tabs[index],
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 15.sp(context),
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? const Color(0xffFF6B1A)
                        : const Color(0xff8B8B8B),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
