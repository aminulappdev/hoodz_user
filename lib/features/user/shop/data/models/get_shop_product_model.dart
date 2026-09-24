import 'package:hoodz/app/translator/localization_service.dart';

class GetShopProductModel {
    GetShopProductModel({
        required this.success,
        required this.statusCode,
        required this.message,
        required this.meta,
        required this.data,
    });

    final bool? success;
    final dynamic statusCode;
    final String? message;
    final Meta? meta;
    final Data? data;

    factory GetShopProductModel.fromJson(Map<String, dynamic> json){ 
        return GetShopProductModel(
            success: json["success"],
            statusCode: json["statusCode"],
            message: json["message"],
            meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

    GetShopProductModel copyWith({
        bool? success,
        dynamic statusCode,
        String? message,
        Meta? meta,
        Data? data,
    }) {
        return GetShopProductModel(
            success: success ?? this.success,
            statusCode: statusCode ?? this.statusCode,
            message: message ?? this.message,
            meta: meta ?? this.meta,
            data: data ?? this.data,
        );
    }

}

class Data {
    Data({
        required this.recommends,
        required this.allProducts,
    });

    final List<AllProduct> recommends;
    final List<AllProduct> allProducts;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            recommends: json["recommends"] == null ? [] : List<AllProduct>.from(json["recommends"]!.map((x) => AllProduct.fromJson(x))),
            allProducts: json["allProducts"] == null ? [] : List<AllProduct>.from(json["allProducts"]!.map((x) => AllProduct.fromJson(x))),
        );
    }

    Data copyWith({
        List<AllProduct>? recommends,
        List<AllProduct>? allProducts,
    }) {
        return Data(
            recommends: recommends ?? this.recommends,
            allProducts: allProducts ?? this.allProducts,
        );
    }

}

class AllProduct {
    AllProduct({
        required this.id,
        required this.category,
        required this.title,
        required this.titleArabic,
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
    final String? titleArabic;
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

    String get displayTitle => LocalizationService.localizedValue(
      english: title,
      arabic: titleArabic,
    );

    factory AllProduct.fromJson(Map<String, dynamic> json){ 
        return AllProduct(
            id: json["_id"],
            category: json["category"] == null ? null : Category.fromJson(json["category"]),
            title: json["title"]?.toString(),
            titleArabic: json["titleArabic"]?.toString(),
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

    AllProduct copyWith({
        String? id,
        Category? category,
        String? title,
        String? titleArabic,
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
        return AllProduct(
            id: id ?? this.id,
            category: category ?? this.category,
            title: title ?? this.title,
            titleArabic: titleArabic ?? this.titleArabic,
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

class Category {
    Category({
        required this.id,
        required this.title,
        required this.titleArabic,
        required this.icon,
        required this.iconArabic,
    });

    final String? id;
    final String? title;
    final String? titleArabic;
    final String? icon;
    final String? iconArabic;

    String get displayTitle => LocalizationService.localizedValue(
      english: title,
      arabic: titleArabic,
    );

    String get displayIcon => LocalizationService.localizedValue(
      english: icon,
      arabic: iconArabic,
    );

    factory Category.fromJson(Map<String, dynamic> json){ 
        return Category(
            id: json["_id"]?.toString(),
            title: json["title"]?.toString(),
            titleArabic: json["titleArabic"]?.toString(),
            icon: json["icon"]?.toString(),
            iconArabic: json["iconArabic"]?.toString(),
        );
    }

}

class Meta {
    Meta({
        required this.page,
        required this.limit,
        required this.total,
        required this.totalPage,
    });

    final dynamic page;
    final dynamic limit;
    final dynamic total;
    final dynamic totalPage;

    factory Meta.fromJson(Map<String, dynamic> json){ 
        return Meta(
            page: json["page"],
            limit: json["limit"],
            total: json["total"],
            totalPage: json["totalPage"],
        );
    }

}
