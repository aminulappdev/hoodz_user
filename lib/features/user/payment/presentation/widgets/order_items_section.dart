import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/app_cached_network_image.dart';
import 'package:hoodz/features/user/orders/data/models/order_details_model.dart'
    as order_details;
import 'package:hoodz/features/user/payment/presentation/widgets/details_section_card.dart';

class OrderItemsSection extends StatelessWidget {
  const OrderItemsSection({
    super.key,
    required this.items,
  });

  final List<order_details.Item> items;

  @override
  Widget build(BuildContext context) {
    return DetailsSectionCard(
      title: 'Order Items',
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final product = item.product;
          final quantity = item.quantity ?? 1;
          final price = item.totalPrice ?? item.price ?? 0;
          final sizeText = _formatValue(item.size, fallback: 'N/A');
          final colorText = _formatColor(item.color);

          return Padding(
            padding: EdgeInsets.only(
              bottom: index == items.length - 1 ? 0 : 12.h(context),
            ),
            child: _OrderItemTile(
              imageUrl: product?.banner,
              title: product?.title ?? 'Unnamed product',
              quantity: quantity,
              sizeText: sizeText,
              colorText: colorText,
              price: price.toDouble(),
            ),
          );
        }),
      ),
    );
  }

  String _formatValue(dynamic value, {required String fallback}) {
    final text = value == null ? null : value.toString().trim();
    if (text == null || text.isEmpty) {
      return fallback;
    }
    return text;
  }

  String _formatColor(dynamic value) {
    if (value is Map<String, dynamic>) {
      final name = value['name'] == null ? null : value['name'].toString().trim();
      if (name != null && name.isNotEmpty) {
        return name;
      }

      final code = value['code'] == null ? null : value['code'].toString().trim();
      if (code != null && code.isNotEmpty) {
        return code;
      }
    }

    final text = value == null ? null : value.toString().trim();
    return text == null || text.isEmpty ? 'N/A' : text;
  }
}

class _OrderItemTile extends StatelessWidget {
  const _OrderItemTile({
    required this.imageUrl,
    required this.title,
    required this.quantity,
    required this.sizeText,
    required this.colorText,
    required this.price,
  });

  final String? imageUrl;
  final String title;
  final int quantity;
  final String sizeText;
  final String colorText;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r(context)),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(14.r(context)),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCachedNetworkImage(
            imageUrl: imageUrl,
            imageWidth: 72.w(context),
            imageHeight: 72.w(context),
            imageFit: BoxFit.cover,
            radius: 12.r(context),
          ),
          SizedBox(width: 12.w(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14.sp(context),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF4E4E4E),
                      ),
                ),
                SizedBox(height: 6.h(context)),
                Text(
                  'Size: $sizeText   Color: $colorText',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp(context),
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF8A8A8A),
                      ),
                ),
                SizedBox(height: 8.h(context)),
                Row(
                  children: [
                    Text(
                      'Qty: ${quantity.toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 12.sp(context),
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF7A7A7A),
                          ),
                    ),
                    const Spacer(),
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14.sp(context),
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF3E3E3E),
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
