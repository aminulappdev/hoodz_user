import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/banner_card.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/brand_product_card.dart';
import 'package:hoodz/features/user/shop/presentation/controller/shop_details_controller.dart';
import 'package:hoodz/features/user/shop/presentation/controller/shop_product_controller.dart';
import 'package:hoodz/features/user/shop/presentation/controller/sho_connection_controoler.dart';
import 'package:hoodz/features/user/shop/presentation/widgets/shop_availability_card.dart';
import 'package:hoodz/features/user/shop/presentation/widgets/shop_category_tab_bar.dart';
import 'package:hoodz/features/user/shop/presentation/widgets/shop_header_section.dart';

class ShopScreen extends GetView<ShopDetailsController> {
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
                isFollowing: isFollowing,
                isFollowLoading: isFollowLoading,
                onTapFollow: connectionController.toggleFollow,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w(context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShopAvailabilityCard(
                      policies: controller.shopData?.policies,
                    ),
                    SizedBox(height: 20.h(context)),
                    Text(
                      'High Recommended',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 18.sp(context),
                        fontWeight: FontWeight.w800,
                        color: const Color(0xff2F2F2F),
                      ),
                    ),
                    SizedBox(height: 12.h(context)),
                    SizedBox(
                      height: 100.h(context),
                      child: isProductsLoading && featuredProducts.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : featuredProducts.isEmpty
                          ? const Center(child: Text('No product found'))
                          : ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: featuredProducts.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(width: 12.w(context)),
                              itemBuilder: (context, index) {
                                final product = featuredProducts[index];
                                return ShopCard(
                                  image: product.banner ?? '',
                                  name: product.title ?? '',
                                  rating: product.avgRating?.toString() ?? '0',
                                  distance: controller.distanceText,
                                  time: controller.deliveryTimeText,
                                  onTap: () {
                                    PageNavigationService.to(
                                      context,
                                      AppRoutes.productDetails,
                                      arguments: {'productId': product.id},
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                    SizedBox(height: 16.h(context)),
                    ShopCategoryTabBar(
                      categories: controller.categories,
                      selectedCategory:
                          shopProductController.selectedCategory.value,
                      onTapAll: shopProductController.clearCategory,
                      onTapCategory: shopProductController.selectCategory,
                    ),
                    SizedBox(height: 20.h(context)),
                    isProductsLoading && allProducts.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : allProducts.isEmpty
                        ? Container(
                            height: 90.h(context),
                            alignment: Alignment.center,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                14.r(context),
                              ),
                              border: Border.all(
                                color: const Color(0xFFEAEAEA),
                              ),
                            ),
                            child: const Text('No product found'),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: allProducts.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12.w(context),
                                  mainAxisSpacing: 12.h(context),
                                  childAspectRatio: 0.68,
                                ),
                            itemBuilder: (context, index) {
                              final product = allProducts[index];
                              final inStock = product.inStock == true;
                              final priceValue =
                                  product.discountPrice ?? product.price ?? 0;
                              final oldPriceValue =
                                  product.discountPrice != null &&
                                      product.price != null &&
                                      product.discountPrice != product.price
                                  ? '\$${product.price}'
                                  : '';

                              return BrandProductCard(
                                name: product.title ?? '',
                                subtitle:
                                    product.collectionType ??
                                    product.brand ??
                                    controller.shopName,
                                image: product.banner ?? '',
                                price: '\$$priceValue',
                                oldPrice: oldPriceValue,
                                rating: product.avgRating?.toString() ?? '0',
                                stockLabel: inStock
                                    ? 'In Stock'
                                    : 'Out of Stock',
                                onTap: () {
                                  PageNavigationService.to(
                                    context,
                                    AppRoutes.productDetails,
                                    arguments: {'productId': product.id},
                                  );
                                },
                                onTapFavourite: () {},
                              );
                            },
                          ),
                    SizedBox(height: 24.h(context)),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
