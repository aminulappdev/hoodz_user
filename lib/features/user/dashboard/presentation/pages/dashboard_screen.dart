import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:hoodz/features/user/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:hoodz/features/user/dashboard/presentation/widgets/dashboard_bottom_nav_bar.dart';


class UserDashboardScreen extends GetView<UserDashboardController> {
  const UserDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        body: controller.pages[controller.selectedIndex.value],
        bottomNavigationBar: UserDashboardBottomNavBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
        ),
      ),
    );
  }
}
