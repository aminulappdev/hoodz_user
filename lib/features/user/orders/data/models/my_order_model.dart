class MyOrderModel {
    MyOrderModel({
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

    factory MyOrderModel.fromJson(Map<String, dynamic> json){ 
        final rawData = json["data"];
        return MyOrderModel(
            success: _toBool(json["success"]),
            statusCode: _toInt(json["statusCode"]),
            message: json["message"]?.toString(),
            meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
            data: _parseOrders(rawData),
        );
    }

}

class Datum {
    Datum({
        required this.id,
        required this.items,
        required this.totalItem,
        required this.deliveryCharge,
        required this.totalAmount,
        required this.status,
        required this.paymentStatus,
        required this.transactionId,
        required this.deliveryType,
        required this.isDeleted,
        required this.datumId,
        required this.createdAt,
        required this.hasGrievanceIssued,
    });

    final String? id;
    final List<Item> items;
    final int? totalItem;
    final int? deliveryCharge;
    final int? totalAmount;
    final String? status;
    final String? paymentStatus;
    final String? transactionId;
    final String? deliveryType;
    final bool? isDeleted;
    final String? datumId;
    final DateTime? createdAt;
    final bool? hasGrievanceIssued;

    factory Datum.fromJson(Map<String, dynamic> json){ 
        return Datum(
            id: json["_id"]?.toString(),
            items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
            totalItem: _toInt(json["totalItem"]),
            deliveryCharge: _toInt(json["deliveryCharge"]),
            totalAmount: _toInt(json["totalAmount"]),
            status: json["status"]?.toString(),
            paymentStatus: json["paymentStatus"]?.toString(),
            transactionId: json["transactionId"]?.toString(),
            deliveryType: json["deliveryType"]?.toString(),
            isDeleted: _toBool(json["isDeleted"]),
            datumId: json["id"]?.toString(),
            createdAt: DateTime.tryParse(json["createdAt"]?.toString() ?? ""),
            hasGrievanceIssued: _toBool(json["hasGrievanceIssued"]),
        );
    }

}

class Item {
    Item({
        required this.id,
        required this.product,
        required this.color,
    });

    final String? id;
    final Product? product;
    final Color? color;

    factory Item.fromJson(Map<String, dynamic> json){ 
        return Item(
            id: json["_id"]?.toString(),
            product: json["product"] == null ? null : Product.fromJson(json["product"]),
            color: json["color"] == null ? null : Color.fromJson(json["color"]),
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
        required this.title,
        required this.banner,
    });

    final String? id;
    final String? title;
    final String? banner;

    factory Product.fromJson(Map<String, dynamic> json){ 
        return Product(
            id: json["_id"]?.toString(),
            title: json["title"]?.toString(),
            banner: json["banner"]?.toString(),
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
            page: _toInt(json["page"]),
            limit: _toInt(json["limit"]),
            total: _toInt(json["total"]),
            totalPage: _toInt(json["totalPage"]),
        );
    }

}

int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
}

bool? _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
        final lower = value.toLowerCase();
        if (lower == 'true') return true;
        if (lower == 'false') return false;
    }
    return null;
}

List<Datum> _parseOrders(dynamic rawData) {
    if (rawData == null) {
      return const [];
    }

    if (rawData is List) {
      return rawData
          .whereType<Map<String, dynamic>>()
          .map(Datum.fromJson)
          .toList();
    }

    if (rawData is Map<String, dynamic>) {
      final candidates = [
        rawData['data'],
        rawData['orders'],
        rawData['docs'],
        rawData['results'],
        rawData['items'],
      ];

      for (final candidate in candidates) {
        if (candidate is List) {
          return candidate
              .whereType<Map<String, dynamic>>()
              .map(Datum.fromJson)
              .toList();
        }
      }
    }

    return const [];
}
