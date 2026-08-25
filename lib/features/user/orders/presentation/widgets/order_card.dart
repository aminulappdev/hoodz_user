import 'package:flutter/material.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/app_cached_network_image.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/core/widgets/label_container.dart';
import 'package:hoodz/gen/assets.gen.dart';

class OrderCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String date;
  final String orderID;
  final String price;
  final int item;
  final String type;
  final VoidCallback onTap;
  final VoidCallback optionalOnTap;

  const OrderCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.date,
    required this.orderID,
    required this.price,
    required this.type,
    required this.onTap,
    required this.optionalOnTap,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffF1F1F1)),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCachedNetworkImage(
                  imageUrl: imageUrl,
                  imageWidth: 80.w(context),
                  imageHeight: 80.h(context),
                  imageFit: BoxFit.cover,
                  radius: 12.r(context),
                ),
                SizedBox(width: 12.w(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontSize: 16.sp(context),
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          SizedBox(width: 8.w(context)),
                          _StatusLabel(type: type),
                        ],
                      ),
                      Text(
                        date,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12.sp(context),
                            ),
                      ),
                      Text(
                        '$item items',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12.sp(context),
                            ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            orderID,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontSize: 12.sp(context),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Text(
                            '\$$price',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontSize: 12.sp(context),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h(context)),
            if (type == 'Processing')
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'View Order',
                      onPressed: onTap,
                    ),
                  ),
                  SizedBox(width: 12.w(context)),
                  Expanded(
                    child: _HelpButton(onTap: optionalOnTap),
                  ),
                ],
              )
            else if (type == 'Completed')
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      backgroundColor: Colors.transparent,
                      borderColor: LightThemeColors.primaryColor,
                      text: 'Reorder',
                      textStyle: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(color: LightThemeColors.primaryColor),
                      onPressed: optionalOnTap,
                    ),
                  ),
                  SizedBox(width: 12.w(context)),
                  Expanded(
                    child: _HelpButton(onTap: optionalOnTap),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Order Again',
                      onPressed: onTap,
                    ),
                  ),
                  SizedBox(width: 12.w(context)),
                  Expanded(
                    child: _HelpButton(onTap: optionalOnTap),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    if (type == 'Processing') {
      return LabelContainer(
        icon: Assets.icons.box01.path,
        name: 'Processing',
        contentColor: LightThemeColors.primaryColor,
        backgroundColor: LightThemeColors.primaryColor,
      );
    }

    if (type == 'Completed') {
      return LabelContainer(
        icon: Assets.icons.checkMark.path,
        name: 'Delivered',
        contentColor: const Color(0xff12B76A),
        backgroundColor: const Color(0xff12B76A),
      );
    }

    return LabelContainer(
      icon: Assets.icons.cross.path,
      name: 'Cancelled',
      contentColor: LightThemeColors.primaryColor,
      backgroundColor: LightThemeColors.primaryColor,
    );
  }
}

class _HelpButton extends StatelessWidget {
  final VoidCallback onTap;

  const _HelpButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r(context)),
      child: Container(
        height: 50.h(context),
        decoration: BoxDecoration(
          color: LightThemeColors.primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(30.r(context)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.headset_mic_outlined,
              size: 16.sp(context),
              color: LightThemeColors.primaryColor,
            ),
            SizedBox(width: 4.w(context)),
            Text(
              'Help',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13.sp(context),
                    fontWeight: FontWeight.w600,
                    color: LightThemeColors.primaryColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
