
class TransactionItem {
  final String title;
  final String date;
  final String amount;
  final String paymentLabel;
  final String? imageUrl;
  final bool isWalletHistory;

  const TransactionItem({
    required this.title,
    required this.date,
    required this.amount,
    required this.paymentLabel,
    this.imageUrl,
    this.isWalletHistory = false,
  });
}
