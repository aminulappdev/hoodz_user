import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class ProfileSettingsTile extends StatelessWidget {
  const ProfileSettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 14.w(context),
          vertical: 14.h(context),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xffA2A2A2), size: 18.h(context)),
            SizedBox(width: 12.w(context)),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp(context),
                  color: const Color(0xff6F6F6F),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: const Color(0xffB5B5B5),
              size: 18.h(context),
            ),
          ],
        ),
      ),
    );
  }
}
