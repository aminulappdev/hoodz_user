class InitialSearchModel {
    InitialSearchModel({
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
    final Data? data;

    factory InitialSearchModel.fromJson(Map<String, dynamic> json){ 
        return InitialSearchModel(
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
        required this.categories,
        required this.featuredVendors,
        required this.histories,
    });

    final List<Category> categories;
    final List<FeaturedVendor> featuredVendors;
    final List<History> histories;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
            featuredVendors: json["featuredVendors"] == null ? [] : List<FeaturedVendor>.from(json["featuredVendors"]!.map((x) => FeaturedVendor.fromJson(x))),
            histories: json["histories"] == null ? [] : List<History>.from(json["histories"]!.map((x) => History.fromJson(x))),
        );
    }

}

class Category {
    Category({
        required this.id,
        required this.title,
        required this.icon,
    });

    final String? id;
    final String? title;
    final String? icon;

    factory Category.fromJson(Map<String, dynamic> json){ 
        return Category(
            id: json["_id"],
            title: json["title"],
            icon: json["icon"],
        );
    }

}

class FeaturedVendor {
    FeaturedVendor({
        required this.id,
        required this.name,
        required this.profileAvatar,
        required this.avgRating,
        required this.ratingCount,
        required this.distance,
    });

    final String? id;
    final String? name;
    final String? profileAvatar;
    final double? avgRating;
    final int? ratingCount;
    final Distance? distance;

    factory FeaturedVendor.fromJson(Map<String, dynamic> json){ 
        return FeaturedVendor(
            id: json["_id"],
            name: json["name"],
            profileAvatar: json["profileAvatar"],
            avgRating: json["avgRating"],
            ratingCount: json["ratingCount"],
            distance: json["distance"] == null ? null : Distance.fromJson(json["distance"]),
        );
    }

}

class Distance {
    Distance({
        required this.distanceKm,
        required this.durationMinutes,
    });

    final double? distanceKm;
    final int? durationMinutes;

    factory Distance.fromJson(Map<String, dynamic> json){ 
        return Distance(
            distanceKm: json["distanceKm"],
            durationMinutes: json["durationMinutes"],
        );
    }

}

class History {
    History({
        required this.lastSearchedAt,
        required this.query,
        required this.source,
    });

    final DateTime? lastSearchedAt;
    final String? query;
    final String? source;

    factory History.fromJson(Map<String, dynamic> json){ 
        return History(
            lastSearchedAt: DateTime.tryParse(json["lastSearchedAt"] ?? ""),
            query: json["query"],
            source: json["source"],
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
