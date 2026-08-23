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
      statusCode: json["statusCode"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<WishlistItemModel>.from(
              json["data"]!.map((x) => WishlistItemModel.fromJson(x)),
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
      id: json["_id"],
      modelType: json["modelType"],
      product: json["product"] == null
          ? null
          : Product.fromJson(json["product"]),
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
  });

  final String? id;
  final String? title;
  final String? banner;
  final String? inventoryType;
  final int? price;
  final int? discount;
  final int? discountPrice;
  final int? stock;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["_id"],
      title: json["title"],
      banner: json["banner"],
      inventoryType: json["inventoryType"],
      price: json["price"],
      discount: json["discount"],
      discountPrice: json["discountPrice"],
      stock: json["stock"],
    );
  }
}
