import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/core/services/others/location_selection_service.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/address_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/home_screen_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/pages/carousel_banner.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/home_page_header.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/location_selection_sheet.dart';
import 'package:hoodz/features/user/product/presentation/widgets/product_card.dart';
import 'package:hoodz/features/user/product/presentation/widgets/product_list.dart';
import 'package:hoodz/features/user/profile/presentation/controller/profile_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/view_all.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/voucher_card.dart';

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({super.key});

  Future<void> _showLocationSheet(BuildContext context) async {
    final addressController = Get.find<AddressController>();

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Obx(
        () => LocationSelectionSheet(
          isLoadingCurrentLocation:
              addressController.isLoadingCurrentLocation.value,
          onTapCurrentLocation: () async {
            Navigator.pop(context);
            try {
              await addressController.useCurrentLocation();
            } on LocationServiceException catch (error) {
              Get.snackbar(
                'Location unavailable',
                error.message,
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          onTapDifferentLocation: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.mapLocationPicker).then((
              result,
            ) async {
              if (result is LocationAddress) {
                await addressController.updateAddress(result);
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final profileController = Get.find<ProfileController>();

    return Obx(
      () => Scaffold(
        body: SizedBox(
          height: height,
          width: width,
          child: Column(
            children: [
              CustomHomePageAppBar(
                address: profileController.currentAddress.value.trim().isEmpty
                    ? 'Select your address'
                    : profileController.currentAddress.value,
                notificationCount: controller.notificationCount.value,
                onTapEdit: () => _showLocationSheet(context),
                onTapNotification: () {
                  PageNavigationService.to(
                    context,
                    AppRoutes.riderNotification,
                  );
                },
                onTapSearch: () {
                  PageNavigationService.to(context, AppRoutes.searchScreen);
                },
              ),
              SizedBox(height: 20.h(context)),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w(context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.categoryList.isEmpty
                          ? Container(
                              height: 90.h(context),
                              alignment: Alignment.center,
                              width: double.infinity,
                              decoration: BoxDecoration(color: Colors.white),
                              child: Center(child: Text('No category found')),
                            )
                          : SizedBox(
                              height: 90.h(context),
                              width: double.infinity,
                              child: ListView.separated(
                                itemCount: controller.categoryList.length,

                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: 14.w(context)),
                                itemBuilder: (context, index) {
                                  final category =
                                      controller.categoryList[index];
                                  return BrandList(
                                    image: category['image'] ?? "",
                                    name: category['name'] ?? "",
                                    onTap: () {
                                      PageNavigationService.to(
                                        context,
                                        AppRoutes.allBrand,
                                        arguments: {
                                          "title": category["name"],
                                          "image": category["image"],
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),

                      Text('First Section'),
                      SizedBox(height: 16.h(context)),
                      CarouselBanner(
                        controller.homeData?.firstSectionBanner ?? [],
                        (reference) {
                          PageNavigationService.to(context, AppRoutes.shop);
                        },
                      ),
                      SizedBox(height: 12.h(context)),
                      Text(
                        'Near by Brands',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 16.sp(context),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 8.h(context)),
                      SizedBox(
                        height: 100.h(context),
                        child: ListView.separated(
                          itemCount:
                              controller.homeData?.nearbyBrands.length ?? 0,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 14.w(context)),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final brand =
                                controller.homeData!.nearbyBrands[index];
                            return GestureDetector(
                              onTap: () {
                                PageNavigationService.to(
                                  context,
                                  AppRoutes.shop,
                                );
                              },
                              child: CircleAvatar(
                                radius: 36.r(context),
                                backgroundImage: NetworkImage(
                                  brand.profileAvatar ?? "",
                                ),
                                //child: CrashSafeImage(brand?.profileAvatar ?? '', fit: BoxFit.cover),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 12.h(context)),
                      Text(
                        'Recently Viewed',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 16.sp(context),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 8.h(context)),
                      controller.homeData!.recentlyViwed.isEmpty
                          ? Container(
                              height: 100.h(context),
                              alignment: Alignment.center,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  10.r(context),
                                ),
                                border: Border.all(
                                  color: const Color(0xFFE5E5E5),
                                ),
                              ),
                              child: Center(child: Text('No recently viewed')),
                            )
                          : SizedBox(
                              height: 266.h(context),
                              child: ListView.separated(
                                itemCount:
                                    controller.homeData?.recentlyViwed.length ??
                                    0,
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: 14.w(context)),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final product =
                                      controller.homeData!.recentlyViwed[index];
                                  final name = product.title ?? "";
                                  final image = product.image ?? "";
                                  final price = "\${product.price ?? ''}";
                                  final rating = "\${product.avgRating ?? ''}";
                                  return ProductCard(
                                    name: name,
                                    image: image,
                                    price: price,
                                    rating: rating,
                                    onTap: () {
                                      PageNavigationService.to(
                                        context,
                                        AppRoutes.productDetails,
                                      );
                                    },
                                    onTapFavourite: () {},
                                  );
                                },
                              ),
                            ),
                      SizedBox(height: 12.h(context)),
                      ViewAllList(
                        title: 'Trending Now',
                        onTap: () {
                          PageNavigationService.to(
                            context,
                            AppRoutes.allProduct,
                            arguments: {'title': 'Trending Now'},
                          );
                        },
                      ),
                      SizedBox(height: 8.h(context)),
                      SizedBox(
                        height: 266.h(context),
                        child: ListView.separated(
                          itemCount:
                              controller.homeData?.trandingProducts.length ?? 0,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 14.w(context)),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final product =
                                controller.homeData!.trandingProducts[index];
                            final name = product.title ?? '';
                            final image = product.image ?? '';
                            final price = product.price.toString();
                            final rating = product.avgRating.toString();
                            return ProductCard(
                              name: name,
                              image: image,
                              price: price,
                              rating: rating,
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
                      ),
                      SizedBox(height: 12.h(context)),
                      Text(
                        'Redeem and save',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 16.sp(context),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 8.h(context)),
                      VoucherCardHomeScreen(),
                      SizedBox(height: 16.h(context)),
                      CarouselBanner(
                        controller.homeData?.secondSectionBanner ?? [],
                        (reference) {
                          PageNavigationService.to(context, AppRoutes.shop);
                        },
                      ),
                      SizedBox(height: 12.h(context)),
                      ViewAllList(
                        title: 'AI Recommended for you',
                        onTap: () {
                          PageNavigationService.to(
                            context,
                            AppRoutes.allProduct,
                            arguments: {'title': 'AI Recommended for you'},
                          );
                        },
                      ),
                      SizedBox(height: 8.h(context)),
                      SizedBox(
                        height: 266.h(context),
                        child: ListView.separated(
                          itemCount:
                              controller
                                  .homeData
                                  ?.aiRecommandedProducts
                                  .length ??
                              0,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 14.w(context)),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final product = controller
                                .homeData!
                                .aiRecommandedProducts[index];
                            final name = product.title ?? '';
                            final image = product.image ?? '';
                            final price = product.price.toString();
                            final rating = product.avgRating.toString();
                            return ProductCard(
                              name: name,
                              image: image,
                              price: price,
                              rating: rating,
                              onTap: () {
                                PageNavigationService.to(
                                  context,
                                  AppRoutes.productDetails,
                                );
                              },
                              onTapFavourite: () {},
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 12.h(context)),
                    ],
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
