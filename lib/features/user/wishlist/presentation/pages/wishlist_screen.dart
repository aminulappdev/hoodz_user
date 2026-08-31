import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
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
        leadingWidth: isBack ? 46.w(context) : null,
        leading: isBack
            ? Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => PageNavigationService.back(context),
                  child: SizedBox(
                    height: 32.h(context),
                    width: 32.w(context),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xffEDF1F3)),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CrashSafeImage(
                          Assets.icons.arrow.path,
                          height: 16.h(context),
                          width: 16.w(context),
                          color: const Color(0xff404040),
                        ),
                      ),
                    ),
                  ),
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

                  final isAdded = await cartController.addToCart(
                    productId: productId,
                    quantity: 1,
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
