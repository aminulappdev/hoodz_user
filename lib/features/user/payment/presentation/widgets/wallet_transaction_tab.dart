import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';

class WalletTransactionTabs extends StatelessWidget {
  const WalletTransactionTabs({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [Strings.recentTransaction.tr, Strings.walletHistory.tr];

    return Column(
      children: [
        Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = selectedIndex == index;

            return Expanded(
              child: InkWell(
                onTap: () => onChanged(index),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    tabs[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? const Color(0xFFE8622C)
                          : const Color(0xFFB5B5B5),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = selectedIndex == index;

            return Expanded(
              child: Container(
                height: 1.5,
                color: isSelected
                    ? const Color(0xFFE8622C)
                    : const Color(0xFFD9D9D9),
              ),
            );
          }),
        ),
      ],
    );
  }
}
