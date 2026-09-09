import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/login_required_dialog.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/ai_assistant/presentation/controller/ai_assistant_controller.dart';
import 'package:hoodz/features/user/ai_assistant/presentation/pages/ai_assistant_screen.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/home_screen_controller.dart';
import 'package:hoodz/features/user/homescreen/presentation/pages/home_screen.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/my_orders_controller.dart';
import 'package:hoodz/features/user/orders/presentation/pages/order_screen.dart';
import 'package:hoodz/features/user/profile/presentation/controller/profile_controller.dart';
import 'package:hoodz/features/user/profile/presentation/pages/profile_screen.dart';
import 'package:hoodz/features/user/wishlist/presentation/controller/wishlist_controller.dart';
import 'package:hoodz/features/user/wishlist/presentation/pages/wishlist_screen.dart';

class UserDashboardController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final RxSet<int> visitedIndexes = <int>{0}.obs;
  final Map<int, Widget> _pageCache = {};

  final List<String> labels = [
    Strings.home.tr,
    Strings.orders.tr,
    Strings.aiStylist.tr,
    Strings.wishlist.tr,
    Strings.profile.tr,
  ];

  List<Widget> get pages => List.generate(
    labels.length,
    (index) => visitedIndexes.contains(index)
        ? _pageCache.putIfAbsent(index, () => _buildPage(index))
        : const SizedBox.shrink(),
  );

  void changeTab(int index) {
    final hasAccessToken = _hasAccessToken;
    if (_isLoginRequiredTab(index) && !hasAccessToken) {
      _showLoginRequiredDialog();
      return;
    }

    final wasVisited = visitedIndexes.contains(index);
    visitedIndexes.add(index);
    selectedIndex.value = index;

    if (wasVisited) {
      _refreshTab(index, hasAccessToken: hasAccessToken);
    } else if (index == 4) {
      // Load profile data as soon as the profile tab is opened for the first time.
      Get.find<ProfileController>().loadUserProfile();
    }
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const OrderScreen();
      case 2:
        return AiAssistantScreen(
          isShowBackButton: false,
          title: Strings.aiAssistant.tr,
          subtitle: Strings.poweredByAI.tr, 
        );
      case 3:
        return const WishlistScreen();
      case 4:
        return ProfileScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  bool get _hasAccessToken {
    final accessToken = MySharedPref.getAccessToken();
    return accessToken?.trim().isNotEmpty == true;
  }

  bool _isLoginRequiredTab(int index) {
    return index == 1 || index == 2 || index == 3;
  }

  void _refreshTab(int index, {required bool hasAccessToken}) {
    if (_isLoginRequiredTab(index) && !hasAccessToken) {
      _showLoginRequiredDialog();
      return;
    }

    switch (index) {
      case 0:
        Get.find<HomeScreenController>().getUserMeta(force: true);
        break;
      case 1:
        Get.find<MyOrdersController>().fetchOrders(forceRefresh: true);
        break;
      case 2:
        Get.find<AiAssistantController>().loadMessages();
        break;
      case 3:
        Get.find<WishlistController>().getWishlist();
        break;
      case 4:
        Get.find<ProfileController>().loadUserProfile(force: true);
        break;
    }
  }

  void _showLoginRequiredDialog() {
    showLoginRequiredDialog();
  }
}
