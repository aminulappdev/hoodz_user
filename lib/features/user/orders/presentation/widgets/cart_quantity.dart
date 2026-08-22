import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class QuantityButton extends StatelessWidget {
  const QuantityButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 28.h(context),
        width: 28.w(context),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18.sp(context), color: const Color(0xff757575)),
      ),
    );
  }
}
