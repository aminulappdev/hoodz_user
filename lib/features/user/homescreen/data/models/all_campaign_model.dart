class AllCampaignProductModel {
    AllCampaignProductModel({
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
    final List<Datum> data;

    factory AllCampaignProductModel.fromJson(Map<String, dynamic> json){ 
        return AllCampaignProductModel(
            success: json["success"],
            statusCode: json["statusCode"],
            message: json["message"],
            meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
            data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        );
    }

}

class Datum {
    Datum({
        required this.id,
        required this.title,
        required this.products,
        required this.createdAt,
        required this.updatedAt,
    });

    final String? id;
    final String? title;
    final List<Product> products;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    factory Datum.fromJson(Map<String, dynamic> json){ 
        return Datum(
            id: json["_id"],
            title: json["title"],
            products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
        );
    }

}

class Product {
    Product({
        required this.id,
        required this.collectionType,
        required this.title,
        required this.banner,
        required this.price,
        required this.discountPrice,
        required this.stock,
        required this.avgRating,
        required this.ratingCount,
    });

    final String? id;
    final String? collectionType;
    final String? title;
    final String? banner;
    final int? price;
    final int? discountPrice;
    final int? stock;
    final int? avgRating;
    final int? ratingCount;

    factory Product.fromJson(Map<String, dynamic> json){ 
        return Product(
            id: json["_id"],
            collectionType: json["collectionType"],
            title: json["title"],
            banner: json["banner"],
            price: json["price"],
            discountPrice: json["discountPrice"],
            stock: json["stock"],
            avgRating: json["avgRating"],
            ratingCount: json["ratingCount"],
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

    final int? page;
    final int? limit;
    final int? total;
    final int? totalPage;

    factory Meta.fromJson(Map<String, dynamic> json){ 
        return Meta(
            page: json["page"],
            limit: json["limit"],
            total: json["total"],
            totalPage: json["totalPage"],
        );
    }

}
