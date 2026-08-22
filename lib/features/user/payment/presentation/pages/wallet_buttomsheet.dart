import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/core/widgets/custom_text_field.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/buttom_sheet_payment_option.dart';

class AddBalanceBottomSheetContent extends StatefulWidget {
  const AddBalanceBottomSheetContent({super.key});

  @override
  State<AddBalanceBottomSheetContent> createState() =>
      _AddBalanceBottomSheetContentState();
}

class _AddBalanceBottomSheetContentState
    extends State<AddBalanceBottomSheetContent> {
  late final TextEditingController _amountController;
  int _selectedMethod = 0;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: '2350');
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Add Balance',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 18.sp(context),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2F2F2F),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, size: 22),
                ),
              ],
            ),
            SizedBox(height: 16.h(context)),
            Text(
              'Amount',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp(context),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2F2F2F),
              ),
            ),
            SizedBox(height: 10.h(context)),
            CustomTextField(borderRadius: 10, hintText: 'Enter amount'),
            SizedBox(height: 10.h(context)),
            Text(
              'Quick Add:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp(context),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2F2F2F),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [100, 250, 500, 1000].map((value) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () {
                        setState(
                          () => _amountController.text = value.toString(),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.h(context)),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFECECEC)),
                        ),
                        child: Text(
                          '+$value',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontSize: 14.sp(context),
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF2F2F2F),
                              ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16.h(context)),
            Text(
              'Select Payment Method',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp(context),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2F2F2F),
              ),
            ),
            const SizedBox(height: 10),
            BottomSheetPaymentOption(
              isSelected: _selectedMethod == 0,
              title: 'Visa **** **** **** 1111',
              subtitle: 'Saved Card',
              leading: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF293DA8),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'VISA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              onTap: () => setState(() => _selectedMethod = 0),
            ),
            const SizedBox(height: 12),
            BottomSheetPaymentOption(
              isSelected: _selectedMethod == 1,
              title: 'Credit / Debit Card',
              subtitle: 'Pay via Paymob Gateway',
              leading: const SizedBox.shrink(),
              onTap: () => setState(() => _selectedMethod = 1),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F6FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 18, color: Color(0xFF4987FF)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Your wallet balance will be updated instantly after successful payment.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.45,
                        color: Color(0xFF4987FF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Pay Now',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
