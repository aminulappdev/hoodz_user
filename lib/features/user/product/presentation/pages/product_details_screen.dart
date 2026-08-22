import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/app_cached_network_image.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/core/widgets/label_container.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/product_details_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/view_all.dart';
import 'package:hoodz/features/user/payment/presentation/models/voucher_model.dart';
import 'package:hoodz/features/user/payment/presentation/pages/voucher_screen.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/voucher_card_design.dart';
import 'package:hoodz/features/user/product/data/models/feedback_model.dart';
import 'package:hoodz/features/user/product/presentation/widgets/feedback_section.dart';
import 'package:hoodz/features/user/product/presentation/widgets/product_card.dart';
import 'package:hoodz/features/user/orders/presentation/pages/check_out_screen.dart';
import 'package:hoodz/features/user/product/presentation/widgets/card_buy_button.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/color_plate.dart';
import 'package:hoodz/features/user/product/presentation/widgets/product_policy_section.dart';
import 'package:hoodz/features/user/product/presentation/widgets/product_info.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/size_plate.dart';
import 'package:hoodz/gen/assets.gen.dart';

class ProductDetailsScreen extends GetView<ProductDetailsController> {
  const ProductDetailsScreen({super.key});

  Color? _parseColor(dynamic value) {
    if (value is Color) {
      return value;
    }

    if (value is int) {
      return Color(value);
    }

    if (value is String) {
      var hex = value.trim().replaceAll('#', '');
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      if (hex.length == 8) {
        final parsed = int.tryParse(hex, radix: 16);
        if (parsed != null) {
          return Color(parsed);
        }
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final routeArguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    controller.initialize(routeArguments);

    return Scaffold(
      appBar: CustomAppBar(label: 'Product Details'),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20.w(context)),
        child: CartAndBuy(
          onTapAddToCart: () {},
          onTapBuyNow: () {
            Get.to(() => CheckoutScreen());
          },
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final productData = controller.productData;
        final product = productData?.product;
        final vendor = productData?.vendor;
        final category = productData?.category;
        final similarProducts = productData?.similarProducts ?? const [];
        final vouchers = productData?.vouchers ?? const [];
        final reviews = productData?.reviews ?? const [];
        final sizeOptions =
            product?.sizes
                .map((size) => size.toString())
                .where((size) => size.trim().isNotEmpty)
                .toList() ??
            [];
        final colorOptions =
            product?.colors.map(_parseColor).whereType<Color>().toList() ?? [];
        final displayPrice = (product?.discountPrice ?? product?.price ?? 0)
            .toString();
        final displayRating = (product?.avgRating ?? 0).toString();
        final displayReviewCount = (product?.ratingCount ?? 0).toString();
        final productImage = product?.images.isNotEmpty == true
            ? product!.images.first
            : '';
        final displayStoreImage =
            vendor?.profileAvatar ?? product?.banner ?? productImage;

        return SizedBox(
          height: height,
          width: width,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= PRODUCT IMAGE =================
                if (product == null || product.images.isEmpty)
                  SizedBox(
                    height: 200.h(context),
                    width: width,
                    child: const Center(child: Text('No image found')),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppCachedNetworkImage(
                        imageUrl: product.images.first,
                        imageWidth: width,
                        imageHeight: 200.h(context),
                        imageFit: BoxFit.cover,
                        radius: 12.r(context),
                      ),

                      SizedBox(height: 8.h(context)),

                      SizedBox(
                        height: 100.h(context),
                        width: width,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: product.images.length,
                          itemBuilder: (context, index) {
                            return AppCachedNetworkImage(
                              imageUrl: product.images[index],
                              imageHeight: 100.h(context),
                              imageWidth: 100.w(context),
                              imageFit: BoxFit.cover,
                              radius: 12.r(context),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(width: 10.w(context));
                          },
                        ),
                      ),
                    ],
                  ),

                SizedBox(height: 18.h(context)),

                // ================= PRODUCT INFO =================
                ProductInfo(
                  price: displayPrice,
                  rating: displayRating,
                  review: displayReviewCount,
                  storeName: vendor?.name ?? product?.brand ?? '',
                  storeCategory:
                      category?.title ?? product?.collectionType ?? '',
                  storeImageUrl: displayStoreImage,
                  isInStock: true,
                ),

                SizedBox(height: 10.h(context)),

                if (sizeOptions.isNotEmpty) ...[
                  Text(
                    'Select Size',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16.sp(context),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff4A4A4A),
                    ),
                  ),

                  SizedBox(height: 8.h(context)),

                  Obx(
                    () => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: sizeOptions.map((size) {
                          final bool isSelected =
                              controller.selectedSize.value == size;

                          return Padding(
                            padding: EdgeInsets.only(right: 12.w(context)),
                            child: GestureDetector(
                              onTap: () {
                                controller.onSizeSelected(size);
                              },
                              child: SizePlate(
                                size: size,
                                backgroundColor: isSelected
                                    ? LightThemeColors.primaryColor
                                    : Colors.white,
                                textColor: isSelected
                                    ? Colors.white
                                    : const Color(0xff5E5E5E),
                                borderColor: isSelected
                                    ? LightThemeColors.primaryColor
                                    : const Color(0xffE6EAF0),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h(context)),
                ] else ...[
                  Container(
                    height: 60.h(context),
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r(context)),
                      border: Border.all(color: const Color(0xFFE7E7E7)),
                    ),
                    child: const Center(child: Text('No size available')),
                  ),

                  SizedBox(height: 20.h(context)),
                ],

                if (colorOptions.isNotEmpty) ...[
                  Text(
                    'Select color',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16.sp(context),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff4A4A4A),
                    ),
                  ),

                  SizedBox(height: 8.h(context)),

                  Obx(
                    () => Row(
                      children: List.generate(colorOptions.length, (index) {
                        final bool isSelected =
                            controller.selectedColorIndex.value == index;

                        return Padding(
                          padding: EdgeInsets.only(right: 14.w(context)),
                          child: GestureDetector(
                            onTap: () {
                              controller.onColorSelected(index);
                            },
                            child: ColorPlate(
                              color: colorOptions[index],
                              borderColor: isSelected
                                  ? LightThemeColors.primaryColor
                                  : Colors.transparent,
                              padding: isSelected ? 2.w(context) : 0,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  SizedBox(height: 16.h(context)),
                ] else ...[
                  Container(
                    height: 60.h(context),
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r(context)),
                      border: Border.all(color: const Color(0xFFE7E7E7)),
                    ),
                    child: const Center(child: Text('No color available')),
                  ),

                  SizedBox(height: 16.h(context)),
                ],

                // ================= DESCRIPTION =================
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16.sp(context),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff4A4A4A),
                  ),
                ),

                SizedBox(height: 10.h(context)),
                SizedBox(
                  width: width,
                  child: Html(
                    data: product?.description ?? 'No description found',
                  ),
                ),

                // Text(
                //   product?.description ?? '',
                //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                //     fontSize: 14.sp(context),
                //     height: 1.7,
                //     fontWeight: FontWeight.w400,
                //     color: const Color(0xff7B7B7B),
                //   ),
                //   textAlign: TextAlign.justify,
                // ),
                SizedBox(height: 8.h(context)),

                const Divider(color: Color(0xffEAEAEA)),

                SizedBox(height: 10.h(context)),

                // ================= POLICY =================
                ProductPolicySection(),

                SizedBox(height: 28.h(context)),

                // ================= COMPLETE YOUR LOOK =================
                Row(
                  children: [
                    Text(
                      'Complete your look',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16.sp(context),
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Inter',
                        color: const Color(0xff4A4A4A),
                      ),
                    ),

                    const Spacer(),

                    LabelContainer(
                      icon: Assets.icons.ai.path,
                      name: 'Ai Suggested',
                      contentColor: const Color(0xff039855),
                      backgroundColor: const Color(0xff039855),
                    ),
                  ],
                ),

                SizedBox(height: 8.h(context)),

                SizedBox(
                  height: 266.h(context),
                  child: similarProducts.isEmpty
                      ? const Center(child: Text('No similar products'))
                      : ListView.separated(
                          itemCount: similarProducts.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(width: 14.w(context));
                          },
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final similarProduct = similarProducts[index];
                            final name = similarProduct.title ?? '';
                            final image = similarProduct.banner ?? '';
                            final price =
                                (similarProduct.discountPrice ??
                                        similarProduct.price ??
                                        0)
                                    .toString();
                            final rating = (similarProduct.avgRating ?? 0)
                                .toString();

                            return ProductCard(
                              name: name,
                              image: image,
                              price: price,
                              rating: rating,
                              onTap: () {
                                PageNavigationService.to(
                                  context,
                                  AppRoutes.productDetails,
                                  arguments: {'productId': similarProduct.id},
                                );
                              },
                              onTapFavourite: () {},
                            );
                          },
                        ),
                ),

                SizedBox(height: 10.h(context)),

                // ================= VOUCHERS =================
                ViewAllList(
                  title: 'Vouchers',
                  onTap: () {
                    PageNavigationService.to(
                      context,
                      AppRoutes.allVouchers,
                      arguments: {'title': 'Shop Vouchers'},
                    );
                  },
                ),

                SizedBox(height: 10.h(context)),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: vouchers.isEmpty
                        ? [
                            SizedBox(
                              width: 320.w(context),
                              child: const Text('No vouchers available'),
                            ),
                          ]
                        : List.generate(vouchers.length, (index) {
                            final voucherData = vouchers[index];
                            final discountType =
                                voucherData.discountType ?? 'Discount';
                            final discountValue =
                                voucherData.discountValue?.toString() ?? '0';
                            final minSpend =
                                voucherData.minSpend?.toString() ?? '0';
                            final expiryDate = voucherData.expiryDate;
                            final expiryText = expiryDate == null
                                ? 'No expiry date'
                                : 'Expires on ${expiryDate.toLocal().toString().split(" ").first}';

                            return Padding(
                              padding: EdgeInsets.only(
                                right: index == vouchers.length - 1
                                    ? 0
                                    : 10.w(context),
                              ),
                              child: SizedBox(
                                width: 320.w(context),
                                child: VoucherCardDesign(
                                  isCompact: true,
                                  voucher: Voucher(
                                    title:
                                        '${discountValue} ${discountType} Off',
                                    subtitle:
                                        'Purchase ${minSpend} or more and save ${discountValue}',
                                    code: voucherData.code ?? '',
                                    expiryText: expiryText,
                                    status: VoucherStatus.active,
                                  ),
                                ),
                              ),
                            );
                          }),
                  ),
                ),

                SizedBox(height: 20.h(context)),

                // ================= USER FEEDBACK =================
                ViewAllList(
                  title: 'User Feedbacks',
                  onTap: () {
                    PageNavigationService.to(
                      context,
                      AppRoutes.allProductReview,
                      arguments: {'title': 'Reviews'},
                    );
                  },
                ),

                SizedBox(height: 10.h(context)),

                reviews.isEmpty
                    ? Container(
                        padding: EdgeInsets.all(12.w(context)),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(12.h(context)),
                          border: Border.all(
                            color: const Color(0xFFE7E7E7),
                            width: 1.w(context),
                          ),
                        ),
                        child: const Center(child: Text('No reviews yet')),
                      )
                    : UserFeedbackSection(
                        feedbacks: reviews.map((review) {
                          return UserFeedbackModel(
                            userName: review.user?.name ?? 'Anonymous',
                            date: review.createdAt ?? DateTime.now(),
                            rating: (review.rating ?? 0).toDouble(),
                            comment: review.review ?? '',
                          );
                        }).toList(),
                      ),

                SizedBox(height: 20.h(context)),
              ],
            ),
          ),
        );
      }),
    );
  }
}
