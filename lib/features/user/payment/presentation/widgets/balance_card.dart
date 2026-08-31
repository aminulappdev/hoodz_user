import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class BalanceCard extends StatelessWidget {
  final String label;
  final String amount;
  final Widget? trailing;
  final VoidCallback? onTapAddBalance;

  const BalanceCard({
    super.key,
    required this.label,
    required this.amount,
    this.trailing,
    this.onTapAddBalance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEFEFEF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextTheme.of(context).bodyMedium?.copyWith(
                        fontSize: 14.sp(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      amount,
                      style: TextTheme.of(context).bodyMedium?.copyWith(
                        fontSize: 20.sp(context),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              trailing ??
                  Container(
                    width: 34.h(context),
                    height: 34.h(context),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFF0F0F0)),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 18,
                      color: Color(0xFF444444),
                    ),
                  ),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: onTapAddBalance,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10.h(context)),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3EC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFFD3BF)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 18.h(context),
                    color: const Color(0xFFE8622C),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    Strings.addBalance.tr,
                    style: TextStyle(
                      fontSize: 16.sp(context),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFE8622C),
                    ),
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
