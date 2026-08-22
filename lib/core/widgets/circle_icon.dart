import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget {
  final VoidCallback? onTap;
  final String iconPath;
  final double size;
  final double iconSize;
  const CircleIcon({
    super.key,
    this.onTap,
    required this.iconPath,
    this.size = 16,
    this.iconSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.pop(context),
      child: CircleAvatar(
        radius: size,
        backgroundColor: const Color(0xFFEDF1F3),
        child: CircleAvatar(
          radius: size - 1,
          backgroundColor: Colors.white,
          child: CrashSafeImage(
            iconPath,
            color: const Color(0xFF404040),
            height: iconSize,
          ),
        ),
      ),
    );
  }
}
