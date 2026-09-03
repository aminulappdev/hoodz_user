class OrderSummaryModel {
  OrderSummaryModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  final bool? success;
  final int? statusCode;
  final String? message;
  final Data? data;

  factory OrderSummaryModel.fromJson(Map<String, dynamic> json) {
    return OrderSummaryModel(
      success: json["success"],
      statusCode: _toInt(json["statusCode"]),
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }
}

class Data {
  Data({
    required this.amount,
    required this.voucherCode,
    required this.voucherDiscount,
    required this.giftDetails,
    required this.redeemCoins,
    required this.coinDiscount,
    required this.deliveryCharge,
    required this.totalAmount,
    required this.walletBalance,
    required this.pointBalance,
    required this.deliveryType,
    required this.city,
    required this.billingDetails,
    required this.orders,
  });

  final num? amount;
  final dynamic voucherCode;
  final num? voucherDiscount;
  final dynamic giftDetails;
  final int? redeemCoins;
  final num? coinDiscount;
  final num? deliveryCharge;
  final num? totalAmount;
  final num? walletBalance;
  final int? pointBalance;
  final String? deliveryType;
  final String? city;
  final BillingDetails? billingDetails;
  final List<Order> orders;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      amount: _toNum(json["amount"]),
      voucherCode: json["voucherCode"],
      voucherDiscount: _toNum(json["voucherDiscount"]),
      giftDetails: json["giftDetails"],
      redeemCoins: _toInt(json["redeemCoins"]),
      coinDiscount: _toNum(json["coinDiscount"]),
      deliveryCharge: _toNum(json["deliveryCharge"]),
      totalAmount: _toNum(json["totalAmount"]),
      walletBalance: _toNum(json["walletBalance"]),
      pointBalance: _toInt(json["pointBalance"]),
      deliveryType: json["deliveryType"],
      city: json["city"],
      billingDetails: json["billingDetails"] == null
          ? null
          : BillingDetails.fromJson(json["billingDetails"]),
      orders: json["orders"] == null
          ? []
          : List<Order>.from(json["orders"]!.map((x) => Order.fromJson(x))),
    );
  }
}

class BillingDetails {
  BillingDetails({
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.buildingNo,
    required this.floorNo,
    required this.apartment,
    required this.city,
    required this.country,
    required this.deliveryLocation,
    required this.note,
  });

  final String? name;
  final String? address;
  final String? phoneNumber;
  final String? email;
  final int? buildingNo;
  final int? floorNo;
  final int? apartment;
  final String? city;
  final String? country;
  final DeliveryLocation? deliveryLocation;
  final String? note;

  factory BillingDetails.fromJson(Map<String, dynamic> json) {
    return BillingDetails(
      name: json["name"],
      address: json["address"],
      phoneNumber: json["phoneNumber"],
      email: json["email"],
      buildingNo: _toInt(json["buildingNo"]),
      floorNo: _toInt(json["floorNo"]),
      apartment: _toInt(json["apartment"]),
      city: json["city"],
      country: json["country"],
      deliveryLocation: json["deliveryLocation"] == null
          ? null
          : DeliveryLocation.fromJson(json["deliveryLocation"]),
      note: json["note"],
    );
  }
}

class DeliveryLocation {
  DeliveryLocation({
    required this.type,
    required this.coordinates,
    required this.latitude,
    required this.longitude,
  });

  final String? type;
  final List<num> coordinates;
  final double? latitude;
  final double? longitude;

  factory DeliveryLocation.fromJson(Map<String, dynamic> json) {
    return DeliveryLocation(
      type: json["type"],
      coordinates: json["coordinates"] == null
          ? []
          : List<num>.from(json["coordinates"]!.map((x) => x as num)),
      latitude: _toDouble(json["latitude"]),
      longitude: _toDouble(json["longitude"]),
    );
  }
}

class Order {
  Order({
    required this.author,
    required this.shopLocation,
    required this.amount,
    required this.voucherDiscount,
    required this.giftDetails,
    required this.coinDiscount,
    required this.deliveryCharge,
    required this.totalAmount,
    required this.items,
  });

  final String? author;
  final ShopLocation? shopLocation;
  final num? amount;
  final num? voucherDiscount;
  final dynamic giftDetails;
  final num? coinDiscount;
  final num? deliveryCharge;
  final num? totalAmount;
  final List<Item> items;

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      author: json["author"],
      shopLocation: json["shopLocation"] == null
          ? null
          : ShopLocation.fromJson(json["shopLocation"]),
      amount: _toNum(json["amount"]),
      voucherDiscount: _toNum(json["voucherDiscount"]),
      giftDetails: json["giftDetails"],
      coinDiscount: _toNum(json["coinDiscount"]),
      deliveryCharge: _toNum(json["deliveryCharge"]),
      totalAmount: _toNum(json["totalAmount"]),
      items: json["items"] == null
          ? []
          : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    );
  }
}

class ShopLocation {
  ShopLocation({
    required this.type,
    required this.coordinates,
    required this.latitude,
    required this.longitude,
  });

  final String? type;
  final List<num> coordinates;
  final double? latitude;
  final double? longitude;

  factory ShopLocation.fromJson(Map<String, dynamic> json) {
    return ShopLocation(
      type: json["type"],
      coordinates: json["coordinates"] == null
          ? []
          : List<num>.from(json["coordinates"]!.map((x) => x as num)),
      latitude: _toDouble(json["latitude"]),
      longitude: _toDouble(json["longitude"]),
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
  final num? unitPrice;
  final num? totalPrice;

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      productId: json["productId"],
      size: json["size"],
      color: json["color"] == null ? null : Color.fromJson(json["color"]),
      quantity: _toInt(json["quantity"]),
      product: json["product"] == null
          ? null
          : Product.fromJson(json["product"]),
      unitPrice: _toNum(json["unitPrice"]),
      totalPrice: _toNum(json["totalPrice"]),
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

  factory Color.fromJson(Map<String, dynamic> json) {
    return Color(
      code: json["code"],
      name: json["name"],
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
    required this.price,
    required this.discount,
    required this.discountPrice,
    required this.isDiscounted,
  });

  final String? id;
  final String? vendor;
  final String? title;
  final String? banner;
  final String? inventoryType;
  final num? price;
  final num? discount;
  final num? discountPrice;
  final bool? isDiscounted;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["_id"],
      vendor: json["vendor"],
      title: json["title"],
      banner: json["banner"],
      inventoryType: json["inventoryType"],
      price: _toNum(json["price"]),
      discount: _toNum(json["discount"]),
      discountPrice: _toNum(json["discountPrice"]),
      isDiscounted: json["isDiscounted"],
    );
  }
}

double? _toDouble(dynamic value) {
  if (value is double) {
    return value;
  }
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}

num? _toNum(dynamic value) {
  if (value is num) {
    return value;
  }
  if (value is String) {
    return num.tryParse(value);
  }
  return null;
}

int? _toInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is double) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value);
  }
  return null;
}
