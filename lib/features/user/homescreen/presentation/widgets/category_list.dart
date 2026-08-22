import 'package:flutter/material.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class CategoriesList extends StatelessWidget {
  final String image;
  final String name;
  final VoidCallback onTap;
  final bool isSelected;


  const CategoriesList({
    super.key,
    required this.image,
    required this.name,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 80.h(context),
            width: 80.w(context),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
              border: Border.all(
                color: isSelected
                    ? LightThemeColors.primaryColor
                    : LightThemeColors.backgroundColor,
                width: isSelected ? 1 : 0,
              ),
              borderRadius: BorderRadius.circular(10.h(context)),
            ),
          ),
        ),
        SizedBox(height: 4.h(context)),
        Text(
          name,
          style: TextStyle(
            fontSize: 14.sp(context),
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}