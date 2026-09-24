import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
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
  final String statusKey;
  final String statusText;
  final VoidCallback onTap;
  final VoidCallback optionalOnTap;
  final VoidCallback? onReorder;

  const OrderCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.date,
    required this.orderID,
    required this.price,
    required this.type,
    this.statusKey = '',
    required this.statusText,
    required this.onTap,
    required this.optionalOnTap,
    required this.item,
    this.onReorder,
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
                          _StatusLabel(
                            statusKey: statusKey,
                            statusText: statusText,
                          ),
                        ],
                      ),
                      Text(
                        date,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12.sp(context),
                            ),
                      ),
                      Text(
                        '$item ${Strings.items.tr}',
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
            if (type == 'processing')
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: Strings.viewOrder.tr,
                      onPressed: onTap,
                    ),
                  ),
                  SizedBox(width: 12.w(context)),
                  Expanded(
                    child: _HelpButton(onTap: optionalOnTap),
                  ),
                ],
              )
            else if (type == 'completed')
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      backgroundColor: Colors.transparent,
                      borderColor: LightThemeColors.primaryColor,
                      text: Strings.reorder.tr,
                      textStyle: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(color: LightThemeColors.primaryColor),
                      onPressed: onReorder ?? optionalOnTap,
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
                      text: Strings.orderAgain.tr,
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
  const _StatusLabel({
    required this.statusKey,
    required this.statusText,
  });

  final String statusKey;
  final String statusText;

  @override
  Widget build(BuildContext context) {
    final normalizedStatus = statusKey.trim().toLowerCase().replaceAll(' ', '_');

    if (normalizedStatus == 'rider_assigned') {
      return LabelContainer(
        icon: Assets.icons.box01.path,
        name: statusText,
        contentColor: const Color(0xFF2563EB),
        backgroundColor: const Color(0xFF2563EB),
      );
    }

    if (normalizedStatus == 'completed' ||
        normalizedStatus == 'delivered' ||
        normalizedStatus == 'delivery') {
      return LabelContainer(
        icon: Assets.icons.checkMark.path,
        name: statusText,
        contentColor: const Color(0xFF12B76A),
        backgroundColor: const Color(0xFF12B76A),
      );
    }

    if (normalizedStatus == 'cancelled' ||
        normalizedStatus == 'canceled' ||
        normalizedStatus == 'cancel') {
      return LabelContainer(
        icon: null,
        name: statusText,
        contentColor: const Color(0xFFEF4444),
        backgroundColor: const Color(0xFFEF4444),
      );
    }

    return LabelContainer(
      icon: Assets.icons.box01.path,
      name: statusText,
      contentColor: const Color(0xFFF97316),
      backgroundColor: const Color(0xFFF97316),
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
              Strings.help.tr,
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
