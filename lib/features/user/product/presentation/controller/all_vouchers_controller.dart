import 'package:get/get.dart';
import 'package:hoodz/features/user/payment/presentation/models/voucher_model.dart';
import 'package:hoodz/features/user/payment/presentation/pages/voucher_screen.dart';

class AllVouchersController extends GetxController {
  final RxString title = 'Shop Vouchers'.obs;

  final List<Voucher> vouchers = const [
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
      title: '30% Off',
      subtitle: 'Get 30% off your first order',
      code: 'WELCOME30',
      expiryText: 'End Aug 15, 2026',
      status: VoucherStatus.active,
    ),
  ];

  void initialize(Map<String, dynamic>? arguments) {
    title.value = arguments?['title'] as String? ?? 'Shop Vouchers';
  }
}
