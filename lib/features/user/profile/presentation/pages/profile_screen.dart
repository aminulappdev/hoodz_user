import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/utils/login_required_dialog.dart';
import 'package:hoodz/core/utils/logout_session_helper.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/core/widgets/custom_text_field.dart';
import 'package:hoodz/features/user/chat/presentation/controllers/chat_system_controller.dart';
import 'package:hoodz/features/user/payment/presentation/pages/user_wallet_screen.dart';
import 'package:hoodz/features/user/profile/presentation/controller/profile_controller.dart';
import 'package:hoodz/features/user/profile/presentation/widgets/logout_button.dart';
import 'package:hoodz/features/user/profile/presentation/widgets/profile_devider.dart';
import 'package:hoodz/features/user/profile/presentation/widgets/profile_header.dart';
import 'package:hoodz/features/user/profile/presentation/widgets/profile_settings_title.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  bool _hasAccessToken() =>
      MySharedPref.getAccessToken()?.trim().isNotEmpty == true;

  Future<void> _handleLogout(BuildContext context) async {
    if (!_hasAccessToken()) {
      showLoginRequiredDialog();
      return;
    }

    Navigator.of(context, rootNavigator: true).pop();
    await clearLogoutSession();

    if (!context.mounted) {
      return;
    }

    PageNavigationService.offAll(context, AppRoutes.signIn);
  }

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
                        title: Strings.generalSettings.tr,
                        child: Column(
                          children: [
                            ProfileSettingsTile(
                              onTap: () {
                                if (!_hasAccessToken()) {
                                  showLoginRequiredDialog();
                                  return;
                                }

                                PageNavigationService.to(
                                  context,
                                  AppRoutes.editProfile,
                                );
                              },
                              icon: Icons.person_outline,
                              title: Strings.editProfile.tr,
                            ),
                            const ProfileSettingsDivider(),
                            ProfileSettingsTile(
                              onTap: () {
                                if (!_hasAccessToken()) {
                                  showLoginRequiredDialog();
                                  return;
                                }

                                PageNavigationService.to(
                                  context,
                                  AppRoutes.changePassword,
                                );
                              },
                              icon: Icons.lock_outline,
                              title: Strings.changePassword.tr,
                            ),
                            const ProfileSettingsDivider(),
                            ProfileSettingsTile(
                              icon: Icons.account_balance_wallet_outlined,
                              title: Strings.wallet.tr,
                              onTap: () {
                                if (!_hasAccessToken()) {
                                  showLoginRequiredDialog();
                                  return;
                                }

                                Get.to(UserWalletScreen());
                              },
                            ),
                            const ProfileSettingsDivider(),
                            ProfileSettingsTile(
                              onTap: () {
                                if (!_hasAccessToken()) {
                                  showLoginRequiredDialog();
                                  return;
                                }

                                if (controller.hasCustomerSupport) {
                                  PageNavigationService.to(
                                    context,
                                    AppRoutes.customerSupportMessage,
                                  );
                                  return;
                                }

                                Get.find<ChatSystemController>()
                                    .createCustomerSupportChat();
                              },
                              icon: Icons.support_agent_outlined,
                              title: Strings.customerSupport.tr,
                            ),
                            const ProfileSettingsDivider(),
                            ProfileSettingsTile(
                              onTap: () {
                                if (!_hasAccessToken()) {
                                  showLoginRequiredDialog();
                                  return;
                                }

                                PageNavigationService.to(
                                  context,
                                  AppRoutes.points,
                                );
                              },
                              icon: Icons.receipt_long_outlined,
                              title: Strings.points.tr,
                            ),
                            const ProfileSettingsDivider(),
                            ProfileSettingsTile(
                              onTap: () {
                                if (!_hasAccessToken()) {
                                  showLoginRequiredDialog();
                                  return;
                                }

                                PageNavigationService.to(
                                  context,
                                  AppRoutes.wishlist,
                                  arguments: {'isBack': true},
                                );
                              },
                              icon: Icons.favorite_border,
                              title: Strings.wishlist.tr,
                            ),
                            const ProfileSettingsDivider(),
                            ProfileSettingsTile(
                              onTap: () {
                                PageNavigationService.to(
                                  context,
                                  AppRoutes.content,
                                  arguments: {
                                    'title': Strings.termsAndConditions.tr,
                                    'key': 'userTermsAndConditions',
                                  },
                                );
                              },
                              icon: Icons.description_outlined,
                              title: Strings.termsAndConditions.tr,
                            ),
                            const ProfileSettingsDivider(),
                            ProfileSettingsTile(
                              onTap: () {
                                PageNavigationService.to(
                                  context,
                                  AppRoutes.content,
                                  arguments: {
                                    'title': Strings.privacyPolicy.tr,
                                    'key': 'userPrivacyAndPolicy',
                                  },
                                );
                              },
                              icon: Icons.privacy_tip_outlined,
                              title: Strings.privacyPolicy.tr,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 14.h(context)),
                      _buildSectionCard(
                        context,
                        title: Strings.languageSettings.tr,
                        child: Obx(
                          () => CustomTextField(
                            hintText: Strings.selectLanguage.tr,
                            hintStyle: languageTextStyle,
                            value: controller.selectedLanguage.value,
                            onChanged: controller.onLanguageChanged,
                            contentPadding: EdgeInsets.all(16.h(context)),
                            items: controller.languages
                                .map(
                                  (language) => DropdownMenuItem(
                                    value: language,
                                    child: Text(
                                      language == 'en'
                                          ? Strings.english.tr
                                          : Strings.arabic.tr,
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
                        canShowDialog: _hasAccessToken,
                        onBlocked: showLoginRequiredDialog,
                        onTap: () => _handleLogout(context),
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
