import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class ColorPlate extends StatelessWidget {
  const ColorPlate({
    super.key,
    required this.color,
    required this.borderColor,
    required this.padding,
  });

  final Color color; 
  final Color borderColor;
  final double padding;

  @override
  Widget build(BuildContext context) {
    final bool needsContrastBorder = color.computeLuminance() > 0.85;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2.w(context)),
      ),
      child: Container(
        height: 36.h(context),
        width: 36.w(context),
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: needsContrastBorder
            ? Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1.w(context),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
