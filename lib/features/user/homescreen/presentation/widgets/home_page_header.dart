import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_text_field.dart';
import 'package:hoodz/gen/assets.gen.dart';

class CustomHomePageAppBar extends StatelessWidget {
  const CustomHomePageAppBar({
    super.key,
    required this.address,
    required this.cartItemsCount,
    required this.onTapEdit,
    required this.onTapNotification, 
    required this.onTapSearch,
  });

  final String address;
  final int cartItemsCount;
  final VoidCallback onTapEdit;
  final VoidCallback onTapNotification;
  final VoidCallback onTapSearch;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
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
                  '${Strings.deliverTo.tr} ',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 14.sp(context),
                    fontFamily: 'Geist',
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Text(
                    address.isEmpty ? Strings.noAddressAdded.tr : address,
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
                    hintText: Strings.search.tr,
                    prefixIcon: Assets.icons.search02.path,
                    prefixIconColor: const Color(0xFFACACAC),
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
                    if (cartItemsCount > 0)
                      Positioned(
                        top: -2.h(context),
                        right: -2.w(context),
                        child: Container(
                          constraints: BoxConstraints(
                            minWidth: 18.w(context),
                            minHeight: 18.h(context),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w(context),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20.r(context)),
                            border: Border.all(
                              color: Colors.white,
                              width: 0,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            cartItemsCount > 99 ? '99+' : '$cartItemsCount',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                  color: Colors.white,
                                  fontSize: 10.sp(context),
                                  fontWeight: FontWeight.w700,
                                  height: 1,
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
