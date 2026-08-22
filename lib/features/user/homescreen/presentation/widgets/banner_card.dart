import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/app_cached_network_image.dart';
import 'package:hoodz/gen/assets.gen.dart';

class ShopCard extends StatelessWidget {
  const ShopCard({
    super.key,
    required this.image,
    required this.name,
    required this.rating,
    required this.distance, 
    required this.time,
    required this.onTap,
  });

  final String image;
  final String name;
  final String rating;
  final String distance;
  final String time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80.h(context),
        width: 270.w(context),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFEDF1F3)), 
          borderRadius: BorderRadius.circular(12.r(context)),
          color: const Color(0xFFFFFFFF),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0.h(context)),
          child: Row(
            children: [
              AppCachedNetworkImage(
                imageWidth: 80,
                imageUrl: image,
                imageFit: BoxFit.cover,
                radius: 12.r(context),
              ),
              SizedBox(width: 12.w(context)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(

                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 16.sp(context),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        CrashSafeImage(
                          Assets.icons.star.path,
                          height: 16.h(context),
                          width: 16.w(context),
                        ),
                        SizedBox(width: 4.w(context)),
                        Text(
                          rating,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontSize: 14.sp(context),
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CrashSafeImage(
                              Assets.icons.location02.path,
                              height: 16.h(context),
                              width: 16.w(context),
                            ),
                            SizedBox(width: 4.w(context)),
                            Text(
                              distance,
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(
                                    fontSize: 14.sp(context),
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ],
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     CrashSafeImage(
                        //       Assets.icons.truck.path,
                        //       height: 16.h(context),
                        //       width: 16.w(context),
                        //     ),
                        //     SizedBox(width: 4.w(context)),
                        //     Text(
                        //       time,
                        //       style: Theme.of(context).textTheme.bodyMedium!
                        //           .copyWith(
                        //             fontSize: 14.sp(context),
                        //             fontWeight: FontWeight.w400,
                        //           ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
