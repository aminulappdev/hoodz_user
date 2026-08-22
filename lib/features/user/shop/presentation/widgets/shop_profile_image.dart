
import 'package:flutter/material.dart';
import 'package:hoodz/core/constants/app_strings.dart' show AppStrings;
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/app_cached_network_image.dart';

class ShopProfileImage extends StatelessWidget {
  const ShopProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.w(context)),
      ),
      child: AppCachedNetworkImage(
        imageUrl: AppStrings.demoImageUrl,
        imageHeight: 90.h(context),
        imageWidth: 90.w(context),
        imageFit: BoxFit.cover,
        radius: 45.r(context),
      ),
    );
  }
}