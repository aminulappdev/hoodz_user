class SearchFilterModel {
    SearchFilterModel({
        required this.success,
        required this.statusCode,
        required this.message,
        required this.data,
    });

    final bool? success;
    final int? statusCode;
    final String? message;
    final Data? data;

    factory SearchFilterModel.fromJson(Map<String, dynamic> json){ 
        return SearchFilterModel(
            success: json["success"],
            statusCode: json["statusCode"],
            message: json["message"],
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.minPrice,
        required this.maxPrice,
        required this.category,
        required this.brand,
        required this.color,
        required this.size,
        required this.gender,
    });

    final int? minPrice;
    final int? maxPrice;
    final List<Category> category;
    final List<String> brand;
    final List<Color> color;
    final List<String> size;
    final List<String> gender;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            minPrice: json["minPrice"],
            maxPrice: json["maxPrice"],
            category: json["category"] == null ? [] : List<Category>.from(json["category"]!.map((x) => Category.fromJson(x))),
            brand: json["brand"] == null ? [] : List<String>.from(json["brand"]!.map((x) => x)),
            color: json["color"] == null ? [] : List<Color>.from(json["color"]!.map((x) => Color.fromJson(x))),
            size: json["size"] == null ? [] : List<String>.from(json["size"]!.map((x) => x)),
            gender: json["gender"] == null ? [] : List<String>.from(json["gender"]!.map((x) => x)),
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

class Color {
    Color({
        required this.name,
        required this.code,
    });

    final String? name;
    final String? code;

    factory Color.fromJson(Map<String, dynamic> json){ 
        return Color(
            name: json["name"],
            code: json["code"],
        );
    }

}
