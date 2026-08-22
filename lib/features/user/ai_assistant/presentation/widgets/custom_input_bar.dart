import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/gen/assets.gen.dart';

class CustomInputBar extends StatelessWidget {
  const CustomInputBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        14.w(context),
        12.h(context),
        14.w(context),
        14.h(context),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 42.h(context),
                padding: EdgeInsets.symmetric(horizontal: 12.w(context)),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1E8),
                  borderRadius: BorderRadius.circular(12.r(context)),
                ),
                child: Row(
                  children: [
                    CrashSafeImage(
                      Assets.icons.file.path,
                      width: 18.w(context),
                      height: 18.h(context),
                    ),
                    SizedBox(width: 10.w(context)),
                    Expanded(
                      child: TextField(
                        cursorColor: const Color(0xFFFF6A00),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF4D4D4D),
                          fontFamily: 'Poppins',
                          fontSize: 13.sp(context),
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: 'Ask me anything about fashion...',
                          hintStyle: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: const Color(0xFF9F8A81),
                                fontFamily: 'Poppins',
                                fontSize: 13.sp(context),
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10.w(context)),
            Container(
              height: 42.h(context),
              width: 42.w(context),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6A00),
                borderRadius: BorderRadius.circular(10.r(context)),
              ),
              child: Center(
                child: CrashSafeImage(
                  Assets.icons.send.path,
                  width: 18.w(context),
                  height: 18.h(context),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}