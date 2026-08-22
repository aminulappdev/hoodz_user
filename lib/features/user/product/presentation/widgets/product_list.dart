import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class BrandList extends StatelessWidget {
  final String image;
  final String name;
  final VoidCallback onTap;
  const BrandList({
    super.key,
    required this.image,
    required this.name,  
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              border: BoxBorder.all(color: const Color(0xFFF4F4F4)),
              borderRadius: BorderRadius.circular(10.h(context)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric( 
                horizontal: 6.w(context),
                vertical: 4.h(context),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CrashSafeImage(image, height: 36.h(context)),
                  SizedBox(height: 5.h(context)),
                  Text(
                    name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp(context),
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF3F3F3F),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
