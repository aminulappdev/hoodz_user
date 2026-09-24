import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/gen/assets.gen.dart';

class ProductInfo extends StatelessWidget {
  final String productTitle;
  final String price;
  final String rating;
  final String review;
  final String storeName;
  final String storeCategory;
  final String storeImageUrl;
  final String? shopId;
  final bool isInStock;

  const ProductInfo({
    super.key,
    this.productTitle = '',
    required this.price,
    required this.rating,
    required this.review,
    required this.storeName,
    required this.storeCategory,
    required this.storeImageUrl,
    this.shopId,
    required this.isInStock,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (productTitle.trim().isNotEmpty) ...[
          Text(
            productTitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 18.sp(context),
              fontWeight: FontWeight.w700,
              color: const Color(0xff4A4A4A),
            ),
          ),
          SizedBox(height: 10.h(context)),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '\$$price',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 18.sp(context),
                fontWeight: FontWeight.w700,
                color: const Color(0xff4A4A4A),
              ),
            ),
            Row(
              children: [
                CrashSafeImage(
                  Assets.icons.star.path,
                  height: 18.h(context),
                  width: 18.w(context),
                  color: const Color(0xffFFC107),
                ),
                SizedBox(width: 6.w(context)),
                Text(
                  rating,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16.sp(context),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff4A4A4A),
                  ),
                ),
                SizedBox(width: 4.w(context)),
                Text(
                  '($review ${Strings.reviews.tr})',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp(context),
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff7C7C7C),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16.h(context)),
        GestureDetector(
          onTap: () {
            final id = shopId?.trim();
            if (id == null || id.isEmpty) {
              return;
            }

            PageNavigationService.to(
              context,
              AppRoutes.shop,
              arguments: {'shopId': id},
            );
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w(context)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.r(context)),
              border: Border.all(color: const Color(0xFFE8ECF2)),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(28.r(context)),
                  child: CrashSafeImage(
                    storeImageUrl,
                    height: 48.h(context),
                    width: 48.w(context),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 8.w(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        storeName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16.sp(context),
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2D2D2D),
                        ),
                      ),
                      // SizedBox(height: 4.h(context)),
                      Text(
                        storeCategory,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12.sp(context),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF3D73E8),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w(context)),
                Text(
                  isInStock ? Strings.inStock.tr : Strings.outOfStock.tr,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp(context),
                    color: isInStock ? const Color(0xFF12B76A) : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        
      ],
    );
  }
}
