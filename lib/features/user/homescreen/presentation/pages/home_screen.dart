import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/utils/login_required_dialog.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/home_screen_controller.dart';
import 'package:hoodz/features/user/homescreen/data/models/home_data_model.dart';
import 'package:hoodz/features/user/homescreen/presentation/pages/carousel_banner.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/home_page_header.dart';
import 'package:hoodz/features/user/product/presentation/widgets/product_card.dart';
import 'package:hoodz/features/user/product/presentation/widgets/product_list.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/view_all.dart';
import 'package:hoodz/features/user/wishlist/presentation/controller/wishlist_controller.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({super.key});

  bool _hasAccessToken() =>
      MySharedPref.getAccessToken()?.trim().isNotEmpty == true;

  Widget _buildSectionTitleSkeleton(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE7E7E7),
      highlightColor: const Color(0xFFF8F8F8),
      child: Container(
        height: 18.h(context),
        width: 120.w(context),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r(context)),
        ),
      ),
    );
  }

  Widget _buildBannerSkeleton(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE7E7E7),
      highlightColor: const Color(0xFFF8F8F8),
      child: Container(
        height: 140.h(context),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r(context)),
        ),
      ),
    );
  }

  Widget _buildBrandSkeleton(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE7E7E7),
      highlightColor: const Color(0xFFF8F8F8),
      child: Container(
        width: 92.w(context),
        padding: EdgeInsets.all(10.w(context)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r(context)),
          border: Border.all(color: const Color(0xFFF1F1F1)),
        ),
        child: Column(
          children: [
            Container(
              height: 36.w(context),
              width: 36.w(context),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 10.h(context)),
            Container(
              height: 12.h(context),
              width: 56.w(context),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.r(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductSkeleton(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE7E7E7),
      highlightColor: const Color(0xFFF8F8F8),
      child: Container(
        width: 180.w(context),
        padding: EdgeInsets.all(10.w(context)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r(context)),
          border: Border.all(color: const Color(0xFFF1F1F1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r(context)),
                ),
              ),
            ),
            SizedBox(height: 12.h(context)),
            Container(
              height: 14.h(context),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.r(context)),
              ),
            ),
            SizedBox(height: 8.h(context)),
            Container(
              height: 12.h(context),
              width: 90.w(context),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.r(context)),
              ),
            ),
            SizedBox(height: 12.h(context)),
            Container(
              height: 18.h(context),
              width: 70.w(context),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.r(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Obx(() {
      final homeData = controller.homeData;
      final categories = controller.categoryList;
      final nearbyBrands = homeData?.nearbyBrands ?? const [];
      final recentlyViewed = homeData?.recentlyViwed ?? const [];
      final trendingProducts = homeData?.trandingProducts ?? const [];
      final aiRecommendedProducts = homeData?.aiRecommandedProducts ?? const [];
      final showInitialLoaders = controller.isLoading.value && homeData == null;
      final showRecentlyViewedSection =
          showInitialLoaders || recentlyViewed.isNotEmpty;

      return Scaffold(
        body: SizedBox(
          height: height,
          width: width,
          child: Column(
            children: [
              CustomHomePageAppBar(
                address:
                    homeData?.profile?.deliveryAddress?.name?.isNotEmpty == true
                    ? homeData!.profile!.deliveryAddress!.name!
                    : Strings.noAddressAdded.tr,
                notificationCount: controller.notificationCount.value,
                onTapEdit: () {
                  if (!_hasAccessToken()) {
                    showLoginRequiredDialog();
                    return;
                  }

                  PageNavigationService.to(
                    context,
                    AppRoutes.shippingInformation,
                  );
                },
                onTapNotification: () {
                  if (!_hasAccessToken()) {
                    showLoginRequiredDialog();
                    return;
                  }

                  PageNavigationService.to(context, AppRoutes.cart);
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
                      categories.isEmpty
                          ? Container(
                              height: 90.h(context),
                              alignment: Alignment.center,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Text(Strings.noCategoryFound.tr),
                              ),
                            )
                          : SizedBox(
                              height: 90.h(context),
                              width: double.infinity,
                              child: ListView.separated(
                                itemCount: categories.length,
                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: 14.w(context)),
                                itemBuilder: (context, index) {
                                  final category = categories[index];
                                  final brandType = _resolveBrandType(
                                    category['name'] ?? '',
                                  );
                                  return BrandList(
                                    image: category['image'] ?? "",
                                    name:
                                        (category['nameKey'] ??
                                                category['name'] ??
                                                '')
                                            .tr,
                                    onTap: () {
                                      PageNavigationService.to(
                                        context,
                                        AppRoutes.allBrand,
                                        arguments: {
                                          "title": category["name"],
                                          "image": category["image"],
                                          "brandType": brandType,
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                      if (showInitialLoaders) ...[
                        _buildSectionTitleSkeleton(context),
                        SizedBox(height: 12.h(context)),
                        _buildBannerSkeleton(context),
                        SizedBox(height: 16.h(context)),
                      ] else if ((homeData?.firstSectionBanner ?? const [])
                          .isNotEmpty) ...[
                        CarouselBanner(
                          homeData?.firstSectionBanner ?? const [],
                          (banner) => _handleBannerTap(context, banner),
                        ),
                        SizedBox(height: 12.h(context)),
                      ],
                      showInitialLoaders
                          ? _buildSectionTitleSkeleton(context)
                          : Text(
                              Strings.nearbyBrands.tr,
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(
                                    fontSize: 16.sp(context),
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                      SizedBox(height: 8.h(context)),
                      SizedBox(
                        height: 100.h(context),
                        child: showInitialLoaders
                            ? ListView.separated(
                                itemCount: 3,
                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: 14.w(context)),
                                itemBuilder: (context, index) {
                                  return _buildBrandSkeleton(context);
                                },
                              )
                            : nearbyBrands.isEmpty
                            ? Center(child: Text(Strings.noNearbyBrands.tr))
                            : ListView.separated(
                                itemCount: nearbyBrands.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: 14.w(context)),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final brand = nearbyBrands[index];
                                  return GestureDetector(
                                    onTap: () {
                                      PageNavigationService.to(
                                        context,
                                        AppRoutes.shop,
                                        arguments: {'shopId': brand.id},
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 36.r(context),
                                      backgroundImage: NetworkImage(
                                        brand.profileAvatar ?? "",
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      if (showRecentlyViewedSection) ...[
                        SizedBox(height: 12.h(context)),
                        showInitialLoaders
                            ? _buildSectionTitleSkeleton(context)
                            : Text(
                                Strings.recentlyViewed.tr,
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      fontSize: 16.sp(context),
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                        SizedBox(height: 8.h(context)),
                        showInitialLoaders
                            ? SizedBox(
                                height: 266.h(context),
                                child: ListView.separated(
                                  itemCount: 2,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(width: 14.w(context)),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return _buildProductSkeleton(context);
                                  },
                                ),
                              )
                            : SizedBox(
                                height: 266.h(context),
                                child: ListView.separated(
                                  itemCount: recentlyViewed.length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(width: 14.w(context)),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final product = recentlyViewed[index];
                                    final name = product.title ?? "";
                                    final image =
                                        product.banner ?? product.image ?? "";
                                    final price = "${product.price ?? ''}";
                                    final rating = "${product.avgRating ?? ''}";
                                    final isWishlisted =
                                        product.isWishlisted ?? false;
                                    return ProductCard(
                                      name: name,
                                      image: image,
                                      price: price,
                                      rating: rating,
                                      productId: product.id,
                                      isWishlisted: isWishlisted,
                                      onTap: () {
                                        PageNavigationService.to(
                                          context,
                                          AppRoutes.productDetails,
                                          arguments: {'productId': product.id},
                                        );
                                      },
                                      onTapFavourite: () {
                                        final productId = product.id;
                                        if (productId == null ||
                                            productId.isEmpty) {
                                          return;
                                        }

                                        if (!_hasAccessToken()) {
                                          showLoginRequiredDialog();
                                          return;
                                        }

                                        Get.find<WishlistController>()
                                            .toggleProductWishlist(
                                              productId: productId,
                                              currentValue: isWishlisted,
                                            );
                                      },
                                    );
                                  },
                                ),
                              ),
                      ],
                      SizedBox(height: 12.h(context)),
                      showInitialLoaders
                          ? _buildSectionTitleSkeleton(context)
                          : ViewAllList(
                              title: Strings.trendingNow.tr,
                              onTap: () {
                                PageNavigationService.to(
                                  context,
                                  AppRoutes.allProduct,
                                  arguments: {
                                    'title': Strings.trendingNow.tr,
                                    'source': 'trending',
                                  },
                                );
                              },
                            ),
                      SizedBox(height: 8.h(context)),
                      SizedBox(
                        height: 266.h(context),
                        child: showInitialLoaders
                            ? ListView.separated(
                                itemCount: 2,
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: 14.w(context)),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return _buildProductSkeleton(context);
                                },
                              )
                            : trendingProducts.isEmpty
                            ? Center(child: Text(Strings.noTrendingProducts.tr))
                            : ListView.separated(
                                itemCount: trendingProducts.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: 14.w(context)),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final product = trendingProducts[index];
                                  final name = product.title ?? '';
                                  final image = product.image ?? '';
                                  final price = product.price.toString();
                                  final rating = product.avgRating.toString();
                                  final isWishlisted =
                                      product.isWishlisted ?? false;
                                  return ProductCard(
                                    name: name,
                                    image: image,
                                    price: price,
                                    rating: rating,
                                    isWishlisted: isWishlisted,
                                    onTap: () {
                                      PageNavigationService.to(
                                        context,
                                        AppRoutes.productDetails,
                                        arguments: {'productId': product.id},
                                      );
                                    },
                                    onTapFavourite: () {
                                      final productId = product.id;
                                      if (productId == null ||
                                          productId.isEmpty) {
                                        return;
                                      }

                                      if (!_hasAccessToken()) {
                                        showLoginRequiredDialog();
                                        return;
                                      }

                                      Get.find<WishlistController>()
                                          .toggleProductWishlist(
                                            productId: productId,
                                            currentValue: isWishlisted,
                                          );
                                    },
                                  );
                                },
                              ),
                      ),
                      SizedBox(height: 12.h(context)),
                      // Text(
                      //   'Redeem and save',
                      //   style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      //     fontSize: 16.sp(context),
                      //     fontWeight: FontWeight.w800,
                      //   ),
                      // ),
                      // SizedBox(height: 8.h(context)),
                      // VoucherCardHomeScreen(),
                      // SizedBox(height: 16.h(context)),
                      if (showInitialLoaders) ...[
                        _buildBannerSkeleton(context),
                        SizedBox(height: 12.h(context)),
                      ] else if ((homeData?.secondSectionBanner ?? const [])
                          .isNotEmpty) ...[
                        CarouselBanner(
                          homeData?.secondSectionBanner ?? const [],
                          (banner) => _handleBannerTap(context, banner),
                        ),
                        SizedBox(height: 12.h(context)),
                      ],
                      showInitialLoaders
                          ? _buildSectionTitleSkeleton(context)
                          : ViewAllList(
                              title: Strings.aiRecommendedForYou.tr,
                              onTap: () {
                                PageNavigationService.to(
                                  context,
                                  AppRoutes.allProduct,
                                  arguments: {
                                    'title': Strings.aiRecommendedForYou.tr,
                                    'source': 'ai',
                                  },
                                );
                              },
                            ),
                      SizedBox(height: 8.h(context)),
                      SizedBox(
                        height: 266.h(context),
                        child: showInitialLoaders
                            ? ListView.separated(
                                itemCount: 2,
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: 14.w(context)),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return _buildProductSkeleton(context);
                                },
                              )
                            : aiRecommendedProducts.isEmpty
                            ? Center(
                                child: Text(Strings.noRecommendedProducts.tr),
                              )
                            : ListView.separated(
                                itemCount: aiRecommendedProducts.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: 14.w(context)),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final product = aiRecommendedProducts[index];
                                  final name = product.title ?? '';
                                  final image = product.image ?? '';
                                  final price = product.price.toString();
                                  final rating = product.avgRating.toString();
                                  final isWishlisted =
                                      product.isWishlisted ?? false;
                                  return ProductCard(
                                    name: name,
                                    image: image,
                                    price: price,
                                    rating: rating,
                                    productId: product.id,
                                    isWishlisted: isWishlisted,
                                    onTap: () {
                                      PageNavigationService.to(
                                        context,
                                        AppRoutes.productDetails,
                                        arguments: {'productId': product.id},
                                      );
                                    },
                                    onTapFavourite: () {
                                      final productId = product.id;
                                      if (productId == null ||
                                          productId.isEmpty) {
                                        return;
                                      }

                                      if (!_hasAccessToken()) {
                                        showLoginRequiredDialog();
                                        return;
                                      }

                                      Get.find<WishlistController>()
                                          .toggleProductWishlist(
                                            productId: productId,
                                            currentValue: isWishlisted,
                                          );
                                    },
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
      );
    });
  }

  String _resolveBrandType(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized.contains('international')) {
      return 'international';
    }
    if (normalized.contains('trend')) {
      return 'trending';
    }
    if (normalized.contains('new')) {
      return 'new';
    }
    return 'local';
  }

  void _handleBannerTap(BuildContext context, SectionBanner banner) {
    final reference = banner.reference?.trim() ?? '';
    final type = banner.type?.trim().toLowerCase() ?? '';

    if (reference.isEmpty) {
      debugPrint('BANNER TAP: reference is empty for type=$type');
      return;
    }

    switch (type) {
      case 'shop':
        PageNavigationService.to(
          context,
          AppRoutes.shop,
          arguments: {'shopId': reference},
        );
        break;
      case 'product':
        PageNavigationService.to(
          context,
          AppRoutes.productDetails,
          arguments: {'productId': reference},
        );
        break;
      case 'campain':
      case 'campaign':
        PageNavigationService.to(
          context,
          AppRoutes.campaign,
          arguments: {'reference': reference, 'banner': banner.banner ?? ''},
        );
        break;
      default:
        debugPrint('UNKNOWN BANNER TYPE: type=$type, reference=$reference');
    }
  }
}
