import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/app_cached_network_image.dart';
import 'package:hoodz/gen/assets.gen.dart';

class BrandProductCard extends StatelessWidget {
  const BrandProductCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.image,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.stockLabel,
    required this.onTap,
    required this.onTapFavourite,
    this.isWishlisted = false,
  });

  final String name;
  final String subtitle;
  final String image;
  final String price;
  final String oldPrice;
  final String rating;
  final String stockLabel;
  final VoidCallback onTap;
  final VoidCallback onTapFavourite;
  final bool isWishlisted;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r(context)),
          border: Border.all(color: const Color(0xFFF0F0F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(10.h(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    AppCachedNetworkImage(
                      imageUrl: image,
                      imageHeight: double.infinity,
                      imageWidth: double.infinity,
                      imageFit: BoxFit.cover,
                      radius: 14.r(context),
                    ),
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
                          stockLabel,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: const Color(0xFF3BC06C),
                                fontSize: 10.sp(context),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8.h(context),
                      right: 8.w(context),
                      child: GestureDetector(
                        onTap: onTapFavourite,
                        child: CircleAvatar(
                          backgroundColor: isWishlisted
                              ? const Color(0xFFFFF5F5)
                              : Colors.white,
                          radius: 15.r(context),
                          child: CrashSafeImage(
                            isWishlisted
                                ? Assets.icons.favouriteFill.path
                                : Assets.icons.favourite.path,
                            height: 15.h(context),
                            width: 15.w(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h(context)),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF2E2E2E),
                  fontSize: 15.sp(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h(context)),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF8C8C8C),
                  fontSize: 12.sp(context),
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 6.h(context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CrashSafeImage(
                    Assets.icons.star.path,
                    height: 14.h(context),
                    width: 14.w(context),
                  ),
                  SizedBox(width: 3.w(context)),
                  Text(
                    rating,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF686868),
                      fontSize: 12.sp(context),
                    ),
                  ),
                  Text(
                    ' (1k)',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFFB0B0B0),
                      fontSize: 11.sp(context),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h(context)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF23C06B),
                      fontSize: 18.sp(context),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(width: 6.w(context)),
                  Text(
                    oldPrice,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFFB7B7B7),
                      fontSize: 12.sp(context),
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    radius: 15.r(context),
                    backgroundColor: const Color(0xFFF8F8F8),
                    child: CrashSafeImage(
                      Assets.icons.cart.path,
                      height: 13.h(context),
                      width: 13.w(context),
                      color: const Color(0xFF505050),
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
