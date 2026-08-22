import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/core/constants/app_strings.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/profile/presentation/controller/profile_controller.dart';
import 'package:hoodz/gen/assets.gen.dart';

class ProfileHeader extends GetView<ProfileController> {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Obx(() {
      final user = controller.userData;
      final profileAvatar = user?.profileAvatar;
      final displayName = user?.name?.trim().isNotEmpty == true
          ? user!.name!
          : 'User';
      final displayAddress = controller.currentAddress.value.trim().isNotEmpty
          ? controller.currentAddress.value
          : 'Address not added';

      return Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: width,
                padding: EdgeInsets.fromLTRB(
                  20.w(context),
                  46.h(context),
                  20.w(context),
                  70.h(context),
                ),
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/background02.jpg'),
                  ),
                  color: LightThemeColors.primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(36.h(context)),
                    bottomRight: Radius.circular(36.h(context)),
                  ),
                ),
                child: Column(
                  children: [
                    CrashSafeImage(
                      Assets.images.logo.path,
                      height: 48.h(context),
                    ),
                    SizedBox(height: 14.h(context)),
                    Text(
                      'My Profile',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: LightThemeColors.backgroundColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp(context),
                      ),
                    ),
                    Text(
                      'Manage your personal information',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: LightThemeColors.backgroundColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 13.sp(context),
                      ),
                    ),
                    SizedBox(height: 10.h(context)),
                  ],
                ),
              ),
              Positioned(
                bottom: -52.h(context),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: EdgeInsets.all(4.w(context)),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 56.h(context),
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: NetworkImage(
                          profileAvatar ?? AppStrings.demoImageUrl,
                        ),
                      ),
                    ),
                    // Positioned(
                    //   right: 0,
                    //   bottom: 4.h(context),
                    //   child: Container(
                    //     height: 32.h(context),
                    //     width: 32.h(context),
                    //     padding: EdgeInsets.all(6.w(context)),
                    //     decoration: BoxDecoration(
                    //       color: LightThemeColors.primaryColor,
                    //       shape: BoxShape.circle,
                    //       border: Border.all(
                    //         color: Colors.white,
                    //         width: 2.w(context),
                    //       ),
                    //     ),
                    //     child: CrashSafeImage(Assets.icons.camera.path),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 56.h(context)),
          Text(
            displayName,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 22.sp(context),
              fontWeight: FontWeight.w700,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w(context)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CrashSafeImage(
                  Assets.icons.location02.path,
                  height: 14.h(context),
                  width: 14.w(context),
                  color: Colors.grey.shade600,
                ),
                SizedBox(width: 6.w(context)),
                Flexible(
                  child: Text(
                    displayAddress,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 13.sp(context),
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
