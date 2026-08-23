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
  final VoidCallback onTapDelete;

  const WishListCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.onTap,
    required this.onTapDelete,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffF1F1F1)),
        borderRadius: BorderRadius.circular(20.r(context)),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 96.w(context),
                child: AppCachedNetworkImage(
                  imageHeight: double.infinity,
                  imageUrl: imageUrl,
                  imageWidth: 96.w(context),
                  imageFit: BoxFit.cover,
                  radius: 12.r(context),
                ),
              ),
              SizedBox(width: 12.w(context)),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16.sp(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h(context)),
                    Text(
                      price,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14.sp(context),
                        fontWeight: FontWeight.w600,
                        color: LightThemeColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 8.h(context)),
                    Row(
                      children: [
                        Expanded(child: AddToCartButton(onTap: onTap)),
                        SizedBox(width: 16.w(context)),
                        GestureDetector(
                          onTap: onTapDelete,
                          child: CrashSafeImage(
                            Assets.icons.delete.path,
                            height: 18.h(context),
                            width: 18.w(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
