import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/shimmer/shop_product_shimmer.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/all_product_info_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/brand_product_card.dart';
import 'package:hoodz/features/user/product/presentation/controller/all_product_filter_bottom_sheet.dart';
import 'package:hoodz/features/user/product/presentation/widgets/all_product_header.dart';
import 'package:hoodz/features/user/product/presentation/widgets/product_card.dart';
import 'package:hoodz/features/user/wishlist/presentation/controller/wishlist_controller.dart';

class ShopProductScreen extends GetView<AllProductInfoController> {
  const ShopProductScreen({super.key});

  @override 
   Widget build(BuildContext context) {
    final wishlistController = Get.find<WishlistController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        final recommends = controller.recommendedProducts;
        final allProducts = controller.products;
        final isLoading = controller.isLoading.value;
        final hasData = recommends.isNotEmpty || allProducts.isNotEmpty;

        return Column(
          children: [
            AllProductHeader(
              title: controller.title.value,
              onTapBack: () => Navigator.pop(context),
              onTapFilter: () {
                controller.syncDraftWithApplied();
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) =>
                      AllProductFilterBottomSheet(controller: controller),
                );
              },
              isFilter: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  20.w(context),
                  16.h(context),
                  20.w(context),
                  24.h(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(
                      title: Strings.recommendation.tr,
                      onTapViewAll: null,
                    ),
                    SizedBox(height: 12.h(context)),
                    if (isLoading && recommends.isEmpty)
                      const ShopProductRecommendationShimmer()
                    else if (recommends.isEmpty)
                      _EmptyState(
                        text: Strings.noRecommendationFound.tr,
                        height: 170.h(context),
                      )
                    else
                      SizedBox(
                        height: 270.h(context),
                        
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemCount: recommends.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(width: 12.w(context)),
                          itemBuilder: (context, index) {
                            final product = recommends[index];
                            final isWishlisted = product.isWishlisted ?? false;
                            return ProductCard(
                              name: product.title ?? '',
                              image: product.banner ?? '',
                              price: _formatPrice(
                                product.discountPrice ?? product.price,
                              ),
                              rating: _formatRating(product.avgRating),
                              subtitle:
                                  product.brand ??
                                  product.collectionType ??
                                  '',
                              oldPrice: _oldPriceText(
                                product.price,
                                product.discountPrice,
                              ),
                              stockLabel: product.inStock == true
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

                                final updatedValue = await wishlistController
                                    .toggleProductWishlist(
                                      productId: productId,
                                      currentValue: isWishlisted,
                                    );

                                if (updatedValue != null) {
                                  controller.updateWishlistStatus(
                                    productId: productId,
                                    isWishlisted: updatedValue,
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    SizedBox(height: 18.h(context)),
                    _SectionTitle(
                      title: Strings.allProducts.tr,
                      onTapViewAll: null,
                    ),
                    SizedBox(height: 12.h(context)),
                    if (isLoading && allProducts.isEmpty)
                      const ShopProductGridShimmer()
                    else if (allProducts.isEmpty)
                      _EmptyState(
                        text: Strings.noProductFound.tr,
                        height: 220.h(context),
                      )
                    else
                      GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: allProducts.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w(context),
                          mainAxisSpacing: 12.h(context),
                          childAspectRatio: 0.68,
                        ),
                        itemBuilder: (context, index) {
                          final product = allProducts[index];
                          final isWishlisted = product.isWishlisted ?? false;
                          return BrandProductCard(
                            name: product.title ?? '',
                            subtitle:
                                product.collectionType ??
                                product.brand ??
                                controller.title.value,
                            image: product.banner ?? '',
                            price: _formatPrice(
                              product.discountPrice ?? product.price,
                            ),
                            oldPrice: _oldPriceText(
                              product.price,
                              product.discountPrice,
                            ),
                            rating: _formatRating(product.avgRating),
                            stockLabel: product.inStock == true
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

                              final updatedValue = await wishlistController
                                  .toggleProductWishlist(
                                    productId: productId,
                                    currentValue: isWishlisted,
                                  );

                              if (updatedValue != null) {
                                controller.updateWishlistStatus(
                                  productId: productId,
                                  isWishlisted: updatedValue,
                                );
                              }
                            },
                          );
                        },
                      ),
                    if (!hasData && !isLoading)
                      SizedBox(height: 8.h(context)),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  String _formatPrice(dynamic value) {
    final numeric = _toDouble(value);
    if (numeric == null) {
      return '';
    }
    if (numeric % 1 == 0) {
      return '\$${numeric.toInt()}';
    }
    return '\$${numeric.toStringAsFixed(2)}';
  }

  String _oldPriceText(dynamic price, dynamic discountPrice) {
    final priceValue = _toDouble(price);
    final discountValue = _toDouble(discountPrice);

    if (priceValue == null || discountValue == null) {
      return '';
    }

    if (priceValue == discountValue) {
      return '';
    }

    if (priceValue % 1 == 0) {
      return '\$${priceValue.toInt()}';
    }
    return '\$${priceValue.toStringAsFixed(2)}';
  }

  String _formatRating(dynamic value) {
    final numeric = _toDouble(value);
    if (numeric == null) {
      return '0.0';
    }
    return numeric.toStringAsFixed(1);
  }

  double? _toDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.onTapViewAll});

  final String title;
  final VoidCallback? onTapViewAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 18.sp(context),
            fontWeight: FontWeight.w800,
            color: const Color(0xFF2D2D2D),
          ),
        ),
        const Spacer(),
        if (onTapViewAll != null)
          GestureDetector(
            onTap: onTapViewAll,
            child: Text(
              Strings.viewAll.tr,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 13.sp(context),
                fontWeight: FontWeight.w500,
                color: const Color(0xFFFF6A00),
              ),
            ),
          ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.text, required this.height});

  final String text;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(14.r(context)),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Text(text),
    );
  }
}
