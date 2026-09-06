import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:hoodz/core/services/referral/referral_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/gen/assets.gen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ReferralService>().start();
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Get.offAllNamed(AppRoutes.userDashboard);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CrashSafeImage(
          Assets.images.logo.path,
          height: 108.w(context),
          width: 240.w(context),
        ),
      ),
    );
  }
}
