import 'package:flutter/material.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/core/constants/app_strings.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/voucher_card.dart';
import 'package:hoodz/features/user/payment/presentation/models/payment_card_model.dart';
import 'package:hoodz/features/user/payment/presentation/models/transaction_item_model.dart';
import 'package:hoodz/features/user/payment/presentation/pages/wallet_buttomsheet.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/balance_card.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/payment_chip.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/selection_header.dart';
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
  int _selectedTabIndex = 0;

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
    final cards = <PaymentCard>[
      const PaymentCard(
        brand: 'PayPal',
        maskedNumber: '2350 **** **** **45',
        expiry: '03/30',
      ),
      const PaymentCard(
        brand: 'Stripe',
        maskedNumber: '2350 **** **** **45',
        expiry: '03/30',
      ),
    ];

    final recentTransactions = <TransactionItem>[
      for (int i = 0; i < 4; i++)
        const TransactionItem(
          imageUrl: AppStrings.demoImageUrl,
          title: 'Classic Black Blazer...',
          date: 'Dec 25, 10:45 AM',
          amount: '- \$250',
          paymentLabel: 'Card',
        ),
    ];

    final walletHistory = <TransactionItem>[
      TransactionItem(
        title: 'Visa **** 1111',
        date: 'Dec 28, 2024 - 09:14 AM',
        amount: '+500',
        paymentLabel: '',
        isWalletHistory: true,
      ),
      TransactionItem(
        title: 'Mastercard **** 4521',
        date: 'Dec 28, 2024 - 09:14 AM',
        amount: '+1500',
        paymentLabel: '',
        isWalletHistory: true,
      ),
      TransactionItem(
        title: 'Visa **** 1111',
        date: 'Dec 28, 2024 - 09:14 AM',
        amount: '+2000',
        paymentLabel: '',
        isWalletHistory: true,
      ),
      TransactionItem(
        title: 'Mastercard **** 4521',
        date: 'Dec 28, 2024 - 09:14 AM',
        amount: '+500',
        paymentLabel: '',
        isWalletHistory: true,
      ),
    ];

    final visibleTransactions = _selectedTabIndex == 0
        ? recentTransactions
        : walletHistory;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(label: 'Wallet'),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          children: [
            BalanceCard(
              label: 'Available Balance',
              amount: '\$1,200',
              onTapAddBalance: () => _showAddBalanceSheet(context),
            ),
            SizedBox(height: 16.h(context)),
            SectionHeaderRow(
              title: 'Payment Method',
              actionLabel: 'Manage',
              onActionTap: () {
                PageNavigationService.to(context, AppRoutes.paymentMethod);
              },
            ),
            SizedBox(height: 12.h(context)),
            SizedBox(
              height: 78,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: cards.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) =>
                    PaymentCardChip(card: cards[index]),
              ),
            ),
            SizedBox(height: 24.h(context)),
            WalletTransactionTabs(
              selectedIndex: _selectedTabIndex,
              onChanged: (index) {
                setState(() => _selectedTabIndex = index);
              },
            ),
            SizedBox(height: 12.h(context)),
            TransactionsCard(transactions: visibleTransactions),
            SizedBox(height: 24.h(context)),
            SectionHeaderRow(title: 'Vouchers'),
            SizedBox(height: 12.h()),
            VoucherCardHomeScreen(),
            SizedBox(height: 16.h()),
          ],
        ),
      ),
    );
  }
}
