import 'package:hoodz/features/user/payment/presentation/pages/voucher_screen.dart';

class Voucher {
  final String title;
  final String subtitle;
  final String code;
  final String expiryText;
  final VoucherStatus status;

  const Voucher({
    required this.title,
    required this.subtitle,
    required this.code,
    required this.expiryText,
    required this.status,
  });
}