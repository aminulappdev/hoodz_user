import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/circle_icon.dart';
import 'package:hoodz/core/widgets/shimmer/wishlist_shimmer_card.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/cart_controller.dart';
import 'package:hoodz/features/user/wishlist/presentation/controller/wishlist_controller.dart';
import 'package:hoodz/features/user/wishlist/presentation/widgets/wishlist_card.dart';
import 'package:hoodz/gen/assets.gen.dart';

class WishlistScreen extends GetView<WishlistController> {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?; 
    final isBack = arguments?['isBack'] == true;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: isBack,
       
        leading: isBack
            ? IconButton(
            padding: EdgeInsets.only(left: 10.w(context), right: 10.w(context)),
              onPressed: () => Navigator.pop(context),
              icon: CircleIcon(
                iconPath: Assets.icons.arrow.path,
                size: 16,
                iconSize: 10,
              ),
            )
            : null,
        title: Text(
          Strings.wishlistTitle.tr,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return ListView.separated(
            padding: EdgeInsets.fromLTRB(
              20.w(context),
              8.h(context),
              20.w(context),
              24.h(context),
            ),
            itemCount: 5,
            separatorBuilder: (context, index) =>
                SizedBox(height: 8.h(context)),
            itemBuilder: (context, index) {
              return const WishlistShimmerCard();
            },
          );
        }

        if (controller.items.isEmpty) {
          return Center(child: Text(Strings.noWishlistItemsFound.tr));
        }

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w(context),
            vertical: 0.h(context),
          ),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) =>
                SizedBox(height: 8.h(context)),
            itemCount: controller.items.length,
            itemBuilder: (context, index) {
              final item = controller.items[index];
              final product = item.product;

              return WishListCard(
                imageUrl: product?.banner ?? '',
                name: product?.title ?? Strings.unnamedProduct.tr,
                price: '\$${product?.discountPrice ?? product?.price ?? 0}',
                onTap: () async {
                  final productId = product?.id;
                  if (productId == null || productId.isEmpty) {
                    return;
                  }

                  final firstVariant = product?.variants.isNotEmpty == true
                      ? product!.variants.first
                      : null;
                  final variantColor = firstVariant?.color;
                  final colorPayload = variantColor == null
                      ? null
                      : {
                          'code': variantColor.code ?? '',
                          'name': variantColor.name ?? '',
                        };

                  final isAdded = await cartController.addToCart(
                    productId: productId,
                    size: firstVariant?.size,
                    color: colorPayload,
                    quantity: 1,
                    includeVariantFields: true,
                  );

                  if (!isAdded) {
                    return;
                  }

                  final wishlistItemId = item.id;
                  if (wishlistItemId == null || wishlistItemId.isEmpty) {
                    return;
                  }

                  await controller.deleteWishlistItem(wishlistItemId);
                },
                onTapDelete: () {
                  final wishlistItemId = item.id;
                  if (wishlistItemId == null || wishlistItemId.isEmpty) {
                    return;
                  }

                  controller.deleteWishlistItem(wishlistItemId);
                },
              );
            },
          ),
        );
      }),
    );
  }
}
