import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/app_cached_network_image.dart';
import 'package:hoodz/gen/assets.gen.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({ 
    super.key,
    required this.name,
    required this.image,
    required this.price,
    required this.rating, 
    this.onTap,
    this.productId,
    required this.onTapFavourite,
    this.subtitle = 'T-Shirt',
    this.oldPrice,
    this.stockLabel,
    this.isWishlisted,
  });

  final String name;
  final String image;
  final String price;
  final String rating;
  final VoidCallback? onTap;
  final String? productId;
  final VoidCallback onTapFavourite;
  final String subtitle;
  final String? oldPrice;
  final String? stockLabel;
  final bool? isWishlisted;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            PageNavigationService.to(
              context,
              AppRoutes.productDetails,
              arguments: productId == null || productId!.isEmpty
                  ? null
                  : {'productId': productId},
            );
          },
      child: Container(
        width: 200.w(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r(context)),
          color: const Color(0xFFF8F8F8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.18),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AppCachedNetworkImage(
                    imageUrl: image,
                    imageHeight: 150.h(context),
                    imageFit: BoxFit.cover,
                    radius: 12.r(context),
                  ),
                  if (stockLabel != null && stockLabel!.isNotEmpty)
                    Positioned(
                      top: 8.h(context),
                      left: 8.w(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w(context),
                          vertical: 4.h(context),
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9FFF0),
                          borderRadius: BorderRadius.circular(999.r(context)),
                        ),
                        child: Text(
                          stockLabel!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: const Color(0xFF3BC06C),
                                fontSize: 10.sp(context),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ),
                  if (isWishlisted != null)
                    Positioned(
                      top: 8.h(context),
                      right: 8.w(context),
                      child: GestureDetector(
                        onTap: onTapFavourite,
                        child: CircleAvatar(
                          backgroundColor: isWishlisted == true
                              ? const Color(0xFFFFE7E7)
                              : const Color(0xFFF3F3F3),
                          radius: 17.r(context),
                          child: CircleAvatar(
                            backgroundColor: isWishlisted == true
                                ? const Color(0xFFFFF5F5)
                                : Colors.white,
                            radius: 16.r(context),
                            child: CrashSafeImage(
                              isWishlisted == true
                                  ? Assets.icons.favouriteFill.path
                                  : Assets.icons.favourite.path,
                              height: 16.h(context),
                              width: 16.w(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8.h(context)),
              Flexible(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 16.sp(context),
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 4.h(context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 14.sp(context),
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF707070),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CrashSafeImage(
                          Assets.icons.star.path,
                          height: 16.h(context),
                          width: 16.w(context),
                        ),
                        SizedBox(width: 4.w(context)),
                        Flexible(
                          child: Text(
                            rating,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  fontSize: 14.sp(context),
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      price,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 16.sp(context),
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF22C55E),
                      ),
                    ),
                  ),
                  if (oldPrice != null && oldPrice!.isNotEmpty) ...[
                    SizedBox(width: 6.w(context)),
                    Flexible(
                      child: Text(
                        oldPrice!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 12.sp(context),
                          color: const Color(0xFFB7B7B7),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                  ],
                  SizedBox(width: 4.w(context)),
                  CircleAvatar(
                    radius: 17.r(context),
                    backgroundColor: Colors.white,
                    child: CrashSafeImage(
                      Assets.icons.cart.path,
                      height: 14.h(context),
                      width: 14.w(context),
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
