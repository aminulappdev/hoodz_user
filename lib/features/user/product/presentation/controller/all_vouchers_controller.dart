import 'package:get/get.dart';
import 'package:hoodz/features/user/payment/presentation/models/voucher_model.dart';
import 'package:hoodz/features/user/payment/presentation/pages/voucher_screen.dart';

class VoucherViewData {
  final Voucher voucher;
  final bool isUsed;
  final String? usedAtText;

  const VoucherViewData({
    required this.voucher,
    this.isUsed = false,
    this.usedAtText,
  });
}

class AllVouchersController extends GetxController {
  final RxString title = 'Shop Vouchers'.obs;

  final RxList<VoucherViewData> vouchers = <VoucherViewData>[].obs;

  void initialize(Map<String, dynamic>? arguments) {
    title.value = arguments?['title'] as String? ?? 'Shop Vouchers';
    final rawVouchers = arguments?['vouchers'];

    if (rawVouchers is List<VoucherViewData>) {
      vouchers.assignAll(rawVouchers);
      return;
    }

    if (rawVouchers is List) {
      vouchers.assignAll(
        rawVouchers.whereType<VoucherViewData>().toList(growable: false),
      );
      return;
    }

    vouchers.clear();
  }
}
