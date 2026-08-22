import 'package:flutter/material.dart';
import 'package:hoodz/features/user/payment/presentation/models/transaction_item_model.dart';

class TransactionTile extends StatelessWidget {
  final TransactionItem transaction;
  final bool showDivider;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final isWalletHistory = transaction.isWalletHistory;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isWalletHistory
                  ? _walletPlaceholder()
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: transaction.imageUrl != null
                          ? Image.network(
                              transaction.imageUrl!,
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _placeholder(),
                            )
                          : _placeholder(),
                    ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF232323),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      transaction.date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9F9F9F),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    transaction.amount,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isWalletHistory
                          ? const Color(0xFF00C853)
                          : const Color(0xFF232323),
                    ),
                  ),
                  if (!isWalletHistory) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.credit_card_outlined,
                          size: 13,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          transaction.paymentLabel,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
          if (showDivider) ...[
            const SizedBox(height: 12),
            Divider(height: 1, color: Colors.grey.shade300),
          ],
        ],
      ),
    );
  }

  Widget _walletPlaceholder() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: const Icon(
        Icons.credit_card_outlined,
        size: 18,
        color: Color(0xFFE8622C),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: const Icon(Icons.checkroom, size: 18, color: Colors.black26),
    );
  }
}
