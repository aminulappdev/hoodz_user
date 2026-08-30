class ProductDetailsModel {
  ProductDetailsModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  final bool? success;
  final dynamic statusCode;  
  final String? message;
  final ProductData? data;
 
  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      success: json["success"],
      statusCode: json["statusCode"],
      message: json["message"],
      data: json["data"] == null ? null : ProductData.fromJson(json["data"]),
    );
  }

  ProductDetailsModel copyWith({
    bool? success,
    dynamic statusCode,
    String? message,
    ProductData? data,
  }) {
    return ProductDetailsModel(
      success: success ?? this.success,
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}

class ProductData {
  ProductData({
    required this.product,
    required this.vendor,
    required this.category,
    required this.shopRules,
    required this.similarProducts,
    required this.vouchers,
    required this.reviews,
    required this.hasPurchase,
    required this.hasReviewSubmit,
    required this.isWishlisted,
  });

  final Product? product;
  final Vendor? vendor;
  final Category? category;
  final ShopRules? shopRules;
  final List<SimilarProduct> similarProducts;
  final List<Voucher> vouchers;
  final List<Review> reviews;
  final bool? hasPurchase;
  final bool? hasReviewSubmit;
  final bool? isWishlisted;

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      product: json["product"] == null
          ? null
          : Product.fromJson(json["product"]),
      vendor: json["vendor"] == null ? null : Vendor.fromJson(json["vendor"]),
      category: json["category"] == null
          ? null
          : Category.fromJson(json["category"]),
      shopRules: json["shopRules"] == null
          ? null
          : ShopRules.fromJson(json["shopRules"]),
      similarProducts: json["similarProducts"] == null
          ? []
          : List<SimilarProduct>.from(
              json["similarProducts"]!.map((x) => SimilarProduct.fromJson(x)),
            ),
      vouchers: json["vouchers"] == null
          ? []
          : List<Voucher>.from(
              json["vouchers"]!.map((x) => Voucher.fromJson(x)),
            ),
      reviews: json["reviews"] == null
          ? []
          : List<Review>.from(json["reviews"]!.map((x) => Review.fromJson(x))),
      hasPurchase: json["hasPurchase"],
      hasReviewSubmit: json["hasReviewSubmit"],
      isWishlisted: json["isWishlisted"],
    );
  }

  ProductData copyWith({
    Product? product,
    Vendor? vendor,
    Category? category,
    ShopRules? shopRules,
    List<SimilarProduct>? similarProducts,
    List<Voucher>? vouchers,
    List<Review>? reviews,
    bool? hasPurchase,
    bool? hasReviewSubmit,
    bool? isWishlisted,
  }) {
    return ProductData(
      product: product ?? this.product,
      vendor: vendor ?? this.vendor,
      category: category ?? this.category,
      shopRules: shopRules ?? this.shopRules,
      similarProducts: similarProducts ?? this.similarProducts,
      vouchers: vouchers ?? this.vouchers,
      reviews: reviews ?? this.reviews,
      hasPurchase: hasPurchase ?? this.hasPurchase,
      hasReviewSubmit: hasReviewSubmit ?? this.hasReviewSubmit,
      isWishlisted: isWishlisted ?? this.isWishlisted,
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

class Product {
  Product({
    required this.id,
    required this.sku,
    required this.inventoryType,
    required this.brand,
    required this.collectionType,
    required this.brandType,
    required this.title,
    required this.description,
    required this.banner,
    required this.images,
    required this.price,
    required this.discount,
    required this.discountPrice,
    required this.sizes,
    required this.colors,
    required this.stock,
    required this.avgRating,
    required this.ratingCount,
    required this.sold,
    required this.variants,
    required this.seo,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? sku;
  final String? inventoryType;
  final String? brand;
  final String? collectionType;
  final String? brandType;
  final String? title;
  final String? description;
  final String? banner;
  final List<String> images;
  final dynamic price;
  final dynamic discount;
  final dynamic discountPrice;
  final List<dynamic> sizes;
  final List<dynamic> colors;
  final dynamic stock;
  final dynamic avgRating;
  final dynamic ratingCount;
  final dynamic sold;
  final List<dynamic> variants;
  final Seo? seo;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["_id"],
      sku: json["sku"],
      inventoryType: json["inventoryType"],
      brand: json["brand"],
      collectionType: json["collectionType"],
      brandType: json["brandType"],
      title: json["title"],
      description: json["description"],
      banner: json["banner"],
      images: json["images"] == null
          ? []
          : List<String>.from(json["images"]!.map((x) => x)),
      price: json["price"],
      discount: json["discount"],
      discountPrice: json["discountPrice"],
      sizes: json["sizes"] == null
          ? []
          : List<dynamic>.from(json["sizes"]!.map((x) => x)),
      colors: json["colors"] == null
          ? []
          : List<dynamic>.from(json["colors"]!.map((x) => x)),
      stock: json["stock"],
      avgRating: json["avgRating"],
      ratingCount: json["ratingCount"],
      sold: json["sold"],
      variants: json["variants"] == null
          ? []
          : List<dynamic>.from(json["variants"]!.map((x) => x)),
      seo: json["seo"] == null ? null : Seo.fromJson(json["seo"]),
      isDeleted: json["isDeleted"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }
}

class Seo {
  Seo({
    required this.metaTitle,
    required this.metaDescription,
    required this.metaKeywords,
    required this.ratingValue,
  });

  final String? metaTitle;
  final String? metaDescription;
  final List<String> metaKeywords;
  final dynamic ratingValue;

  factory Seo.fromJson(Map<String, dynamic> json) {
    return Seo(
      metaTitle: json["metaTitle"],
      metaDescription: json["metaDescription"],
      metaKeywords: json["metaKeywords"] == null
          ? []
          : List<String>.from(json["metaKeywords"]!.map((x) => x)),
      ratingValue: json["ratingValue"],
    );
  }
}

class Review {
  Review({
    required this.id,
    required this.user,
    required this.review,
    required this.files,
    required this.rating,
    required this.createdAt,
  });

  final String? id;
  final Vendor? user;
  final String? review;
  final List<String> files;
  final dynamic rating;
  final DateTime? createdAt;

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json["_id"],
      user: json["user"] == null ? null : Vendor.fromJson(json["user"]),
      review: json["review"],
      files: json["files"] == null
          ? []
          : List<String>.from(json["files"]!.map((x) => x)),
      rating: json["rating"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
    );
  }
}

class Vendor {
  Vendor({required this.id, required this.name, required this.profileAvatar});

  final String? id;
  final String? name;
  final String? profileAvatar;

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json["_id"],
      name: json["name"],
      profileAvatar: json["profileAvatar"],
    );
  }
}

class ShopRules {
  ShopRules({
    required this.returnPolicyTime,
    required this.deliveryMinTime,
    required this.deliveryMaxTime,
    required this.instantDeliveryMinTime,
    required this.instantDeliveryMaxTime,
    required this.isInstantDeliveryAvailable,
    required this.openingTime,
    required this.closingTime,
    required this.weekends,
    required this.timezone,
  });

  final Time? returnPolicyTime;
  final Time? deliveryMinTime;
  final Time? deliveryMaxTime;
  final Time? instantDeliveryMinTime;
  final Time? instantDeliveryMaxTime;
  final bool? isInstantDeliveryAvailable;
  final String? openingTime;
  final String? closingTime;
  final List<String> weekends;
  final String? timezone;

  factory ShopRules.fromJson(Map<String, dynamic> json) {
    return ShopRules(
      returnPolicyTime: json["returnPolicyTime"] == null
          ? null
          : Time.fromJson(json["returnPolicyTime"]),
      deliveryMinTime: json["deliveryMinTime"] == null
          ? null
          : Time.fromJson(json["deliveryMinTime"]),
      deliveryMaxTime: json["deliveryMaxTime"] == null
          ? null
          : Time.fromJson(json["deliveryMaxTime"]),
      instantDeliveryMinTime: json["instantDeliveryMinTime"] == null
          ? null
          : Time.fromJson(json["instantDeliveryMinTime"]),
      instantDeliveryMaxTime: json["instantDeliveryMaxTime"] == null
          ? null
          : Time.fromJson(json["instantDeliveryMaxTime"]),
      isInstantDeliveryAvailable: json["isInstantDeliveryAvailable"],
      openingTime: json["openingTime"],
      closingTime: json["closingTime"],
      weekends: json["weekends"] == null
          ? []
          : List<String>.from(json["weekends"]!.map((x) => x)),
      timezone: json["timezone"],
    );
  }
}

class Time {
  Time({required this.time, required this.unit});

  final dynamic time;
  final String? unit;

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(time: json["time"], unit: json["unit"]);
  }
}

class SimilarProduct {
  SimilarProduct({
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
  final dynamic price;
  final dynamic discount;
  final dynamic discountPrice;
  final dynamic stock;
  final dynamic avgRating;
  final dynamic ratingCount;
  final bool? inStock;
  final bool? isWishlisted;

  factory SimilarProduct.fromJson(Map<String, dynamic> json) {
    return SimilarProduct(
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

  SimilarProduct copyWith({
    String? id,
    Category? category,
    String? title,
    String? inventoryType,
    String? collectionType,
    String? brand,
    String? brandType,
    String? banner,
    dynamic price,
    dynamic discount,
    dynamic discountPrice,
    dynamic stock,
    dynamic avgRating,
    dynamic ratingCount,
    bool? inStock,
    bool? isWishlisted,
  }) {
    return SimilarProduct(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      inventoryType: inventoryType ?? this.inventoryType,
      collectionType: collectionType ?? this.collectionType,
      brand: brand ?? this.brand,
      brandType: brandType ?? this.brandType,
      banner: banner ?? this.banner,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      discountPrice: discountPrice ?? this.discountPrice,
      stock: stock ?? this.stock,
      avgRating: avgRating ?? this.avgRating,
      ratingCount: ratingCount ?? this.ratingCount,
      inStock: inStock ?? this.inStock,
      isWishlisted: isWishlisted ?? this.isWishlisted,
    );
  }
}

class Voucher {
  Voucher({
    required this.id,
    required this.code,
    required this.title,
    required this.voucherType,
    required this.discountType,
    required this.discountValue,
    required this.giftDetails,
    required this.maxDiscountAmount,
    required this.minSpend,
    required this.expiryDate,
    required this.status,
    required this.hasUsed,
    required this.useAt,
  });

  final String? id;
  final String? code;
  final String? title;
  final String? voucherType;
  final String? discountType;
  final dynamic discountValue;
  final VoucherGiftDetails? giftDetails;
  final dynamic maxDiscountAmount;
  final dynamic minSpend;
  final DateTime? expiryDate;
  final String? status;
  final bool? hasUsed;
  final DateTime? useAt;

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      id: json["_id"],
      code: json["code"],
      title: json["title"],
      voucherType: json["voucherType"],
      discountType: json["discountType"],
      discountValue: json["discountValue"],
      giftDetails: json["giftDetails"] == null
          ? null
          : VoucherGiftDetails.fromJson(
              Map<String, dynamic>.from(json["giftDetails"]),
            ),
      maxDiscountAmount: json["maxDiscountAmount"],
      minSpend: json["minSpend"],
      expiryDate: DateTime.tryParse(json["expiryDate"] ?? ""),
      status: json["status"]?.toString(),
      hasUsed: json["hasUsed"],
      useAt: DateTime.tryParse(json["useAt"] ?? ""),
    );
  }
}

class VoucherGiftDetails {
  VoucherGiftDetails({
    required this.name,
    required this.bannerImage,
    required this.description,
  });

  final String? name;
  final List<String> bannerImage;
  final String? description;

  factory VoucherGiftDetails.fromJson(Map<String, dynamic> json) {
    return VoucherGiftDetails(
      name: json["name"]?.toString(),
      bannerImage: json["bannerImage"] == null
          ? []
          : List<String>.from(json["bannerImage"]!.map((x) => x.toString())),
      description: json["description"]?.toString(),
    );
  }
}
