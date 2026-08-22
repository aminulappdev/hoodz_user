
import 'package:flutter/material.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_button.dart';

class CartAndBuy extends StatelessWidget {
  final VoidCallback? onTapAddToCart;
  final VoidCallback? onTapBuyNow;
  const CartAndBuy({super.key, this.onTapAddToCart, this.onTapBuyNow});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton( 
            text: 'Add to cart',
            height: 48.h(context),
            onPressed: onTapAddToCart,
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
            
            text: 'Buy now',
            height: 48.h(context),
            onPressed: onTapBuyNow,
            backgroundColor: LightThemeColors.primaryColor,
          ),
        ),
      ],
    );
  }
}