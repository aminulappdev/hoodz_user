import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/core/services/others/app_route_observer.dart';
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

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with RouteAware {
  late final CartController _controller;
  bool _isRouteSubscribed = false;
  OrderSummaryController get _orderSummaryController =>
      Get.find<OrderSummaryController>();

  @override
  void initState() {
    super.initState();
    _controller = Get.find<CartController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.getCartData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (!_isRouteSubscribed && route is PageRoute) {
      appRouteObserver.subscribe(this, route);
      _isRouteSubscribed = true;
    }
  }

  @override
  void dispose() {
    if (_isRouteSubscribed) {
      appRouteObserver.unsubscribe(this);
    }
    super.dispose();
  }

  @override
  void didPopNext() {
    _controller.getCartData();
  }

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
                  _controller.itemLabel,
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
          subTotal: _controller.subTotal,
          deliveryCharge: _controller.deliveryCharge,
          total: _controller.totalCost,
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
        if (_controller.isLoading.value && _controller.cartItems.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final cartItems = _controller.cartItems.toList(growable: false);
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
                        imageUrl: _controller.cartItemImage(item),
                        name: _controller.cartItemName(item),
                        size: _controller.cartItemSize(item),
                        color: _controller.cartItemColor(item),
                        price: _controller.cartItemPrice(item),
                        quantity: item.quantity ?? 1,
                        onIncrease: () => _controller.increaseQuantity(index),
                        onDecrease: () => _controller.decreaseQuantity(index),
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
                              controller: _controller,
                            ),
                          );
                        },
                        onRemove: () => _controller.removeItem(index),
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
                  itemCount: _controller.recommendedItems.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(width: 12.w(context)),
                  itemBuilder: (context, index) {
                    final item = _controller.recommendedItems[index];
                    return ProductCard(
                      name: _controller.recommendedName(item),
                      image: _controller.recommendedImage(item),
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
