import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:hoodz/core/constants/app_strings.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/app_cached_network_image.dart';
import 'package:hoodz/gen/assets.gen.dart';

class BrandCardList extends StatelessWidget {
  final VoidCallback? onTap;
  const BrandCardList({super.key, this.onTap});
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration( 
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.h(context)),
          border: Border.all(color: const Color(0xFFF0F0F0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppCachedNetworkImage(
                imageUrl: AppStrings.demoImageUrl,
                imageHeight: 70.h(context),
                imageWidth: 70.w(context),
                imageFit: BoxFit.cover,
                radius: 10.h(context),
              ),
              SizedBox(width: 14.w(context)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Levi\'s',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 18.sp(context),
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF3A3A3A),
                    ),
                  ),
                  SizedBox(height: 5.h(context)),
                  Row(
                    children: [
                      CrashSafeImage(
                        Assets.icons.star.path,
                        height: 14.h(context),
                      ),
                      SizedBox(width: 5.w(context)),
                      Text(
                        '4.5 (1.2k)',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 13.sp(context),
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF3A3A3A),
                        ),
                      ),
                      SizedBox(width: 8.w(context)),
                      CircleAvatar(
                        radius: 2.r(context),
                        backgroundColor: const Color(0xFF3A3A3A),
                      ),
                      SizedBox(width: 8.w(context)),
                      CrashSafeImage(
                        Assets.icons.location02.path,
                        height: 14.h(context),
                      ),
                      SizedBox(width: 5.w(context)),
                      Text(
                        '1.2km',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 13.sp(context),
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF3A3A3A),
                        ),
                      ),
                      SizedBox(width: 8.w(context)),
                      CircleAvatar(
                        radius: 2.r(context),
                        backgroundColor: const Color(0xFF3A3A3A),
                      ),
                      SizedBox(width: 8.w(context)),
                      CrashSafeImage(
                        Assets.icons.pickup.path,
                        height: 14.h(context),
                      ),
                      SizedBox(width: 5.w(context)),
                      Text(
                        '\$5.00',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 13.sp(context),
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF3A3A3A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
