
import 'package:flutter/material.dart';
import 'package:hoodz/features/user/orders/presentation/pages/check_out_popup.dart';

class RadioIndicator extends StatelessWidget {
  final bool isSelected;

  const RadioIndicator({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? kOrange : Colors.transparent,
        border: Border.all(
          color: isSelected ? kOrange : Colors.grey.shade400,
          width: 1.5,
        ),
      ),
      child: isSelected
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : null,
    );
  }
}