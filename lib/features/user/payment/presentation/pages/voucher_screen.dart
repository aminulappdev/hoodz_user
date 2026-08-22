import 'package:flutter/material.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/features/user/payment/presentation/models/voucher_model.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/voucher_card_design.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/voucher_tab.dart';

const Color kOrange = Color(0xFFE8622C);
const Color kPeach = Color(0xFFFBF1EA);

enum VoucherStatus { active, used, expired }

class VouchersScreen extends StatefulWidget {
  const VouchersScreen({super.key});

  @override
  State<VouchersScreen> createState() => _VouchersScreenState();
}

class _VouchersScreenState extends State<VouchersScreen> {
  int _selectedTabIndex = 0;
  final List<Voucher> _allVouchers = const [
    Voucher(
      title: '30% Off',
      subtitle: 'Get 30% off your first order',
      code: 'WELCOME30',
      expiryText: 'End Aug 15, 2026',
      status: VoucherStatus.active,
    ),
    Voucher(
      title: '30% Off',
      subtitle: 'Get 30% off your first order',
      code: 'WELCOME30',
      expiryText: 'End Aug 15, 2026',
      status: VoucherStatus.active,
    ),
    Voucher(
      title: '20% Off',
      subtitle: 'Used on your last order',
      code: 'SAVE20',
      expiryText: 'Used Jul 02, 2026',
      status: VoucherStatus.used,
    ),
    Voucher(
      title: '15% Off',
      subtitle: 'Seasonal offer',
      code: 'SPRING15',
      expiryText: 'Expired Jun 01, 2026',
      status: VoucherStatus.expired,
    ),
  ];

  List<Voucher> get _activeVouchers =>
      _allVouchers.where((v) => v.status == VoucherStatus.active).toList();
  List<Voucher> get _usedVouchers =>
      _allVouchers.where((v) => v.status == VoucherStatus.used).toList();
  List<Voucher> get _expiredVouchers =>
      _allVouchers.where((v) => v.status == VoucherStatus.expired).toList();

  @override
  Widget build(BuildContext context) {
    final tabs = [
      VoucherTab(label: 'Active', count: _activeVouchers.length),
      VoucherTab(label: 'Used', count: _usedVouchers.length),
      VoucherTab(label: 'Expired', count: _expiredVouchers.length),
    ];
    final visibleVouchers = switch (_selectedTabIndex) {
      0 => _activeVouchers,
      1 => _usedVouchers,
      _ => _expiredVouchers,
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(label: 'Vouchers'),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            VoucherTabBar(
              tabs: tabs,
              selectedIndex: _selectedTabIndex,
              onTap: (index) => setState(() => _selectedTabIndex = index),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: visibleVouchers.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: VoucherCardDesign(voucher: visibleVouchers[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VoucherTab {
  final String label;
  final int count;

  const VoucherTab({required this.label, required this.count});
}
