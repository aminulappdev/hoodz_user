import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/utils/login_required_dialog.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/banner_card.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/brand_product_card.dart';
import 'package:hoodz/features/user/shop/presentation/controller/shop_details_controller.dart';
import 'package:hoodz/features/user/shop/presentation/controller/shop_product_controller.dart';
import 'package:hoodz/features/user/shop/presentation/controller/sho_connection_controoler.dart';
import 'package:hoodz/features/user/shop/presentation/widgets/shop_availability_card.dart';
import 'package:hoodz/features/user/shop/presentation/widgets/shop_category_tab_bar.dart';
import 'package:hoodz/features/user/shop/presentation/widgets/shop_header_section.dart';
import 'package:hoodz/features/user/wishlist/presentation/controller/wishlist_controller.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key}); 

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late final ShopDetailsController _shopDetailsController;
  late final ShopProductController _shopProductController;
  late final ShoConnectionControoler _connectionController;
  String? _lastLoadedShopId;

  @override
  void initState() {
    super.initState();
    _shopDetailsController = Get.find<ShopDetailsController>();
    _shopProductController = Get.find<ShopProductController>();
    _connectionController = Get.find<ShoConnectionControoler>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadShopIfNeeded();
  }

  void _loadShopIfNeeded() {
    final routeArguments = Get.arguments is Map<String, dynamic>
        ? Get.arguments as Map<String, dynamic>
        : null;
    final rawShopId = routeArguments?['shopId'] ?? routeArguments?['reference'];
    final shopId = _extractShopId(rawShopId);

    if (shopId == null || shopId.isEmpty) {
      return;
    }

    if (_lastLoadedShopId == shopId) {
      return;
    }

    _lastLoadedShopId = shopId;
    _shopDetailsController.initialize(routeArguments, forceRefresh: true);
    _shopProductController.initialize(routeArguments, forceRefresh: true);
  }

  String? _extractShopId(dynamic rawValue) {
    if (rawValue is! String || rawValue.isEmpty) {
      return null;
    }

    final value = rawValue.trim();
    if (value.startsWith('http://') || value.startsWith('https://')) {
      final uri = Uri.tryParse(value);
      final segments = uri?.pathSegments.where((segment) => segment.isNotEmpty);
      if (segments == null || segments.isEmpty) {
        return null;
      }
      return segments.last;
    }

    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Obx(() {
        final shop = _shopDetailsController.shopData?.shop;
        final featuredProducts = _shopProductController.recommendedProducts;
        final allProducts = _shopProductController.allProducts;
        final isProductsLoading =
            _shopProductController.isProductsLoading.value;
        final isFollowing = _connectionController.isFollowing.value;
        final isFollowLoading = _connectionController.isLoading.value;
        final shopId = _shopDetailsController.shopIdData.value.trim().isNotEmpty
            ? _shopDetailsController.shopIdData.value.trim()
            : (shop?.shopId ?? '').trim();
        final isWishlisted = shop?.isWishlisted ?? false;

        if (_shopDetailsController.isLoading.value && shop == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (shop == null) {
          return Center(child: Text(Strings.noShopDetailsFound.tr));
        }

        _connectionController.bindShop(
          shopId: _shopDetailsController.shopIdData.value,
          initialFollowing: shop.isFollowing ?? false,
        );

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShopHeader(
                coverImageUrl: _shopDetailsController.shopCoverPhoto,
                profileImageUrl: _shopDetailsController.shopProfileAvatar,
                shopName: _shopDetailsController.shopName,
                distance: _shopDetailsController.distanceText,
                deliveryTime: _shopDetailsController.deliveryTimeText,
                rating: _shopDetailsController.ratingText,
                likes: shop.ratingCount?.toString() ?? '0',
                followers: _shopDetailsController.followersText,
                description: _shopDetailsController.shopDescription,
                categories: _shopDetailsController.categories.toList(),
                isFollowing: isFollowing,
                isFollowLoading: isFollowLoading,
                onTapFollow: () {
                  if (!_hasAccessToken()) {
                    showLoginRequiredDialog();
                    return;
                  }

                  _connectionController.toggleFollow();
                },
                onTapFavourite: () async {
                  if (shopId.isEmpty) {
                    return;
                  }

                  if (!_hasAccessToken()) {
                    showLoginRequiredDialog();
                    return;
                  }

                  await Get.find<WishlistController>().toggleProductWishlist(
                    productId: shopId,
                    currentValue: isWishlisted,
                    modelType: 'shop',
                  );
                },
                isWishlisted: isWishlisted,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w(context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShopAvailabilityCard(
                      policies: _shopDetailsController.shopData?.policies,
                    ),
                    SizedBox(height: 20.h(context)),
                    Text(
                      Strings.highRecommended.tr,
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
                          ? Center(child: Text(Strings.noProductFound.tr))
                          : ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: featuredProducts.length,
                              separatorBuilder: (_, _) =>
                                  SizedBox(width: 12.w(context)),
                              itemBuilder: (context, index) {
                                final product = featuredProducts[index];
                                return ShopCard(
                                  image: product.banner ?? '',
                                  name: product.title ?? '',
                                  rating: product.avgRating?.toString() ?? '0',
                                  distance: _shopDetailsController.distanceText,
                                  time: _shopDetailsController.deliveryTimeText,
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
                      categories: _shopDetailsController.categories,
                      selectedCategory:
                          _shopProductController.selectedCategory.value,
                      onTapAll: _shopProductController.clearCategory,
                      onTapCategory: _shopProductController.selectCategory,
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
                            child: Text(Strings.noProductFound.tr),
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
                              final isWishlisted =
                                  product.isWishlisted ?? false;
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
                                    _shopDetailsController.shopName,
                                image: product.banner ?? '',
                                price: '\$$priceValue',
                                oldPrice: oldPriceValue,
                                rating: product.avgRating?.toString() ?? '0',
                                stockLabel: inStock
                                    ? Strings.inStock.tr
                                    : Strings.outOfStock.tr,
                                isWishlisted: isWishlisted,
                                onTap: () {
                                  PageNavigationService.to(
                                    context,
                                    AppRoutes.productDetails,
                                    arguments: {'productId': product.id},
                                  );
                                },
                                onTapFavourite: () async {
                                  final productId = product.id;
                                  if (productId == null || productId.isEmpty) {
                                    return;
                                  }

                                  if (!_hasAccessToken()) {
                                    showLoginRequiredDialog();
                                    return;
                                  }

                                  final updatedValue =
                                      await Get.find<WishlistController>()
                                          .toggleProductWishlist(
                                        productId: productId,
                                        currentValue: isWishlisted,
                                      );

                                  if (updatedValue != null) {
                                    _shopProductController.updateWishlistStatus(
                                      productId: productId,
                                      isWishlisted: updatedValue,
                                    );
                                  }
                                },
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

  bool _hasAccessToken() =>
      MySharedPref.getAccessToken()?.trim().isNotEmpty == true;
}
