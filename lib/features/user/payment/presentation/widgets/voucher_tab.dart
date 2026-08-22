import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hoodz/features/user/payment/presentation/pages/voucher_screen.dart';

class VoucherTabBar extends StatelessWidget {
  final List<VoucherTab> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const VoucherTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          for (final (index, tab) in tabs.indexed)
            Expanded(
              child: GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior
                    .opaque, // makes the whole area tappable, not just the text pixels
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        '${tab.label} (${tab.count})',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: selectedIndex == index
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: selectedIndex == index
                              ? kOrange
                              : Colors.grey.shade500,
                        ),
                      ),
                    ),
                    // AnimatedContainer so the underline slides/fades
                    // smoothly between tabs instead of snapping.
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 2.5,
                      color: selectedIndex == index
                          ? kOrange
                          : Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
