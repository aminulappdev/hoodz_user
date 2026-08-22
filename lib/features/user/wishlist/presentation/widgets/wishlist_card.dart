import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/app_cached_network_image.dart';
import 'package:hoodz/features/user/wishlist/presentation/widgets/add_to_cart.dart';
import 'package:hoodz/gen/assets.gen.dart';

class WishListCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String price;
  final VoidCallback onTap;

  const WishListCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final imageHeight = 90.h(context);
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffF1F1F1)),
        borderRadius: BorderRadius.circular(20.r(context)),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCachedNetworkImage(
                  imageHeight: imageHeight,
                  imageUrl: imageUrl,
                  imageWidth: 80.w(context),
                  imageFit: BoxFit.cover,
                  radius: 12.r(context),
                ),
                SizedBox(width: 12.w(context)),
                Expanded(
                  child: SizedBox(
                    height: imageHeight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontSize: 16.sp(context),
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          price,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontSize: 14.sp(context),
                                fontWeight: FontWeight.w600,
                                color: LightThemeColors.primaryColor,
                              ),
                        ),
                        Row(
                          children: [
                            Expanded(child: AddToCartButton(onTap: onTap)),
                            SizedBox(width: 30.w(context)),
                            CrashSafeImage(
                              Assets.icons.delete.path,
                              height: 18.h(context),
                              width: 18.w(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
