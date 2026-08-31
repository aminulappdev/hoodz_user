import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/features/user/ai_assistant/presentation/pages/ai_assistant_screen.dart';
import 'package:hoodz/features/user/homescreen/presentation/pages/home_screen.dart';
import 'package:hoodz/features/user/orders/presentation/pages/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:hoodz/features/user/profile/presentation/controller/profile_controller.dart';
import 'package:hoodz/features/user/profile/presentation/pages/profile_screen.dart';
import 'package:hoodz/features/user/wishlist/presentation/pages/wishlist_screen.dart';

class UserDashboardController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  final List<String> labels = [
    Strings.home.tr,
    Strings.orders.tr,
    Strings.aiStylist.tr,
    Strings.wishlist.tr,
    Strings.profile.tr,
  ];

  final List<Widget> pages =  [
    HomeScreen(),
    OrderScreen(),
    AiAssistantScreen(
      isShowBackButton: false,
      title: Strings.aiAssistant.tr,
      subtitle: Strings.poweredByAI.tr,
    ),
    WishlistScreen(),
    ProfileScreen(),
  ];

  @override 
  void onInit() {
    super.onInit();
    Get.find<ProfileController>().loadUserProfile();
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}
