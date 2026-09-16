import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/shimmer/homescreen_shimmer.dart';

class LocationSelectionSheet extends StatelessWidget {
  const LocationSelectionSheet({
    super.key,
    required this.onTapCurrentLocation,
    required this.onTapDifferentLocation,
    this.isLoadingCurrentLocation = false,
  });

  final VoidCallback onTapCurrentLocation;
  final VoidCallback onTapDifferentLocation;
  final bool isLoadingCurrentLocation;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          20.w(context),
          14.h(context),
          20.w(context),
          22.h(context),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28.r(context)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 46.w(context),
              height: 5.h(context),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5E5),
                borderRadius: BorderRadius.circular(999.r(context)),
              ),
            ),
            SizedBox(height: 20.h(context)),
            LocationOptionTile(
              icon: Icons.my_location_rounded,
              iconColor: const Color(0xFFFF6A00),
              title: Strings.deliverToCurrentLocation.tr,
              borderColor: const Color(0xFFFFD6BD),
              backgroundColor: const Color(0xFFFFFAF6),
              isLoading: isLoadingCurrentLocation,
              onTap: onTapCurrentLocation,
            ),
            SizedBox(height: 12.h(context)),
            LocationOptionTile(
              icon: Icons.location_on_outlined,
              iconColor: const Color(0xFF9C9C9C),
              title: Strings.deliverToDifferentLocation.tr,
              borderColor: const Color(0xFFEDEDED),
              backgroundColor: const Color(0xFFF9F9F9),
              onTap: onTapDifferentLocation,
            ),
          ],
        ),
      ),
    );
  }
}

class LocationOptionTile extends StatelessWidget {
  const LocationOptionTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.borderColor,
    required this.backgroundColor,
    required this.onTap,
    this.isLoading = false,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final Color borderColor;
  final Color backgroundColor;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18.r(context)),
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 14.w(context),
          vertical: 14.h(context),
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18.r(context)),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              height: 34.h(context),
              width: 34.w(context),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: isLoading
                  ? Padding(
                      padding: EdgeInsets.all(8.r(context)),
                      child: HomeShimmerBox(
                        height: 18.h(context),
                        width: 18.w(context),
                        radius: 9.r(context),
                        circle: true,
                      ),
                    )
                  : Icon(icon, color: iconColor, size: 18.sp(context)),
            ),
            SizedBox(width: 12.w(context)),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF414141),
                  fontSize: 15.sp(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
