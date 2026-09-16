class HomeDataModel {
  HomeDataModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  final bool? success; 
  final dynamic statusCode;
  final String? message;  
  final Data? data;
 
  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      success: json["success"],
      statusCode: json["statusCode"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  HomeDataModel copyWith({
    bool? success,
    dynamic statusCode,
    String? message,
    Data? data,
  }) {
    return HomeDataModel(
      success: success ?? this.success,
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}

class Data {
  Data({
    required this.profile,
    required this.unreadNotification,
    required this.cartItems,
    required this.firstSectionBanner,
    required this.lastOrder,
    required this.nearbyBrands,
    required this.recentlyViwed,
    required this.trandingProducts,
    required this.secondSectionBanner,
    required this.aiRecommandedProducts,
    required this.homePageCategories,
  });

  final Profile? profile;
  final dynamic unreadNotification;
  final dynamic cartItems;
  final List<SectionBanner> firstSectionBanner;
  final LastOrder? lastOrder;
  final List<NearbyBrand> nearbyBrands;
  final List<Product> recentlyViwed;
  final List<Product> trandingProducts;
  final List<SectionBanner> secondSectionBanner;
  final List<Product> aiRecommandedProducts;
  final List<HomePageCategory> homePageCategories;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      profile: json["profile"] == null
          ? null
          : Profile.fromJson(json["profile"]),
      unreadNotification: json["unreadNotification"],
      cartItems: json["cartItems"],
      firstSectionBanner: json["firstSectionBanner"] == null
          ? []
          : List<SectionBanner>.from(
              json["firstSectionBanner"]!.map((x) => SectionBanner.fromJson(x)),
            ),
      lastOrder:
          json["lastOrder"] == null ? null : LastOrder.fromJson(json["lastOrder"]),
      nearbyBrands: json["nearbyBrands"] == null
          ? []
          : List<NearbyBrand>.from(
              json["nearbyBrands"]!.map((x) => NearbyBrand.fromJson(x)),
            ),
      recentlyViwed: json["recentlyViwed"] == null
          ? []
          : List<Product>.from(
              json["recentlyViwed"]!.map((x) => Product.fromJson(x)),
            ),
      trandingProducts: json["trandingProducts"] == null
          ? []
          : List<Product>.from(
              json["trandingProducts"]!.map((x) => Product.fromJson(x)),
            ),
      secondSectionBanner: json["secondSectionBanner"] == null
          ? []
          : List<SectionBanner>.from(
              json["secondSectionBanner"]!.map(
                (x) => SectionBanner.fromJson(x),
              ),
            ),
      aiRecommandedProducts: json["aiRecommandedProducts"] == null
          ? []
          : List<Product>.from(
              json["aiRecommandedProducts"]!.map((x) => Product.fromJson(x)),
            ),
      homePageCategories: json["homePageCategories"] == null
          ? []
          : List<HomePageCategory>.from(
              json["homePageCategories"]!.map(
                (x) => HomePageCategory.fromJson(x),
              ),
            ),
    );
  }

  Data copyWith({
    Profile? profile,
    dynamic unreadNotification,
    dynamic cartItems,
    List<SectionBanner>? firstSectionBanner,
    LastOrder? lastOrder,
    List<NearbyBrand>? nearbyBrands,
    List<Product>? recentlyViwed,
    List<Product>? trandingProducts,
    List<SectionBanner>? secondSectionBanner,
    List<Product>? aiRecommandedProducts,
    List<HomePageCategory>? homePageCategories,
  }) {
    return Data(
      profile: profile ?? this.profile,
      unreadNotification: unreadNotification ?? this.unreadNotification,
      cartItems: cartItems ?? this.cartItems,
      firstSectionBanner: firstSectionBanner ?? this.firstSectionBanner,
      lastOrder: lastOrder ?? this.lastOrder,
      nearbyBrands: nearbyBrands ?? this.nearbyBrands,
      recentlyViwed: recentlyViwed ?? this.recentlyViwed,
      trandingProducts: trandingProducts ?? this.trandingProducts,
      secondSectionBanner: secondSectionBanner ?? this.secondSectionBanner,
      aiRecommandedProducts:
          aiRecommandedProducts ?? this.aiRecommandedProducts,
      homePageCategories: homePageCategories ?? this.homePageCategories,
    );
  }
}

class LastOrder {
  LastOrder({
    required this.id,
    required this.orderId,
    required this.items,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  final String? id;
  final String? orderId;
  final List<LastOrderItem> items;
  final dynamic amount;
  final String? status;
  final DateTime? createdAt;

  factory LastOrder.fromJson(Map<String, dynamic> json) {
    return LastOrder(
      id: json["_id"]?.toString(),
      orderId: json["id"]?.toString(),
      items: json["items"] == null
          ? []
          : List<LastOrderItem>.from(
              json["items"]!.map((x) => LastOrderItem.fromJson(x)),
            ),
      amount: json["amount"] ?? json["totalAmount"] ?? json["grandTotal"],
      status: json["status"]?.toString(),
      createdAt: DateTime.tryParse(json["createdAt"]?.toString() ?? ""),
    );
  }
}

class LastOrderItem {
  LastOrderItem({
    required this.id,
    required this.orderId,
    required this.product,
    required this.author,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    required this.size,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? orderId;
  final LastOrderProduct? product;
  final String? author;
  final dynamic quantity;
  final dynamic price;
  final dynamic totalPrice;
  final dynamic size;
  final dynamic color;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory LastOrderItem.fromJson(Map<String, dynamic> json) {
    return LastOrderItem(
      id: json["_id"]?.toString(),
      orderId: json["order"]?.toString(),
      product: json["product"] == null
          ? null
          : LastOrderProduct.fromJson(
              Map<String, dynamic>.from(json["product"]),
            ),
      author: json["author"]?.toString(),
      quantity: json["quantity"],
      price: json["price"],
      totalPrice: json["totalPrice"],
      size: json["size"],
      color: json["color"],
      createdAt: DateTime.tryParse(json["createdAt"]?.toString() ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"]?.toString() ?? ""),
    );
  }
}

class LastOrderProduct {
  LastOrderProduct({
    required this.id,
    required this.title,
    required this.banner,
    required this.price,
    required this.discountPrice,
  });

  final String? id;
  final String? title;
  final String? banner;
  final dynamic price;
  final dynamic discountPrice;

  factory LastOrderProduct.fromJson(Map<String, dynamic> json) {
    return LastOrderProduct(
      id: json["_id"]?.toString(),
      title: json["title"]?.toString(),
      banner: json["banner"]?.toString(),
      price: json["price"],
      discountPrice: json["discountPrice"],
    );
  }
}

class HomePageCategory {
  HomePageCategory({
    required this.id,
    required this.title,
    required this.image,
  });

  final String? id;
  final String? title;
  final String? image;

  factory HomePageCategory.fromJson(Map<String, dynamic> json) {
    return HomePageCategory(
      id: json["_id"],
      title: json["title"],
      image: json["image"],
    );
  }
}

class Product {
  Product({
    required this.id,
    required this.title,
    required this.image,
    required this.banner,
    required this.collectionType,
    required this.price,
    required this.discountPrice,
    required this.avgRating,
    required this.ratingCount,
    required this.isWishlisted,
    required this.inStock,
  });

  final String? id;
  final String? title;
  final String? image;
  final String? banner;
  final String? collectionType;
  final dynamic price;
  final dynamic discountPrice;
  final dynamic avgRating;
  final dynamic ratingCount;
  final bool? isWishlisted;
  final bool? inStock;

  factory Product.fromJson(Map<String, dynamic> json) {
    final banner = json["banner"]?.toString();
    return Product(
      id: json["_id"],
      title: json["title"],
      image: json["image"] ??
          banner ??
          json["thumbnail"] ??
          json["productImage"],
      banner: banner,
      collectionType: json["collectionType"],
      price: json["price"],
      discountPrice: json["discountPrice"],
      avgRating: json["avgRating"],
      ratingCount: json["ratingCount"],
      isWishlisted: json["isWishlisted"],
      inStock: json["inStock"],
    );
  }

  Product copyWith({
    String? id,
    String? title,
    String? image,
    String? banner,
    String? collectionType,
    dynamic price,
    dynamic discountPrice,
    dynamic avgRating,
    dynamic ratingCount,
    bool? isWishlisted,
    bool? inStock,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      banner: banner ?? this.banner,
      collectionType: collectionType ?? this.collectionType,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      avgRating: avgRating ?? this.avgRating,
      ratingCount: ratingCount ?? this.ratingCount,
      isWishlisted: isWishlisted ?? this.isWishlisted,
      inStock: inStock ?? this.inStock,
    );
  }
}

class SectionBanner {
  SectionBanner({
    required this.banner,
    required this.bannerArabic,
    required this.reference,
    required this.type,
  });

  final String? banner;
  final String? bannerArabic;
  final String? reference;
  final String? type;

  factory SectionBanner.fromJson(Map<String, dynamic> json) {
    return SectionBanner(
      banner: json["banner"]?.toString(),
      bannerArabic: json["bannerArabic"]?.toString(),
      reference: json["reference"]?.toString(),
      type: json["type"]?.toString(),
    );
  }
}

class NearbyBrand {
  NearbyBrand({
    required this.id,
    required this.name,
    required this.profileAvatar,
  });

  final String? id;
  final String? name;
  final String? profileAvatar;

  factory NearbyBrand.fromJson(Map<String, dynamic> json) {
    return NearbyBrand(
      id: json["_id"],
      name: json["name"],
      profileAvatar: json["profileAvatar"],
    );
  }
}

class Profile {
  Profile({
    required this.name,
    required this.deliveryAddress,
    required this.deliveryLocation,
  });

  final String? name;
  final DeliveryAddress? deliveryAddress;
  final DeliveryLocation? deliveryLocation;

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json["name"],
      deliveryAddress: json["deliveryAddress"] == null
          ? null
          : DeliveryAddress.fromJson(json["deliveryAddress"]),
      deliveryLocation: json["deliveryLocation"] == null
          ? null
          : DeliveryLocation.fromJson(json["deliveryLocation"]),
    );
  }
}

class DeliveryAddress {
  DeliveryAddress({
    required this.name,
    required this.location,
    required this.buildingNo,
    required this.floorNo,
    required this.apartment,
    required this.city,
    required this.country,
  });

  final String? name;
  final DeliveryLocation? location;
  final dynamic buildingNo;
  final dynamic floorNo;
  final dynamic apartment;
  final String? city;
  final String? country;

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      name: json["name"],
      location: json["location"] == null
          ? null
          : DeliveryLocation.fromJson(json["location"]),
      buildingNo: json["buildingNo"],
      floorNo: json["floorNo"],
      apartment: json["apartment"],
      city: json["city"],
      country: json["country"],
    );
  }
}

class DeliveryLocation {
  DeliveryLocation({required this.type, required this.coordinates});

  final String? type;
  final List<num> coordinates;

  factory DeliveryLocation.fromJson(Map<String, dynamic> json) {
    return DeliveryLocation(
      type: json["type"],
      coordinates: json["coordinates"] == null
          ? []
          : List<num>.from(json["coordinates"]!.map((x) => x)),
    );
  }
}
