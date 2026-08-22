import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/gen/assets.gen.dart';

class AuthBackground extends StatelessWidget {
  final bool isBack;
  final String title;
  final String subtitle;
  final Widget contentColumn;
  const AuthBackground({
    super.key,
    required this.contentColumn,
    this.isBack = false,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.images.background.path),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 60.h(context)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0.w(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isBack
                    ? Row(
                        children: [
                          CrashSafeImage(
                            Assets.icons.arrow.path,
                            height: 12,
                            width: 12,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4.w(context)),
                          Text(
                            'Back',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 17.sp(context),
                                ),
                          ),
                        ],
                      )
                    : SizedBox(height: 20.h(context)),
                SizedBox(height: 20.h(context)),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontFamily: 'Geist',
                    fontSize: 26.sp(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6.h(context)),
                SizedBox(
                  width: 350.w(context),
                  child: Text(
                    subtitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontSize: 16.sp(context),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 40.h(context)),

          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.r(context)),
                  topRight: Radius.circular(50.r(context)),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.w(context)),
                child: contentColumn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
