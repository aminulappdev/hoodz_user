import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/gen/assets.gen.dart';

class AddToCartButton extends StatelessWidget {
  final VoidCallback? onTap;
  const AddToCartButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30.h(context),

        decoration: BoxDecoration(
          border: Border.all(
            color: LightThemeColors.primaryColor,
            width: 0.3.w(context),
          ),
          borderRadius: BorderRadius.circular(30.r(context)),
          color: LightThemeColors.primaryColor.withValues(alpha: 0.06),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w(context),
            vertical: 4.h(context),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CrashSafeImage(
                Assets.icons.cart.path,
                height: 16.h(context),
                width: 16.w(context),
                color: LightThemeColors.primaryColor,
              ),
              SizedBox(width: 5.w(context)),
              Text(
                'Add to cart',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12.sp(context),
                  color: LightThemeColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
