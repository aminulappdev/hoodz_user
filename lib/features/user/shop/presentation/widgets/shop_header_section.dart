import 'package:flutter/material.dart';
import 'package:hoodz/core/constants/app_strings.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/app_cached_network_image.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/arrow_button.dart';
import 'package:hoodz/features/user/shop/presentation/widgets/shop_meta_item.dart';
import 'package:hoodz/features/user/shop/presentation/widgets/shop_profile_image.dart';
import 'package:hoodz/features/user/shop/presentation/widgets/shop_tag.dart';
import 'package:hoodz/gen/assets.gen.dart';

class ShopHeader extends StatelessWidget {
  const ShopHeader({
    super.key,
    required this.shopName,
    required this.distance,
    required this.deliveryTime,
    required this.rating,
    required this.likes,
    required this.followers,
    required this.description,
    required this.categories,
  });

  final String shopName;
  final String distance;
  final String deliveryTime;
  final String rating;
  final String likes;
  final String followers;
  final String description;
  final List<String> categories;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            AppCachedNetworkImage(
              imageUrl: AppStrings.demoImageUrl,
              imageHeight: 240.h(context),
              imageWidth: screenWidth,
              imageFit: BoxFit.cover,
              radius: 0,
            ),
            Positioned(
              top: 48.h(context),
              left: 16.w(context),
              child: ArrowButton(),
            ),
          ],
        ),
        Transform.translate(
          offset: Offset(0, -18.h(context)),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              18.w(context),
              0,
              28.w(context),
              18.h(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Positioned(
                      left: 0,
                      top: 0,
                      child: ShopProfileImage(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 18.h(context)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,

                        children: [
                          SizedBox(width: 104.w(context)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  shopName,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        fontSize: 22.sp(context),
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xff454545),
                                      ),
                                ),
                                SizedBox(height: 4.h(context)),
                                Wrap(
                                  spacing: 12.w(context),
                                  runSpacing: 6.h(context),
                                  children: [
                                    ShopMetaItem(
                                      icon: Assets.icons.location02.path,
                                      label: distance,
                                    ),
                                    ShopMetaItem(
                                      icon: Assets.icons.clock.path,
                                      label: deliveryTime,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h(context)),
                                Wrap(
                                  spacing: 12.w(context),
                                  runSpacing: 6.h(context),
                                  children: [
                                    ShopMetaItem(
                                      icon: Assets.icons.star.path,
                                      label: '$rating ($likes)',
                                      iconColor: const Color(0xffFFC107),
                                    ),
                                    ShopMetaItem(
                                      icon: null,
                                      label: followers,
                                      leadingIcon: Icons.camera_alt_outlined,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          CustomButton(
                            text: 'Follow',
                            height: 40.h(context),
                            width: 82.w(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h(context)),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp(context),
                    height: 1.55,
                    color: const Color(0xff787878),
                  ),
                ),
                SizedBox(height: 16.h(context)),
                SizedBox(
                  height: 40.h(context),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index == categories.length - 1
                              ? 0
                              : 10.w(context),
                        ),
                        child: ShopTag(category: category),
                      );
                    },
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ],
    );
  }
}
