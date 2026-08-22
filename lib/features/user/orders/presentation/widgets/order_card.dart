import 'package:flutter/material.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            name,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontSize: 16.sp(context),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          type == 'Processing'
                              ? LabelContainer(
                                  icon: Assets.icons.box01.path,
                                  name: 'Processing',
                                  contentColor: LightThemeColors.primaryColor,
                                  backgroundColor:
                                      LightThemeColors.primaryColor,
                                )
                              : type == 'Completed'
                              ? LabelContainer(
                                  icon: Assets.icons.checkMark.path,
                                  name: 'Delivered',
                                  contentColor: Color(0xff12B76A),
                                  backgroundColor: Color(0xff12B76A),
                                )
                              : LabelContainer(
                                  icon: Assets.icons.cross.path,
                                  name: 'Cancelled',
                                  contentColor: LightThemeColors.primaryColor,
                                  backgroundColor:
                                      LightThemeColors.primaryColor,
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

            // ---------- ACTION BUTTONS ----------
            // Design অনুযায়ী প্রতিটা status-এর জন্য আলাদা button combination:
            //  - Processing: Track Your Order (filled) -> Help
            //  - Completed:  Reorder (outline) -> Review (filled) -> Help
            //  - Cancelled:  Order Again (filled) -> Help
            if (type == 'Processing')
              Row(
                children: [
                  // 👇 আগে ছিল Support, এখন Track Your Order প্রথমে (order swap)
                  Expanded(
                    child: CustomButton(
                      text: 'Track Your Order',
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
                      onPressed: onTap,
                    ),
                  ),
                  SizedBox(width: 8.w(context)),
                  Expanded(
                    child: CustomButton(
                      text: 'Review',
                      onPressed: optionalOnTap,
                    ),
                  ),
                  SizedBox(width: 8.w(context)),
                  // 👇 নতুন যোগ করা হলো — এখানে আগে Help বাটন ছিলই না
                  Expanded(
                    child: _HelpButton(onTap: () {}),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child: CustomButton(text: 'Order Again', onPressed: onTap),
                  ),
                  SizedBox(width: 12.w(context)),
                  // 👇 নতুন যোগ করা হলো
                  Expanded(
                    child: _HelpButton(onTap: () {}),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// একটা ছোট, reusable "Help" বাটন — headphone icon + text।
/// Private widget (নামের আগে _) কারণ এটা শুধু এই ফাইলের ভেতরেই দরকার,
/// বাইরে থেকে import করে ব্যবহারের প্রয়োজন নেই।
///
/// কেন CustomButton ব্যবহার করলাম না?
/// কারণ CustomButton icon সাপোর্ট করে কিনা নিশ্চিত না, আর design-এ
/// icon + text দুটোই লাগবে। তাই এখানে ছোট নিজস্ব widget বানানো হলো —
/// একবার লিখে, তিন জায়গায় reuse করা হচ্ছে (DRY principle)।
class _HelpButton extends StatelessWidget {
  final VoidCallback onTap;

  const _HelpButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        PageNavigationService.to(
          context,
          AppRoutes.aiAssistant,
          arguments: {
            'isShowBackButton': true,
            'title': 'Customer support',
            'subtitle': 'Online',
          },
        );
      },
      borderRadius: BorderRadius.circular(12.r(context)),
      child: Container(
        height: 50.h(context),
        decoration: BoxDecoration(
          // হালকা পিংক/অরেঞ্জ tint background — design-এর মতোই
          color: LightThemeColors.primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(30.r(context)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.headset_mic_outlined, // TODO: Assets.icons.headphone.path থাকলে সেটা ব্যবহার করো
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
