import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/payment_transaction_controller.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/wallet_transaction_controller.dart';
import 'package:hoodz/features/user/payment/presentation/pages/wallet_buttomsheet.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/balance_card.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/transaction_card.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/wallet_transaction_tab.dart';

const Color kOrange = Color(0xFFE8622C);
const Color kPeach = Color(0xFFFBF1EA);

class UserWalletScreen extends StatefulWidget {
  const UserWalletScreen({super.key});

  @override
  State<UserWalletScreen> createState() => _UserWalletScreenState();
}

class _UserWalletScreenState extends State<UserWalletScreen> {
  late final WalletTransactionController _walletController;
  late final PaymentTransactionController _paymentController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _walletController = Get.find<WalletTransactionController>();
    _paymentController = Get.find<PaymentTransactionController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _walletController.fetchWalletTransactions();
      _paymentController.fetchPaymentTransactions();
    });
  }

  Future<void> _showAddBalanceSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddBalanceBottomSheetContent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(label: 'Wallet'),
      body: SafeArea(
        child: Obx(() {
          final recentTransactions = _paymentController.recentTransactionItems;
          final walletHistory = _walletController.walletHistoryItems;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                child: BalanceCard(
                  label: 'Available Balance',
                  amount: _walletController.walletBalanceText,
                  onTapAddBalance: () => _showAddBalanceSheet(context),
                ),
              ),
              SizedBox(height: 16.h(context)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: WalletTransactionTabs(
                  selectedIndex: _selectedTabIndex,
                  onChanged: (index) {
                    setState(() => _selectedTabIndex = index);
                  },
                ),
              ),
              SizedBox(height: 12.h(context)),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                  children: [
                    // SectionHeaderRow(
                    //   title: 'Payment Method',
                    //   actionLabel: 'Manage',
                    //   onActionTap: () {
                    //     PageNavigationService.to(context, AppRoutes.paymentMethod);
                    //   },
                    // ),
                    // SizedBox(height: 12.h(context)),
                    // SizedBox(
                    //   height: 78,
                    //   child: ListView.separated(
                    //     scrollDirection: Axis.horizontal,
                    //     itemCount: cards.length,
                    //     separatorBuilder: (_, __) => const SizedBox(width: 12),
                    //     itemBuilder: (context, index) =>
                    //         PaymentCardChip(card: cards[index]),
                    //   ),
                    // ),
                    // SizedBox(height: 24.h(context)),
                    if (_selectedTabIndex == 0 &&
                        _paymentController.isLoading.value &&
                        recentTransactions.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (_selectedTabIndex == 0 &&
                        recentTransactions.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          'No recent transactions found.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      )
                    else if (_selectedTabIndex == 1 &&
                        _walletController.isLoading.value &&
                        walletHistory.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (_selectedTabIndex == 1 && walletHistory.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          'No wallet history found.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      )
                    else
                      TransactionsCard(
                        transactions: _selectedTabIndex == 0
                            ? recentTransactions
                            : walletHistory,
                      ),
                    SizedBox(height: 24.h(context)),
                    // SectionHeaderRow(title: 'Vouchers'),
                    // SizedBox(height: 12.h()),
                    // VoucherCardHomeScreen(),
                    // SizedBox(height: 16.h()),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
