import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/filter_option_chip.dart';
import 'package:hoodz/features/user/orders/data/models/my_cart_model.dart'
    as cart_model;
import 'package:hoodz/features/user/orders/presentation/controllers/cart_controller.dart';

class CartItemUpdateSheet extends StatefulWidget {
  const CartItemUpdateSheet({
    super.key,
    required this.item,
    required this.controller,
  });

  final cart_model.Item item;
  final CartController controller;

  @override
  State<CartItemUpdateSheet> createState() => _CartItemUpdateSheetState();
}

class _CartItemUpdateSheetState extends State<CartItemUpdateSheet> {
  late final List<String> _sizes;
  late final List<cart_model.Color> _colors;
  String? _selectedSize;
  int? _selectedColorIndex;

  @override
  void initState() {
    super.initState();
    _sizes = widget.item.product?.sizes
            .map((size) => size.trim())
            .where((size) => size.isNotEmpty)
            .toList() ??
        const <String>[];
    _colors = widget.item.product?.colors
            .where((color) {
              final code = color.code?.trim() ?? '';
              final name = color.name?.trim() ?? '';
              return code.isNotEmpty && name.isNotEmpty;
            })
            .toList() ??
        const <cart_model.Color>[];
    _selectedSize = _resolveSelectedSize(_sizes);
    _selectedColorIndex = _resolveSelectedColorIndex(_colors);
  }

  String? _resolveSelectedSize(List<String> sizes) {
    final currentSize = widget.item.size?.trim();
    if (currentSize != null && currentSize.isNotEmpty) {
      if (sizes.contains(currentSize)) {
        return currentSize;
      }
      return currentSize;
    }

    return sizes.isNotEmpty ? sizes.first : null;
  }

  int? _resolveSelectedColorIndex(List<cart_model.Color> colors) {
    final currentColorName = widget.item.color?.name?.trim();
    final currentColorCode = widget.item.color?.code?.trim();

    if (currentColorName != null || currentColorCode != null) {
      final index = colors.indexWhere((option) {
        final matchesName = currentColorName != null &&
            option.name?.toLowerCase() == currentColorName.toLowerCase();
        final matchesCode = currentColorCode != null &&
            option.code?.toLowerCase() == currentColorCode.toLowerCase();
        return matchesName == true || matchesCode == true;
      });

      if (index >= 0) {
        return index;
      }
    }

    return colors.isNotEmpty ? 0 : null;
  }

  Future<void> _submit() async {
    final productId = widget.item.productId ?? widget.item.product?.id ?? '';
    if (productId.isEmpty) {
      return;
    }

    final size = _sizes.isEmpty ? null : _selectedSize;
    final color = _selectedColorIndex == null || _colors.isEmpty
        ? null
        : {
            'code': _colors[_selectedColorIndex!].code ?? '',
            'name': _colors[_selectedColorIndex!].name ?? '',
          };

    final success = await widget.controller.updateCartItem(
      productId: productId,
      size: size,
      color: color,
      quantity: widget.item.quantity ?? 1,
    );

    if (!mounted || !success) {
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.r(context)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16.w(context),
            14.h(context),
            16.w(context),
            18.h(context),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 48.w(context),
                    height: 4.h(context),
                    margin: EdgeInsets.only(bottom: 16.h(context)),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7E7E7),
                      borderRadius: BorderRadius.circular(999.r(context)),
                    ),
                  ),
                ),
                Text(
                  'Edit Item',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 18.sp(context),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF393939),
                  ),
                ),
                SizedBox(height: 8.h(context)),
                Text(
                  widget.item.product?.title ?? 'Unnamed product',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp(context),
                    color: const Color(0xFF707070),
                  ),
                ),
                SizedBox(height: 16.h(context)),
                if (_sizes.isNotEmpty) ...[
                  Text(
                    'Size',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp(context),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF636363),
                    ),
                  ),
                  SizedBox(height: 10.h(context)),
                  Wrap(
                    spacing: 8.w(context),
                    runSpacing: 10.h(context),
                    children: _sizes
                        .map(
                          (size) => FilterOptionChip(
                            label: size,
                            isSelected: _selectedSize == size,
                            onTap: () {
                              setState(() {
                                _selectedSize = size;
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 16.h(context)),
                ] else ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w(context)),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(12.r(context)),
                      border: Border.all(color: const Color(0xFFEAEAEA)),
                    ),
                    child: const Text('No size available'),
                  ),
                  SizedBox(height: 16.h(context)),
                ],
                if (_colors.isNotEmpty) ...[
                  Text(
                    'Color',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp(context),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF636363),
                    ),
                  ),
                  SizedBox(height: 10.h(context)),
                  Wrap(
                    spacing: 8.w(context),
                    runSpacing: 10.h(context),
                    children: _colors.asMap().entries.map((entry) {
                      final index = entry.key;
                      final option = entry.value;
                      return FilterOptionChip(
                        label: option.name ?? '',
                        isSelected: _selectedColorIndex == index,
                        onTap: () {
                          setState(() {
                            _selectedColorIndex = index;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.h(context)),
                ] else ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w(context)),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(12.r(context)),
                      border: Border.all(color: const Color(0xFFEAEAEA)),
                    ),
                    child: const Text('No color available'),
                  ),
                  SizedBox(height: 16.h(context)),
                ],
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Cancel',
                        backgroundColor: const Color(0xFFF3F3F3),
                        textStyle:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 16.sp(context),
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFFF7A1A),
                            ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(width: 14.w(context)),
                    Expanded(
                      child: CustomButton(
                        text: 'Apply Changes',
                        onPressed: _submit,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
