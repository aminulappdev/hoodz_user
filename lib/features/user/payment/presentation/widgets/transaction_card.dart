import 'package:flutter/widgets.dart';
import 'package:hoodz/features/user/payment/presentation/models/transaction_item_model.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/transaction_tile.dart' show TransactionTile;

class TransactionsCard extends StatelessWidget {
  final List<TransactionItem> transactions;

  const TransactionsCard({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Column(
        children: [
          for (final (index, tx) in transactions.indexed)
            TransactionTile(
              transaction: tx,
              showDivider: index != transactions.length - 1,
            ),
        ],
      ),
    );
  }
}
