import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/core/constants/app_strings.dart';
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

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

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

        final product = controller.productData?.product;

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
                  price: '42.95',
                  rating: '4.7',
                  review: '243',
                  storeName: product?.brand ?? '',
                  storeCategory: product?.collectionType ?? '',
                  storeImageUrl: AppStrings.demoImageUrl,
                  isInStock: true,
                ),

                SizedBox(height: 10.h(context)),

                // ================= SIZE =================
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
                      children: controller.sizes.map((size) {
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

                // ================= COLOR =================
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
                    children: List.generate(controller.colors.length, (index) {
                      final bool isSelected =
                          controller.selectedColorIndex.value == index;

                      return Padding(
                        padding: EdgeInsets.only(right: 14.w(context)),
                        child: GestureDetector(
                          onTap: () {
                            controller.onColorSelected(index);
                          },
                          child: ColorPlate(
                            color: controller.colors[index],
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
                  child: Html(data: product?.description ?? ''),
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
                  child: ListView.separated(
                    itemCount: controller.productList.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(width: 14.w(context));
                    },
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final product = controller.productList[index];

                      final name = product['name'] ?? '';
                      final image = product['image'] ?? '';
                      final price = product['price'] ?? '';
                      final rating = product['rating'] ?? '';

                      return ProductCard(
                        name: name,
                        image: image,
                        price: price,
                        rating: rating,
                        onTap: () {
                          PageNavigationService.to(
                            context,
                            AppRoutes.productDetails,
                            arguments: {'productId': product['id']},
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
                    children: List.generate(5, (index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index == 4 ? 0 : 10.w(context),
                        ),
                        child: SizedBox(
                          width: 320.w(context),
                          child: VoucherCardDesign(
                            isCompact: true,
                            voucher: Voucher(
                              title: 'EGP 200 Off',
                              subtitle:
                                  'Purchase EGP 1,000 or more and save EGP 200',
                              code: 'SHOP25K100',
                              expiryText: 'Expires in 2 days',
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

                UserFeedbackSection(
                  feedbacks: [
                    UserFeedbackModel(
                      userName: 'Annisa Azalea',
                      date: DateTime(2022, 2, 6),
                      rating: 4,
                      comment:
                          'In molestie sed dui nisi, egestas facilisis non. Pharetra, blandit tellus nisl ultrices egestas dui in suspendisse.',
                    ),
                    UserFeedbackModel(
                      userName: 'Joko Rakabuming',
                      date: DateTime(2022, 2, 6),
                      rating: 4,
                      comment:
                          'In molestie sed dui nisi, egestas facilisis non. Pharetra, blandit tellus nisl ultrices egestas dui in suspendisse.',
                    ),
                    UserFeedbackModel(
                      userName: 'Savannah Nguyen',
                      date: DateTime(2022, 2, 6),
                      rating: 4,
                      comment:
                          'In molestie sed dui nisi, egestas facilisis non. Pharetra, blandit tellus nisl ultrices egestas dui in suspendisse.',
                    ),
                  ],
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
