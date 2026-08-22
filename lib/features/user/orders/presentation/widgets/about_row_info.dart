
import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class AboutInfoRow extends StatelessWidget {
  const AboutInfoRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h(context)),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xffE9E9E9)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp(context),
                color: const Color(0xff8A8A8A),
              ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp(context),
              fontWeight: FontWeight.w500,
              color: const Color(0xff4A4A4A),
            ),
          ),
        ],
      ),
    );
  }
}
