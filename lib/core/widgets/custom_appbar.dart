import 'package:flutter/material.dart';
import 'package:hoodz/core/widgets/circle_icon.dart';
import 'package:hoodz/gen/assets.gen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String label;
  final bool isShowBackButton;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.label,
    this.isShowBackButton = true,
    this.actions,
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
              padding: const EdgeInsets.only(left: 20),
              child: CircleIcon(iconPath: Assets.icons.arrow.path),
            )
          : null,
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.black,
          fontSize: 16,
          fontFamily: 'Geist',
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: actions,
    );
  }
}
