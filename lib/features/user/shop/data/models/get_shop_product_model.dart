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

}

class AllProduct {
    AllProduct({
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

    factory AllProduct.fromJson(Map<String, dynamic> json){ 
        return AllProduct(
            id: json["_id"],
            category: json["category"] == null ? null : Category.fromJson(json["category"]),
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
    Category({
        required this.id,
        required this.title,
    });

    final String? id;
    final String? title;

    factory Category.fromJson(Map<String, dynamic> json){ 
        return Category(
            id: json["_id"],
            title: json["title"],
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
