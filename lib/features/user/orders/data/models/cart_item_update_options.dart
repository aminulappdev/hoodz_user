class CartItemUpdateOptions {
  CartItemUpdateOptions({
    required this.sizes,
    required this.colors,
  });

  final List<String> sizes;
  final List<CartColorOption> colors;
}

class CartColorOption {
  CartColorOption({
    required this.code,
    required this.name,
  });

  final String code;
  final String name;

  Map<String, String> get payload => {'code': code, 'name': name};

  factory CartColorOption.fromDynamic(dynamic value) {
    if (value is Map<String, dynamic>) {
      final code = value['code']?.toString().trim() ?? '';
      final name = value['name']?.toString().trim() ?? '';
      return CartColorOption(code: code, name: name);
    }

    if (value is Map) {
      final data = Map<String, dynamic>.from(value);
      final code = data['code']?.toString().trim() ?? '';
      final name = data['name']?.toString().trim() ?? '';
      return CartColorOption(code: code, name: name);
    }

    final text = value?.toString().trim() ?? '';
    return CartColorOption(code: text, name: text);
  }
}
