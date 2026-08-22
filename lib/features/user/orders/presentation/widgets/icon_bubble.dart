import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class IconBubble extends StatelessWidget {
  final IconData icon;
  final Color? background;
  final Color? iconColor;
  final double size;

  const IconBubble({
    super.key,
    required this.icon,
    this.background,
    this.iconColor,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background ?? const Color(0xFFF1F1F3),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: size * 0.5, color: iconColor ?? Colors.black54),
    );
  }
}