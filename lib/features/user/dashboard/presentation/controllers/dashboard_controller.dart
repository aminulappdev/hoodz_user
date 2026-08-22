import 'package:get/get.dart';
import 'package:hoodz/features/user/ai_assistant/presentation/pages/ai_assistant_screen.dart';
import 'package:hoodz/features/user/homescreen/presentation/pages/home_screen.dart';
import 'package:hoodz/features/user/orders/presentation/pages/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:hoodz/features/user/profile/presentation/controller/profile_controller.dart';
import 'package:hoodz/features/user/profile/presentation/pages/profile_screen.dart';
import 'package:hoodz/features/user/wishlist/presentation/pages/wishlist_screen.dart';

class UserDashboardController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  final List<String> labels = const [
    'Home',
    'Orders',
    'AI Stylist',
    'Wishlist',
    'Profile',
  ];

  final List<Widget> pages = const [
    HomeScreen(),
    OrderScreen(),
    AiAssistantScreen(
      isShowBackButton: false,
      title: 'Ai Assistant',
      subtitle: 'Powered by AI',
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
