import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/gen/assets.gen.dart';

class UserDashboardBottomNavBar extends StatelessWidget {
  const UserDashboardBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: 88,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
            boxShadow: [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 28,
                offset: Offset(0, -6),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _NavItem(
                  label: Strings.home.tr,
                  iconPath: Assets.icons.home.path,
                  isSelected: currentIndex == 0,
                  showTopIndicator: true,
                  onTap: () => onTap(0),
                ),
              ),
              Expanded(
                child: _NavItem(
                  label: Strings.orders.tr,
                  iconPath: Assets.icons.order.path,
                  isSelected: currentIndex == 1,
                  showTopIndicator: true,
                  onTap: () => onTap(1),
                ),
              ),
              const Expanded(child: SizedBox()),
              Expanded(
                child: _NavItem(
                  label: Strings.wishlist.tr,
                  iconData: Icons.favorite_border_rounded,
                  isSelected: currentIndex == 3,
                  showTopIndicator: true,
                  onTap: () => onTap(3),
                ),
              ),
              Expanded(
                child: _NavItem(
                  label: Strings.profile.tr,
                  iconPath: Assets.icons.user.path,
                  isSelected: currentIndex == 4,
                  showTopIndicator: true,
                  onTap: () => onTap(4),
                ),
              ),
            ],
          ),
        ),

        Positioned(
          bottom: 22.5,
          child: _CenterNavItem(
            label: Strings.aiStylist.tr,
            iconPath: Assets.icons.aiChat.path,
            isSelected: currentIndex == 2,
            onTap: () => onTap(2),
          ),
        ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    this.iconPath,
    this.iconData,
    required this.isSelected,
    required this.onTap,
    this.showTopIndicator = false,
  }) : assert(iconPath != null || iconData != null);

  final String label;
  final String? iconPath;
  final IconData? iconData;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showTopIndicator;

  @override
  Widget build(BuildContext context) {
    final activeColor = LightThemeColors.primaryColor;
    const inactiveColor = Color(0xFF8F8F8F);
    final isArabicLabel = RegExp(r'[\u0600-\u06FF]').hasMatch(label);
    final labelFontSize = label.length > 10 ? 11.0 : 12.0;

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    LightThemeColors.primaryColor.withOpacity(0.1),
                    LightThemeColors.primaryColor.withOpacity(0.05),
                  ],
                )
              : null,
        ),
        height: double.infinity,
        child: Stack(
          children: [
            if (showTopIndicator)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 3,
                  color: isSelected ? activeColor : Colors.transparent,
                ),
              ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (iconPath != null)
                    CrashSafeImage(
                      iconPath!,
                      color: isSelected ? activeColor : inactiveColor,
                      height: 24,
                      width: 24,
                    )
                  else
                    Icon(
                      iconData,
                      color: isSelected ? activeColor : inactiveColor,
                      size: 24,
                    ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Text(
                      label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected ? activeColor : inactiveColor,
                        fontSize: labelFontSize,
                        height: 1.05,
                        fontFamily: isArabicLabel ? null : 'Geist',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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

class _CenterNavItem extends StatelessWidget {
  const _CenterNavItem({
    required this.label,
    required this.iconPath,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String iconPath;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = LightThemeColors.primaryColor;
    const inactiveColor = Color(0xFF8F8F8F);
    final isArabicLabel = RegExp(r'[\u0600-\u06FF]').hasMatch(label);
    final labelFontSize = label.length > 10 ? 11.0 : 12.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: activeColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: activeColor.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: CrashSafeImage(
                iconPath,
                color: Colors.white,
                height: 26,
                width: 26,
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 86,
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? activeColor : inactiveColor,
                fontSize: labelFontSize,
                height: 1.05,
                fontFamily: isArabicLabel ? null : 'Geist',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
