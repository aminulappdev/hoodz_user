import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_button.dart';

class CartAndBuy extends StatelessWidget {
  final VoidCallback? onTapAddToCart;
  final VoidCallback? onTapBuyNow;
  final bool isAddToCartEnabled;
  final bool isBuyNowEnabled;

  const CartAndBuy({
    super.key,
    this.onTapAddToCart,
    this.onTapBuyNow,
    this.isAddToCartEnabled = true,
    this.isBuyNowEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton( 
            text: Strings.addToCart.tr,
            height: 48.h(context),
            onPressed: onTapAddToCart,
            enabled: isAddToCartEnabled,
            textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 16.sp(context),
              fontWeight: FontWeight.w700,
              color: LightThemeColors.primaryColor,
            ),
            backgroundColor: Color(0xffF6F6F6),
          ),
        ),

        SizedBox(width: 14.w(context)), 
        Expanded(
          child: CustomButton(
            
            text: Strings.buyNow.tr,
            height: 48.h(context),
            onPressed: onTapBuyNow,
            enabled: isBuyNowEnabled,
            backgroundColor: LightThemeColors.primaryColor,
          ),
        ),
      ],
    );
  }
}
