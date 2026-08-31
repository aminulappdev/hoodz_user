import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/app_cached_network_image.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/cart_quantity.dart';
import 'package:hoodz/gen/assets.gen.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.size,
    required this.color,
    required this.price,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    required this.onEdit,
    required this.onRemove,
  });

  final String imageUrl;
  final String name;
  final String size;
  final String color;
  final double price;
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r(context)),
        border: Border.all(color: const Color(0xffEAEAEA)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 108.w(context),
              child: AppCachedNetworkImage(
                imageUrl: imageUrl,
                imageFit: BoxFit.cover,
                radius: 12.r(context),
              ),
            ),
            SizedBox(width: 14.w(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontSize: 14.sp(context),
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff6A6A6A),
                              ),
                        ),
                      ),
                      SizedBox(width: 12.w(context)),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: onEdit,
                            child: Icon(
                              Icons.edit_outlined,
                              size: 20.h(context),
                              color: const Color(0xFF777777),
                            ),
                          ),
                          SizedBox(width: 10.w(context)),
                          GestureDetector(
                            onTap: onRemove,
                            child: CrashSafeImage(
                              Assets.icons.delete02.path,
                              height: 20.h(context),
                              width: 20.w(context),
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h(context)),
                  Text(
                    '${Strings.size.tr}: $size    ${Strings.color.tr}: $color',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp(context),
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff6E6E6E),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(height: 6.h(context)),
                  Row(
                    children: [
                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 16.sp(context),
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff333333),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w(context),
                          vertical: 4.h(context),
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffF1F4F6),
                          borderRadius: BorderRadius.circular(30.r(context)),
                        ),
                        child: Row(
                          children: [
                            QuantityButton(
                              icon: Icons.remove,
                              onTap: onDecrease,
                            ),
                            SizedBox(width: 18.w(context)),
                            SizedBox(
                              width: 24.w(context),
                              child: Text(
                                quantity.toString().padLeft(2, '0'),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      fontSize: 16.sp(context),
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff666666),
                                    ),
                              ),
                            ),
                            SizedBox(width: 18.w(context)),
                            QuantityButton(icon: Icons.add, onTap: onIncrease),
                          ],
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
    );
  }
}
