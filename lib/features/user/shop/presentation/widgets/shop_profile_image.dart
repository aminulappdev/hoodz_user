import 'package:flutter/material.dart';
import 'package:hoodz/core/constants/app_strings.dart' show AppStrings;
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/app_cached_network_image.dart';

class ShopProfileImage extends StatelessWidget {
  const ShopProfileImage({super.key, this.imageUrl = AppStrings.demoImageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFFF6A00),
          width: 2.w(context),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            offset: Offset(0, 8),
            blurRadius: 18,
          ),
        ],
      ),
      child: AppCachedNetworkImage(
        imageUrl: imageUrl,
        imageHeight: 90.h(context),
        imageWidth: 90.w(context),
        imageFit: BoxFit.cover,
        radius: 45.r(context),
      ),
    );
  }
}
