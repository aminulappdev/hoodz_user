import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hoodz/features/user/orders/data/models/payment_model.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/delivery_card_container.dart';

class PaymentSummaryCard extends StatelessWidget {
  final List<SummaryItem> items;
  final SummaryItem total;
  final String title;

  const PaymentSummaryCard({
    super.key,
    required this.items,
    required this.total,
    this.title = 'Payment summary',
  });

  @override
  Widget build(BuildContext context) {
    return DeliveryCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          for (final item in items) ...[
            SummaryRow(item: item),
            const SizedBox(height: 10),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Divider(height: 1, color: Color(0xFFEFEFEF)),
          ),
          const SizedBox(height: 10),
          SummaryRow(item: total, isTotal: true),
        ],
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final SummaryItem item;
  final bool isTotal;

  const SummaryRow({super.key, required this.item, this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: isTotal ? 16 : 14,
      fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
      color: isTotal ? Colors.black : Colors.grey.shade700,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(item.label, style: style),
        Text(item.value, style: style.copyWith(color: Colors.black87)),
      ],
    );
  }
}