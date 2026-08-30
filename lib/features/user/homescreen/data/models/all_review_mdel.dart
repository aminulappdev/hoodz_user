class AllReviewModel {
    AllReviewModel({
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

    factory AllReviewModel.fromJson(Map<String, dynamic> json){ 
        return AllReviewModel(
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
        required this.avgRating,
        required this.ratingCount,
        required this.reviewAnalysis,
        required this.reviews,
    });

    final int? avgRating;
    final int? ratingCount;
    final ReviewAnalysis? reviewAnalysis;
    final List<Review> reviews;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            avgRating: json["avgRating"],
            ratingCount: json["ratingCount"],
            reviewAnalysis: json["reviewAnalysis"] == null ? null : ReviewAnalysis.fromJson(json["reviewAnalysis"]),
            reviews: json["reviews"] == null ? [] : List<Review>.from(json["reviews"]!.map((x) => Review.fromJson(x))),
        );
    }

}

class ReviewAnalysis {
    ReviewAnalysis({
        required this.excellent,
        required this.veryGood,
        required this.good,
        required this.fair,
        required this.poor,
    });

    final int? excellent;
    final int? veryGood;
    final int? good;
    final int? fair;
    final int? poor;

    factory ReviewAnalysis.fromJson(Map<String, dynamic> json){ 
        return ReviewAnalysis(
            excellent: json["excellent"],
            veryGood: json["very_good"],
            good: json["good"],
            fair: json["fair"],
            poor: json["poor"],
        );
    }

}

class Review {
    Review({
        required this.id,
        required this.user,
        required this.modelType,
        required this.review,
        required this.files,
        required this.rating,
        required this.createdAt,
    });

    final String? id;
    final User? user;
    final String? modelType;
    final String? review;
    final List<String> files;
    final int? rating;
    final DateTime? createdAt;

    factory Review.fromJson(Map<String, dynamic> json){ 
        return Review(
            id: json["_id"],
            user: json["user"] == null ? null : User.fromJson(json["user"]),
            modelType: json["modelType"],
            review: json["review"],
            files: json["files"] == null ? [] : List<String>.from(json["files"]!.map((x) => x)),
            rating: json["rating"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
        );
    }

}

class User {
    User({
        required this.id,
        required this.name,
        required this.profileAvatar,
    });

    final String? id;
    final String? name;
    final String? profileAvatar;

    factory User.fromJson(Map<String, dynamic> json){ 
        return User(
            id: json["_id"],
            name: json["name"],
            profileAvatar: json["profileAvatar"],
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
