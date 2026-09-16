import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/app_cached_network_image.dart';
import 'package:hoodz/gen/assets.gen.dart';

class RecommendationCard extends StatelessWidget {
  const RecommendationCard({
    super.key,
    required this.brand,
    required this.name,
    required this.price,
    this.imageUrl,
    this.onViewTap,
  });

  final String brand;
  final String name;
  final String price;
  final String? imageUrl;
  final VoidCallback? onViewTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 252.w(context),
        padding: EdgeInsets.all(6.r(context)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r(context)),
          border: Border.all(color: const Color(0xFFE7E7E7)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r(context)),
              child: imageUrl?.trim().isNotEmpty == true
                  ? AppCachedNetworkImage(
                      imageUrl: imageUrl,
                      imageWidth: 46.w(context),
                      imageHeight: 58.h(context),
                      imageFit: BoxFit.cover,
                      radius: 8.r(context),
                    )
                  : Assets.icons.aiChat.image(
                      width: 46.w(context),
                      height: 58.h(context),
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(width: 10.w(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h(context)),
                  Text(
                    brand,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF8B8B8B),
                      fontFamily: 'Poppins',
                      fontSize: 10.sp(context),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 2.h(context)),
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF444444),
                      fontFamily: 'Poppins',
                      fontSize: 13.sp(context),
                      fontWeight: FontWeight.w500,
                      height: 1.25,
                    ),
                  ),
                  SizedBox(height: 6.h(context)),
                  Row(
                    children: [
                      Text(
                        price,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF4A4A4A),
                          fontFamily: 'Poppins',
                          fontSize: 12.sp(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: onViewTap,
                        borderRadius: BorderRadius.circular(999.r(context)),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w(context),
                            vertical: 3.h(context),
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6A00),
                            borderRadius:
                                BorderRadius.circular(999.r(context)),
                          ),
                          child: Text(
                            Strings.view.tr,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 10.sp(context),
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
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
