import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_text_field.dart';
import 'package:hoodz/features/user/payment/presentation/pages/user_wallet_screen.dart';
import 'package:hoodz/features/user/profile/presentation/controller/profile_controller.dart';
import 'package:hoodz/features/user/profile/presentation/widgets/logout_button.dart';
import 'package:hoodz/features/user/profile/presentation/widgets/profile_devider.dart';
import 'package:hoodz/features/user/profile/presentation/widgets/profile_header.dart';
import 'package:hoodz/features/user/profile/presentation/widgets/profile_settings_title.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});
  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w(context)),
      decoration: BoxDecoration(
        color: const Color(0xffFAFAFA),
        borderRadius: BorderRadius.circular(16.r(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 2.w(context), bottom: 12.h(context)),
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp(context),
                fontWeight: FontWeight.w600,
                color: const Color(0xff3A3A3A),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r(context)),
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final languageTextStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontSize: 14.sp(context),
      fontWeight: FontWeight.w400,
      color: const Color(0xff6F6F6F),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          children: [
            ProfileHeader(),
            SizedBox(height: 20.h(context)),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w(context)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildSectionCard(
                        context,
                        title: 'General settings',
                        child: Column(
                          children: [
                            ProfileSettingsTile(
                              onTap: () {
                                PageNavigationService.to(
                                  context,
                                  AppRoutes.editProfile,
                                );
                              },
                              icon: Icons.person_outline,
                              title: 'Edit Profile',
                            ),
                            const ProfileSettingsDivider(),
                            ProfileSettingsTile(
                              onTap: () {
                                PageNavigationService.to(
                                  context,
                                  AppRoutes.changePassword,
                                );
                              },
                              icon: Icons.lock_outline,
                              title: 'Change Password',
                            ),
                            const ProfileSettingsDivider(),
                            ProfileSettingsTile(
                              icon: Icons.account_balance_wallet_outlined,
                              title: 'Wallet',
                              onTap: () {
                                Get.to(UserWalletScreen());
                              },
                            ),
                            const ProfileSettingsDivider(),
                            ProfileSettingsTile(
                              onTap: () {
                                PageNavigationService.to(
                                  context,
                                  AppRoutes.points,
                                );
                              },
                              icon: Icons.receipt_long_outlined,
                              title: 'Points',
                            ),
                            const ProfileSettingsDivider(),
                            ProfileSettingsTile(
                              onTap: () {
                                PageNavigationService.to(
                                  context,
                                  AppRoutes.wishlist,
                                  arguments: {'isBack': true},
                                );
                              },
                              icon: Icons.favorite_border,
                              title: 'Wishlist',
                            ),
                            const ProfileSettingsDivider(),
                            ProfileSettingsTile(
                              onTap: () {
                                PageNavigationService.to(
                                  context,
                                  AppRoutes.content,
                                  arguments: {
                                    'title': 'Terms & Conditions',
                                    'key': 'userTermsAndConditions',
                                  },
                                );
                              },
                              icon: Icons.description_outlined,
                              title: 'Terms & Conditions',
                            ),
                            const ProfileSettingsDivider(),
                            ProfileSettingsTile(
                              onTap: () {
                                PageNavigationService.to(
                                  context,
                                  AppRoutes.content,
                                  arguments: {
                                    'title': 'Privacy Policy',
                                    'key': 'userPrivacyAndPolicy',
                                  },
                                );
                              },
                              icon: Icons.privacy_tip_outlined,
                              title: 'Privacy Policy',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 14.h(context)),
                      _buildSectionCard(
                        context,
                        title: 'Language settings',
                        child: Obx(
                          () => CustomTextField(
                            hintText: 'Select Language',
                            hintStyle: languageTextStyle,
                            value: controller.selectedLanguage.value,
                            onChanged: controller.onLanguageChanged,
                            contentPadding: EdgeInsets.all(16.h(context)),
                            items: controller.languages
                                .map(
                                  (language) => DropdownMenuItem(
                                    value: language,
                                    child: Text(
                                      language == 'en' ? 'English' : 'Bangla',
                                      style: languageTextStyle,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 14.h(context)),
                      LogoutButton(
                        onTap: () {
                          PageNavigationService.to(context, AppRoutes.signIn);
                        },
                      ),
                      SizedBox(height: 24.h(context)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
