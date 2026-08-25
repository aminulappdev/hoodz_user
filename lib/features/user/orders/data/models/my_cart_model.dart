class MyCartModel {
    MyCartModel({
        required this.success,
        required this.statusCode,
        required this.message,
        required this.data,
    }); 

    final bool? success;
    final int? statusCode;
    final String? message;
    final Data? data;

    factory MyCartModel.fromJson(Map<String, dynamic> json){ 
        return MyCartModel(
            success: _toBool(json["success"]),
            statusCode: _toInt(json["statusCode"]),
            message: json["message"]?.toString(),
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.items,
        required this.totalItems,
        required this.subTotal,
        required this.recommendedProducts,
    });

    final List<Item> items;
    final int? totalItems;
    final int? subTotal;
    final List<RecommendedProduct> recommendedProducts;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
            totalItems: _toInt(json["totalItems"]),
            subTotal: _toInt(json["subTotal"]),
            recommendedProducts: json["recommendedProducts"] == null ? [] : List<RecommendedProduct>.from(json["recommendedProducts"]!.map((x) => RecommendedProduct.fromJson(x))),
        );
    }

}

class Item {
    Item({
        required this.productId,
        required this.size,
        required this.color,
        required this.quantity,
        required this.product,
        required this.unitPrice,
        required this.totalPrice,
    });

    final String? productId;
    final String? size;
    final Color? color;
    final int? quantity;
    final Product? product;
    final int? unitPrice;
    final int? totalPrice;

    factory Item.fromJson(Map<String, dynamic> json){ 
        return Item(
            productId: json["productId"]?.toString(),
            size: json["size"]?.toString(),
            color: json["color"] == null ? null : Color.fromJson(json["color"]),
            quantity: _toInt(json["quantity"]),
            product: json["product"] == null ? null : Product.fromJson(json["product"]),
            unitPrice: _toInt(json["unitPrice"]),
            totalPrice: _toInt(json["totalPrice"]),
        );
    }

}

class Color {
    Color({
        required this.code,
        required this.name,
    });

    final String? code;
    final String? name;

    factory Color.fromJson(Map<String, dynamic> json){ 
        return Color(
            code: json["code"]?.toString(),
            name: json["name"]?.toString(),
        );
    }

}

class Product {
    Product({
        required this.id,
        required this.vendor,
        required this.title,
        required this.banner,
        required this.inventoryType,
        required this.colors,
        required this.sizes,
        required this.variants,
        required this.price,
        required this.discountPrice,
    });

    final String? id;
    final String? vendor;
    final String? title;
    final String? banner;
    final String? inventoryType;
    final List<Color> colors;
    final List<String> sizes;
    final List<Variant> variants;
    final int? price;
    final int? discountPrice;

    factory Product.fromJson(Map<String, dynamic> json){ 
        return Product(
            id: json["_id"]?.toString(),
            vendor: json["vendor"]?.toString(),
            title: json["title"]?.toString(),
            banner: json["banner"]?.toString(),
            inventoryType: json["inventoryType"]?.toString(),
            colors: json["colors"] == null
                ? []
                : List<Color>.from(
                    json["colors"]!.map((x) => Color.fromJson(x)),
                  ),
            sizes: json["sizes"] == null
                ? []
                : List<String>.from(json["sizes"]!.map((x) => x.toString())),
            variants: json["variants"] == null
                ? []
                : List<Variant>.from(
                    json["variants"]!.map((x) => Variant.fromJson(x)),
                  ),
            price: _toInt(json["price"]),
            discountPrice: _toInt(json["discountPrice"]),
        );
    }

}

class RecommendedProduct {
    RecommendedProduct({
        required this.id,
        required this.category,
        required this.title,
        required this.collectionType,
        required this.banner,
        required this.price,
        required this.discount,
        required this.discountPrice,
        required this.avgRating,
        required this.ratingCount,
        required this.inStock,
    });

    final String? id;
    final Category? category;
    final String? title;
    final String? collectionType;
    final String? banner;
    final int? price;
    final int? discount;
    final int? discountPrice;
    final double? avgRating;
    final int? ratingCount;
    final bool? inStock;

    factory RecommendedProduct.fromJson(Map<String, dynamic> json){ 
        return RecommendedProduct(
            id: json["_id"]?.toString(),
            category: json["category"] == null ? null : Category.fromJson(json["category"]),
            title: json["title"]?.toString(),
            collectionType: json["collectionType"]?.toString(),
            banner: json["banner"]?.toString(),
            price: _toInt(json["price"]),
            discount: _toInt(json["discount"]),
            discountPrice: _toInt(json["discountPrice"]),
            avgRating: _toDouble(json["avgRating"]),
            ratingCount: _toInt(json["ratingCount"]),
            inStock: _toBool(json["inStock"]),
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
            id: json["_id"]?.toString(),
            title: json["title"]?.toString(),
        );
    }

}

class Variant {
    Variant({
        required this.id,
        required this.size,
        required this.color,
        required this.quantity,
    });

    final String? id;
    final String? size;
    final Color? color;
    final int? quantity;

    factory Variant.fromJson(Map<String, dynamic> json) {
        return Variant(
            id: json["_id"]?.toString(),
            size: json["size"]?.toString(),
            color: json["color"] == null ? null : Color.fromJson(json["color"]),
            quantity: _toInt(json["quantity"]),
        );
    }
}

int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
}

double? _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
}

bool? _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) {
        final lower = value.toLowerCase();
        if (lower == 'true') return true;
        if (lower == 'false') return false;
    }
    return null;
}
