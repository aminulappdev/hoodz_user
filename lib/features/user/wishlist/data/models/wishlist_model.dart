class WishlistModel {
  WishlistModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  final bool? success;
  final int? statusCode;
  final String? message;
  final List<WishlistItemModel> data;

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      success: json["success"],
      statusCode: _toInt(json["statusCode"]),
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<WishlistItemModel>.from(
              json["data"]!.map(
                (x) => WishlistItemModel.fromJson(
                  Map<String, dynamic>.from(x),
                ),
              ),
            ),
    );
  }
}

class WishlistItemModel {
  WishlistItemModel({
    required this.id,
    required this.modelType,
    required this.product,
  });

  final String? id;
  final String? modelType;
  final Product? product;

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      id: json["_id"]?.toString(),
      modelType: json["modelType"]?.toString(),
      product: json["product"] == null
          ? null
          : Product.fromJson(Map<String, dynamic>.from(json["product"])),
    );
  }
}

class Product {
  Product({
    required this.id,
    required this.title,
    required this.banner,
    required this.inventoryType,
    required this.price,
    required this.discount,
    required this.discountPrice,
    required this.stock,
    required this.variants,
  });

  final String? id;
  final String? title;
  final String? banner;
  final String? inventoryType;
  final int? price;
  final int? discount;
  final int? discountPrice;
  final int? stock;
  final List<Variant> variants;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["_id"]?.toString(),
      title: json["title"]?.toString(),
      banner: json["banner"]?.toString(),
      inventoryType: json["inventoryType"]?.toString(),
      price: _toInt(json["price"]),
      discount: _toInt(json["discount"]),
      discountPrice: _toInt(json["discountPrice"]),
      stock: _toInt(json["stock"]),
      variants: json["variants"] == null
          ? []
          : List<Variant>.from(
              json["variants"]!.map(
                (x) => Variant.fromJson(Map<String, dynamic>.from(x)),
              ),
            ),
    );
  }
}

class Variant {
  Variant({
    required this.id,
    required this.size,
    required this.color,
    required this.quantity,
  });

  final String? id;
  final String? size;
  final Color? color;
  final int? quantity;

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json["_id"]?.toString(),
      size: json["size"]?.toString(),
      color: json["color"] == null
          ? null
          : Color.fromJson(Map<String, dynamic>.from(json["color"])),
      quantity: _toInt(json["quantity"]),
    );
  }
}

class Color {
  Color({
    required this.code,
    required this.name,
  });

  final String? code;
  final String? name;

  factory Color.fromJson(Map<String, dynamic> json) {
    return Color(
      code: json["code"]?.toString(),
      name: json["name"]?.toString(),
    );
  }
}

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
