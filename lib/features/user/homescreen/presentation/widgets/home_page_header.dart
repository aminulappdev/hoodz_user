import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_text_field.dart';
import 'package:hoodz/gen/assets.gen.dart';

class CustomHomePageAppBar extends StatelessWidget {
  const CustomHomePageAppBar({
    super.key,
    required this.address, 
    required this.notificationCount,
    required this.onTapEdit,
    required this.onTapNotification,
    required this.onTapSearch,
  });  
 
  final String address;
  final int notificationCount;
  final VoidCallback onTapEdit;
  final VoidCallback onTapNotification;
  final VoidCallback onTapSearch;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return  Container(
      width: width,
      decoration: BoxDecoration(
        image: DecorationImage(
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h(context)),
            Row(
              children: [
                Text(
                  'Deliver to ',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 14.sp(context),
                    fontFamily: 'Geist',
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Text(
                    address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 16.sp(context),
                      fontFamily: 'Geist',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 4.w(context)),
                GestureDetector(
                  onTap: onTapEdit,
                  child: CrashSafeImage(
                    Assets.icons.edit.path,
                    height: 16.h(context),
                    width: 16.w(context),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h(context)),

            Row(
              children: [
                SizedBox(
                  width: 300.w(context),
                  child: CustomTextField(
                    hintText: 'Search...',
                    prefixIcon: Assets.icons.search02.path,
                    prefixIconColor: Colors.white,
                    readOnly: true,
                    onTap: onTapSearch,
                  ),
                ),
                SizedBox(width: 8.w(context)),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onTap: onTapNotification,
                      child: CircleAvatar(
                        radius: 29.h(context),
                        backgroundColor: Colors.white,
                        child: CrashSafeImage(
                          Assets.icons.cart.path,
                          height: 26.h(context),
                          width: 26.w(context),
                        ),
                      ),
                    ),
                    if (notificationCount > 0)
                      Positioned(
                        right: 2.w(context),
                        top: 1.h(context),
                        child: Container(
                          height: 14.h(context),
                          width: 14.w(context),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF3B30),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '$notificationCount',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 8.sp(context),
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
