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

  factory MyOrderModel.fromJson(Map<String, dynamic> json) {
    return MyOrderModel(
      success: json["success"],
      statusCode: json["statusCode"],
      message: json["message"],
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
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

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json["_id"],
      items: json["items"] == null
          ? []
          : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
      totalItem: json["totalItem"],
      deliveryCharge: json["deliveryCharge"],
      totalAmount: json["totalAmount"],
      status: json["status"],
      paymentStatus: json["paymentStatus"],
      transactionId: json["transactionId"],
      deliveryType: json["deliveryType"],
      isDeleted: json["isDeleted"],
      datumId: json["id"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      hasGrievanceIssued: json["hasGrievanceIssued"],
    );
  }
}

class Item {
  Item({
    required this.id,
    required this.product,
    required this.size,
    required this.color,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  final String? id;
  final Product? product;
  final String? size;
  final Color? color;
  final int? quantity;
  final int? unitPrice;
  final int? totalPrice;

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json["_id"],
      product: json["product"] == null
          ? null
          : Product.fromJson(json["product"]),
      size: json["size"],
      color: json["color"] == null ? null : Color.fromJson(json["color"]),
      quantity: _toInt(json["quantity"]),
      unitPrice: _toInt(json["unitPrice"]),
      totalPrice: _toInt(json["totalPrice"]),
    );
  }
}

class Color {
  Color({required this.code, required this.name});

  final String? code;
  final String? name;

  factory Color.fromJson(Map<String, dynamic> json) {
    return Color(code: json["code"], name: json["name"]);
  }
}

class Product {
  Product({required this.id, required this.title, required this.banner});

  final String? id;
  final String? title;
  final String? banner;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["_id"],
      title: json["title"],
      banner: json["banner"],
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

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json["page"],
      limit: json["limit"],
      total: json["total"],
      totalPage: json["totalPage"],
    );
  }
}

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
