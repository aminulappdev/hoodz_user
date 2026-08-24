import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/circle_icon.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/cart_controller.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/order_summary_controller.dart';
import 'package:hoodz/features/user/orders/presentation/pages/check_out_screen.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/cart_item.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/cart_item_update_sheet.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/shiping_buttom_bar.dart';
import 'package:hoodz/features/user/product/presentation/widgets/product_card.dart';
import 'package:hoodz/gen/assets.gen.dart';

class CartScreen extends GetView<CartController> {
  const CartScreen({super.key});

  OrderSummaryController get _orderSummaryController =>
      Get.find<OrderSummaryController>();

  @override 
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 68.w(context),
        leading: Padding(
          padding: EdgeInsets.all(14.0.h(context)),
          child: CircleIcon(
            iconPath: Assets.icons.arrow.path,
            onTap: () => PageNavigationService.back(context),
          ),
        ),
        title: Text(
          'My Cart',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xff3F3F3F),
          ),
        ),
        actions: [
          // Action
          Obx(
            () => Padding(
              padding: EdgeInsets.only(right: 22.w(context)),
              child: Center(
                child: Text(
                  controller.itemLabel,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16.sp(context),
                    fontWeight: FontWeight.w500,
                    color: LightThemeColors.primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => ShipingButtomBar(
          subTotal: controller.subTotal,
          deliveryCharge: controller.deliveryCharge,
          total: controller.totalCost,
          buttonText: 'Checkout',
          onTap: () async {
            final isSuccess = await _orderSummaryController.createOrderSummary(
              voucherCode: null,
              redeemCoins: null,
              onSuccessNavigate: () {
                Get.to(() => const CheckoutScreen());
              },
            );

            if (!isSuccess) {
              return;
            }
          },
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.cartItems.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final cartItems = controller.cartItems.toList(growable: false);
        final visibleItemCount = cartItems.length >= 2 ? 2 : cartItems.length;
        final cartListHeight = visibleItemCount == 0
            ? 0.0
            : (136.h(context) * visibleItemCount) +
                  (18.h(context) * (visibleItemCount - 1));

        if (cartItems.isEmpty) {
          return const Center(child: Text('No cart items found'));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            20.w(context),
            8.h(context),
            20.w(context),
            220.h(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (cartItems.isNotEmpty)
                SizedBox(
                  height: cartListHeight,
                  child: ListView.separated(
                    itemCount: cartItems.length,
                    physics: cartItems.length > 2
                        ? const ClampingScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 18.h(context)),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return CartItemCard(
                        imageUrl: controller.cartItemImage(item),
                        name: controller.cartItemName(item),
                        size: controller.cartItemSize(item),
                        color: controller.cartItemColor(item),
                        price: controller.cartItemPrice(item),
                        quantity: item.quantity ?? 1,
                        onIncrease: () => controller.increaseQuantity(index),
                        onDecrease: () => controller.decreaseQuantity(index),
                        onEdit: () {
                          final productId =
                              item.productId ?? item.product?.id ?? '';
                          if (productId.isEmpty) {
                            return;
                          }

                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => CartItemUpdateSheet(
                              item: item,
                              controller: controller,
                            ),
                          );
                        },
                        onRemove: () => controller.removeItem(index),
                      );
                    },
                  ),
                ),
              SizedBox(height: 24.h(context)),
              Text(
                'Recommended for you',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 16.sp(context),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff434343),
                ),
              ),
              SizedBox(height: 14.h(context)),
              SizedBox(
                height: 260.h(context),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.recommendedItems.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(width: 12.w(context)),
                  itemBuilder: (context, index) {
                    final item = controller.recommendedItems[index];
                    return ProductCard(
                      name: controller.recommendedName(item),
                      image: controller.recommendedImage(item),
                      price: '\$${item.discountPrice ?? item.price ?? 0}',
                      rating: (item.avgRating ?? 0).toString(),
                      subtitle: item.collectionType ?? '',
                      oldPrice:
                          item.discountPrice != null &&
                              item.price != null &&
                              item.discountPrice != item.price
                          ? '\$${item.price}'
                          : '',
                      stockLabel: item.inStock == true
                          ? 'In Stock'
                          : 'Out of Stock',
                      onTap: () {
                        PageNavigationService.to(
                          context,
                          AppRoutes.productDetails,
                          arguments: {'productId': item.id},
                        );
                      },
                      onTapFavourite: () {},
                    );
                  },
                ),
              ),
              // SizedBox(height: 28.h(context)),
              // AddVoucherRow(onTap: () {}),
              // SizedBox(height: 12.h(context)),
              // VoucherCard(),
            ],
          ),
        );
      }),
    );
  }
}
