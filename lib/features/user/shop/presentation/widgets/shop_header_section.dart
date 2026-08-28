import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/app_cached_network_image.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/arrow_button.dart';
import 'package:hoodz/features/user/shop/presentation/widgets/shop_meta_item.dart';
import 'package:hoodz/features/user/shop/presentation/widgets/shop_profile_image.dart';
import 'package:hoodz/gen/assets.gen.dart';

class ShopHeader extends StatelessWidget {
  const ShopHeader({
    super.key,
    required this.coverImageUrl,
    required this.profileImageUrl,
    required this.shopName,
    required this.distance,
    required this.deliveryTime,
    required this.rating,
    required this.likes,
    required this.followers,
    required this.description,
    required this.categories,
    required this.isFollowing,
    required this.isFollowLoading,
    required this.onTapFollow,
    required this.onTapFavourite,
    required this.isWishlisted,
  });

  final String coverImageUrl;
  final String profileImageUrl;
  final String shopName;
  final String distance;
  final String deliveryTime;
  final String rating;
  final String likes;
  final String followers;
  final String description;
  final List<String> categories;
  final bool isFollowing;
  final bool isFollowLoading;
  final VoidCallback onTapFollow;
  final VoidCallback onTapFavourite;
  final bool isWishlisted;

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
              imageUrl: coverImageUrl,
              imageHeight: 240.h(context),
              imageWidth: screenWidth,
              imageFit: BoxFit.cover,
              radius: 0,
            ),
            Positioned(
              top: 48.h(context),
              left: 16.w(context),
              right: 16.w(context),
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ArrowButton(),

                    GestureDetector(
                      onTap: onTapFavourite,
                      child: CircleAvatar(
                        backgroundColor: isWishlisted == true
                            ? const Color(0xFFFFE7E7)
                            : const Color(0xFFF3F3F3),
                        radius: 17.r(context),
                        child: CircleAvatar(
                          backgroundColor: isWishlisted == true
                              ? const Color(0xFFFFF5F5)
                              : Colors.white,
                          radius: 16.r(context),
                          child: CrashSafeImage(
                            isWishlisted == true
                                ? Assets.icons.favouriteFill.path
                                : Assets.icons.favourite.path,
                            height: 16.h(context),
                            width: 16.w(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                    Positioned(
                      left: 0,
                      top: 0,
                      child: ShopProfileImage(imageUrl: profileImageUrl),
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
                                      icon: Assets.icons.star.path,
                                      label: '$rating ($likes)',
                                      iconColor: const Color(0xffFFC107),
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
                                      icon: Assets.icons.location02.path,
                                      label: distance,
                                    ),
                                    ShopMetaItem(
                                      icon: null,
                                      label: followers,
                                      leadingIcon: Icons.group,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          CustomButton(
                            text: isFollowing ? 'Unfollow' : 'Follow',
                            height: 40.h(context),
                            width: 100.w(context),
                            onPressed: isFollowLoading ? null : onTapFollow,
                            backgroundColor: isFollowing
                                ? const Color(0xffFFF4EC)
                                : const Color(0xffFF6A00),
                            borderColor: isFollowing
                                ? const Color(0xffFF6A00)
                                : Colors.transparent,
                            textStyle: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: isFollowing
                                      ? const Color(0xffFF6A00)
                                      : Colors.white,
                                  fontSize: 15.sp(context),
                                  fontWeight: FontWeight.w600,
                                ),
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}
