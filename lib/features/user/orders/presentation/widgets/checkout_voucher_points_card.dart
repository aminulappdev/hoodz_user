import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/widgets/custom_text_field.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/checkout_section_card.dart';

class CheckoutVoucherPointsCard extends StatelessWidget {
  const CheckoutVoucherPointsCard({
    super.key,
    required this.voucherController,
    required this.isPointsEnabled,
    required this.isPointsToggleEnabled,
    required this.onPointsChanged,
    required this.onInvalidPointsAttempt,
    required this.onApplyVoucher,
    required this.availablePointsLabel,
  });

  final TextEditingController voucherController;
  final bool isPointsEnabled;
  final bool isPointsToggleEnabled;
  final ValueChanged<bool> onPointsChanged;
  final VoidCallback onInvalidPointsAttempt;
  final VoidCallback onApplyVoucher;
  final String availablePointsLabel;

  @override
  Widget build(BuildContext context) {
    return CheckoutSectionCard(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${Strings.vouchers.tr} & ${Strings.points.tr}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF202020),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: onApplyVoucher,
                child: Text(
                  Strings.addVoucher.tr,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: LightThemeColors.primaryColor,
                    decoration: TextDecoration.underline,
                    decorationColor: LightThemeColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 10),
          CustomTextField(
            controller: voucherController,
            hintText: Strings.enterVoucherCode.tr,
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.usePoints.tr,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF353535),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      availablePointsLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (!isPointsToggleEnabled) {
                    onInvalidPointsAttempt();
                    return;
                  }
                  onPointsChanged(!isPointsEnabled);
                },
                child: SizedBox(
                  height: 40,
                  width: 72,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Switch.adaptive(
                      value: isPointsEnabled,
                      onChanged: isPointsToggleEnabled
                          ? onPointsChanged
                          : (_) => onInvalidPointsAttempt(),
                      inactiveThumbColor: Colors.black45,
                      inactiveTrackColor: Colors.grey.shade300,
                      activeColor: const Color(0xFFE8622C),
                    ),
                  ),
                ),
              ),
            ],
          ), 
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => PageNavigationService.to(
              context,
              AppRoutes.points,
            ),
            child: Text(
              Strings.aboutCoinRules.tr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: const Color(0xFFE8622C),
                decorationColor: const Color(0xFFE8622C),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
