class AllProductModel {
  AllProductModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.meta,
    required this.data,
  });

  final bool? success;
  final int? statusCode;
  final String? message;
  final Meta? meta;
  final List<AllProductItemModel> data;

  factory AllProductModel.fromJson(Map<String, dynamic> json) {
    final rawData = json["data"];
    final productItems = _extractProductItems(rawData);

    return AllProductModel(
      success: json["success"],
      statusCode: json["statusCode"],
      message: json["message"],
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      data: productItems,
    );
  }

  static List<AllProductItemModel> _extractProductItems(dynamic rawData) {
    if (rawData == null) {
      return const [];
    }

    if (rawData is List) {
      return rawData
          .whereType<Map>()
          .map((item) => AllProductItemModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    if (rawData is Map<String, dynamic>) {
      final candidates = <dynamic>[
        rawData['data'],
        rawData['products'],
        rawData['allProducts'],
        rawData['items'],
        rawData['docs'],
        rawData['results'],
      ];

      for (final candidate in candidates) {
        final extracted = _extractProductItems(candidate);
        if (extracted.isNotEmpty) {
          return extracted;
        }
      }
    }

    return const [];
  }
}

class AllProductItemModel {
  AllProductItemModel({
    required this.id,
    required this.category,
    required this.title,
    required this.inventoryType,
    required this.collectionType,
    required this.brand,
    required this.brandType,
    required this.banner,
    required this.price,
    required this.discount,
    required this.discountPrice,
    required this.stock,
    required this.avgRating,
    required this.ratingCount,
    required this.inStock,
    required this.isWishlisted,
  });

  final String? id;
  final Category? category;
  final String? title;
  final String? inventoryType;
  final String? collectionType;
  final String? brand;
  final String? brandType;
  final String? banner;
  final int? price;
  final int? discount;
  final int? discountPrice;
  final int? stock;
  final dynamic avgRating;
  final int? ratingCount;
  final bool? inStock;
  final bool? isWishlisted;

  factory AllProductItemModel.fromJson(Map<String, dynamic> json) {
    return AllProductItemModel(
      id: json["_id"],
      category: json["category"] == null
          ? null
          : Category.fromJson(json["category"]),
      title: json["title"],
      inventoryType: json["inventoryType"],
      collectionType: json["collectionType"],
      brand: json["brand"],
      brandType: json["brandType"],
      banner: json["banner"],
      price: json["price"],
      discount: json["discount"],
      discountPrice: json["discountPrice"],
      stock: json["stock"],
      avgRating: json["avgRating"],
      ratingCount: json["ratingCount"],
      inStock: json["inStock"],
      isWishlisted: json["isWishlisted"],
    );
  }
}

class Category {
  Category({required this.id, required this.title});

  final String? id;
  final String? title;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json["_id"], title: json["title"]);
  }
}

class Meta {
  Meta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPage,
  });

  final int? page;
  final int? limit;
  final int? total;
  final int? totalPage;

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json["page"],
      limit: json["limit"],
      total: json["total"],
      totalPage: json["totalPage"],
    );
  }
}
