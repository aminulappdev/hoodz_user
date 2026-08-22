import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/circle_icon.dart';
import 'package:hoodz/gen/assets.gen.dart';

class CustomChatHeader extends StatelessWidget implements PreferredSizeWidget {
  final String label;
  final String? subtitle;
  final bool isShowBackButton;
  final List<Widget>? actions;

  const CustomChatHeader({
    super.key,
    required this.label,
    this.isShowBackButton = true,
    this.actions,
    this.subtitle,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      titleSpacing: 20,
      leadingWidth: isShowBackButton ? 56 : 0,
      leading: isShowBackButton
          ? Padding(
              padding: const EdgeInsets.only(left: 16),
              child: CircleIcon(iconPath: Assets.icons.arrow.path),
            )
          : null,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF222222),
              fontFamily: 'Geist',
              fontSize: 16.sp(context),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2.h(context)),
          Text(
            subtitle ?? 'Powered by AI',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFFB0B0B0),
              fontFamily: 'Poppins',
              fontSize: 10.sp(context),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      actions: actions,
    );
  }
}
