import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
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
  String _inventoryType = '';
  List<String> _sizes = [];
  List<cart_model.Color> _colors = [];
  String? _selectedSize;
  int? _selectedColorIndex;

  @override
  void initState() {
    super.initState();
    _inventoryType = _normalizeString(widget.item.product?.inventoryType)
            ?.toLowerCase() ??
        '';
    _sizes = _buildAvailableSizes();
    _selectedSize = _resolveInitialSelectedSize();
    _colors = _buildAvailableColors(sizeFilter: _selectedSize);
    _selectedColorIndex = _resolveSelectedColorIndex(_colors);
  }

  String? _normalizeString(dynamic value) {
    final normalized = value?.toString().trim();
    return (normalized == null || normalized.isEmpty) ? null : normalized;
  }

  List<cart_model.Variant> _variants() {
    return widget.item.product?.variants ?? const <cart_model.Variant>[];
  }

  String? _variantSize(cart_model.Variant variant) {
    return _normalizeString(variant.size);
  }

  cart_model.Color? _variantColor(cart_model.Variant variant) {
    final code = _normalizeString(variant.color?.code);
    final name = _normalizeString(variant.color?.name);
    if (code == null || name == null) {
      return null;
    }

    return cart_model.Color(code: code, name: name);
  }

  List<String> _buildAvailableSizes() {
    if (_inventoryType != 'size_color') {
      return const <String>[];
    }

    final sizes = <String>[];
    for (final variant in _variants()) {
      final size = _variantSize(variant);
      if (size != null && !sizes.contains(size)) {
        sizes.add(size);
      }
    }
    return sizes;
  }

  String? _resolveInitialSelectedSize() {
    if (_inventoryType != 'size_color' || _sizes.isEmpty) {
      return null;
    }

    final currentSize = _normalizeString(widget.item.size);
    if (currentSize != null && _sizes.contains(currentSize)) {
      return currentSize;
    }

    return _sizes.first;
  }

  List<cart_model.Color> _buildAvailableColors({String? sizeFilter}) {
    if (_inventoryType == 'single') {
      return const <cart_model.Color>[];
    }

    final colors = <cart_model.Color>[];
    for (final variant in _variants()) {
      final variantSize = _variantSize(variant);
      if (_inventoryType == 'size_color' &&
          sizeFilter != null &&
          variantSize != sizeFilter) {
        continue;
      }

      final color = _variantColor(variant);
      if (color == null) {
        continue;
      }

      final key = '${color.code?.toLowerCase()}|${color.name?.toLowerCase()}';
      final exists = colors.any(
        (item) =>
            '${item.code?.toLowerCase()}|${item.name?.toLowerCase()}' == key,
      );
      if (!exists) {
        colors.add(color);
      }
    }

    return colors;
  }

  int? _resolveSelectedColorIndex(List<cart_model.Color> colors) {
    if (colors.isEmpty) {
      return null;
    }

    final currentColorName = widget.item.color?.name?.trim();
    final currentColorCode = widget.item.color?.code?.trim();

    if (currentColorName != null || currentColorCode != null) {
      final index = colors.indexWhere((option) {
        final matchesName = currentColorName != null &&
            option.name?.toLowerCase() == currentColorName.toLowerCase();
        final matchesCode = currentColorCode != null &&
            option.code?.toLowerCase() == currentColorCode.toLowerCase();
        return matchesName || matchesCode;
      });

      if (index >= 0) {
        return index;
      }
    }

    return 0;
  }

  List<cart_model.Color> _currentColors() {
    if (_inventoryType == 'size_color') {
      return _colors;
    }
    return _colors;
  }

  cart_model.Variant? _selectedVariant() {
    final selectedColors = _currentColors();
    final selectedColor = _selectedColorIndex == null ||
            _selectedColorIndex! < 0 ||
            _selectedColorIndex! >= selectedColors.length
        ? null
        : selectedColors[_selectedColorIndex!];

    for (final variant in _variants()) {
      final variantSize = _variantSize(variant);
      final variantColor = _variantColor(variant);

      final sizeMatches = _inventoryType == 'size_color'
          ? variantSize == _selectedSize
          : true;
      final colorMatches = selectedColor == null
          ? true
          : variantColor != null &&
              variantColor.code?.toLowerCase() ==
                  selectedColor.code?.toLowerCase() &&
              variantColor.name?.toLowerCase() ==
                  selectedColor.name?.toLowerCase();

      if (sizeMatches && colorMatches) {
        return variant;
      }
    }

    return null;
  }

  int _selectedQuantity() {
    final variant = _selectedVariant();
    if (variant != null) {
      return variant.quantity ?? 0;
    }

    return 0;
  }

  bool get _canApplyChanges => _selectedQuantity() > 0;

  void _syncColorsForSelectedSize() {
    if (_inventoryType != 'size_color') {
      return;
    }

    _colors = _buildAvailableColors(sizeFilter: _selectedSize);
    _selectedColorIndex = _resolveSelectedColorIndex(_colors);
  }

  Future<void> _submit() async {
    if (!_canApplyChanges) {
      return;
    }

    final productId = widget.item.productId ?? widget.item.product?.id ?? '';
    if (productId.isEmpty) {
      return;
    }

    final size = _inventoryType == 'size_color' ? _selectedSize : null;
    final currentColors = _currentColors();
    final color = _selectedColorIndex == null || currentColors.isEmpty
        ? null
        : {
            'code': currentColors[_selectedColorIndex!].code ?? '',
            'name': currentColors[_selectedColorIndex!].name ?? '',
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
    final currentColors = _currentColors();

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
                  Strings.editItem.tr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 18.sp(context),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF393939),
                  ),
                ),
                SizedBox(height: 8.h(context)),
                Text(
                  widget.item.product?.title ?? Strings.unnamedProduct.tr,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp(context),
                    color: const Color(0xFF707070),
                  ),
                ),
                SizedBox(height: 16.h(context)),
                if (_inventoryType == 'size_color' && _sizes.isNotEmpty) ...[
                  Text(
                    Strings.size.tr,
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
                                _syncColorsForSelectedSize();
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 16.h(context)),
                ] else if (_inventoryType == 'size_color') ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w(context)),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(12.r(context)),
                      border: Border.all(color: const Color(0xFFEAEAEA)),
                    ),
                    child: Text(Strings.notAvailable.tr),
                  ),
                  SizedBox(height: 16.h(context)),
                ],
                if (_inventoryType != 'single' && currentColors.isNotEmpty) ...[
                  Text(
                    Strings.color.tr,
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
                    children: currentColors.asMap().entries.map((entry) {
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
                ] else if (_inventoryType != 'single') ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w(context)),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(12.r(context)),
                      border: Border.all(color: const Color(0xFFEAEAEA)),
                    ),
                    child: Text(Strings.noColorAvailable.tr),
                  ),
                  SizedBox(height: 16.h(context)),
                ],
                if (!_canApplyChanges) ...[
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.h(context)),
                    child: Text(
                      Strings.outOfStock.tr,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 13.sp(context),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFEF4444),
                      ),
                    ),
                  ),
                ],
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: Strings.cancel.tr,
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
                        text: Strings.applyChanges.tr,
                        enabled: _canApplyChanges,
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
