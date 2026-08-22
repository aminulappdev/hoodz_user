import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/gen/assets.gen.dart';

class AllProductHeader extends StatelessWidget {
  const AllProductHeader({
    super.key,
    required this.title,
    required this.onTapBack,
    required this.onTapFilter,
    this.isFilter = true,
  });

  final String title;
  final VoidCallback onTapBack;
  final VoidCallback onTapFilter;
  final bool isFilter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: const DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/background02.jpg'),
        ),
        color: LightThemeColors.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.h(context)),
          bottomRight: Radius.circular(40.h(context)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.h(context)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: onTapBack,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFEDF1F3)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: CrashSafeImage(
                        Assets.icons.arrow.path,
                        height: 14.h(context),
                        color: const Color(0xFFEDF1F3),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w(context)),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 20.sp(context),
                    fontFamily: 'Geist',
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                if (isFilter) ...{
                  GestureDetector(
                    onTap: onTapFilter,
                    child: CircleAvatar(
                      radius: 18.r(context),
                      backgroundColor: Colors.white,
                      child: CrashSafeImage(
                        Assets.icons.filter02.path,
                        height: 20.h(context),
                        width: 20.w(context),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                },
              ],
            ),
          ],
        ),
      ),
    );
  }
}
