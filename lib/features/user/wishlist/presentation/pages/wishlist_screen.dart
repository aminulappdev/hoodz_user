import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/core/constants/app_strings.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/wishlist/presentation/controller/wishlist_controller.dart';
import 'package:hoodz/features/user/wishlist/presentation/widgets/wishlist_card.dart';
import 'package:hoodz/gen/assets.gen.dart';

class WishlistScreen extends GetView<WishlistController> {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final isBack = arguments?['isBack'] == true;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: isBack,
        leadingWidth: isBack ? 46.w(context) : null,
        leading: isBack
            ? Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => PageNavigationService.back(context),
                  child: SizedBox(
                    height: 32.h(context),
                    width: 32.w(context),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xffEDF1F3)),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CrashSafeImage(
                          Assets.icons.arrow.path,
                          height: 16.h(context),
                          width: 16.w(context),
                          color: Color(0xff404040),
                        ),
                      ),
                    ),
                  ),
                ), 
              )
            : null,
        title: Text(
          'Wishlist',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.h(context)),
            child: GestureDetector(
              onTap: () {
                PageNavigationService.to(context, AppRoutes.cart);
              },
              child: Text(
                '3 items',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: LightThemeColors.primaryColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w(context),
            vertical: 0.h(context),
          ), //const EdgeInsets.all(8.0),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) =>
                SizedBox(height: 8.h(context)),
            itemCount: 3,
            itemBuilder: (context, index) => WishListCard(
              imageUrl: AppStrings.demoImageUrl,
              name: 'Classic Black Blazer',
              price: '\$420',
              onTap: () {},
            ),
          ),
        ),
      ),
    );
  }
}
