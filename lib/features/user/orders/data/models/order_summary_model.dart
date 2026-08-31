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

    factory OrderSummaryModel.fromJson(Map<String, dynamic> json){ 
        return OrderSummaryModel(
            success: json["success"],
            statusCode: json["statusCode"],
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

    final int? amount;
    final dynamic voucherCode;
    final int? voucherDiscount;
    final dynamic giftDetails;
    final int? redeemCoins;
    final int? coinDiscount;
    final int? deliveryCharge;
    final int? totalAmount;
    final int? walletBalance;
    final int? pointBalance;
    final String? deliveryType;
    final String? city;
    final BillingDetails? billingDetails;
    final List<Order> orders;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            amount: _toInt(json["amount"]),
            voucherCode: json["voucherCode"],
            voucherDiscount: _toInt(json["voucherDiscount"]),
            giftDetails: json["giftDetails"],
            redeemCoins: _toInt(json["redeemCoins"]),
            coinDiscount: _toInt(json["coinDiscount"]),
            deliveryCharge: _toInt(json["deliveryCharge"]),
            totalAmount: _toInt(json["totalAmount"]),
            walletBalance: _toInt(json["walletBalance"]),
            pointBalance: _toInt(json["pointBalance"]),
            deliveryType: json["deliveryType"],
            city: json["city"],
            billingDetails: json["billingDetails"] == null ? null : BillingDetails.fromJson(json["billingDetails"]),
            orders: json["orders"] == null ? [] : List<Order>.from(json["orders"]!.map((x) => Order.fromJson(x))),
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

    factory BillingDetails.fromJson(Map<String, dynamic> json){ 
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
            deliveryLocation: json["deliveryLocation"] == null ? null : DeliveryLocation.fromJson(json["deliveryLocation"]),
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

    factory DeliveryLocation.fromJson(Map<String, dynamic> json){ 
        return DeliveryLocation(
            type: json["type"],
            coordinates: json["coordinates"] == null
                ? []
                : List<num>.from(
                    json["coordinates"]!.map((x) => x as num),
                  ),
            latitude: _asDouble(json["latitude"]),
            longitude: _asDouble(json["longitude"]),
        );
    }

    static double? _asDouble(dynamic value) {
        if (value is num) {
            return value.toDouble();
        }

        return double.tryParse(value?.toString() ?? '');
    }

}

class Order {
    Order({
        required this.author,
        required this.amount,
        required this.voucherDiscount,
        required this.giftDetails,
        required this.coinDiscount,
        required this.deliveryCharge,
        required this.totalAmount,
        required this.items,
    });

    final String? author;
    final int? amount;
    final int? voucherDiscount;
    final dynamic giftDetails;
    final int? coinDiscount;
    final int? deliveryCharge;
    final int? totalAmount;
    final List<Item> items;

    factory Order.fromJson(Map<String, dynamic> json){ 
        return Order(
            author: json["author"],
            amount: _toInt(json["amount"]),
            voucherDiscount: _toInt(json["voucherDiscount"]),
            giftDetails: json["giftDetails"],
            coinDiscount: _toInt(json["coinDiscount"]),
            deliveryCharge: _toInt(json["deliveryCharge"]),
            totalAmount: _toInt(json["totalAmount"]),
            items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
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
            productId: json["productId"],
            size: json["size"],
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
    final int? price;
    final int? discount;
    final int? discountPrice;
    final bool? isDiscounted;

    factory Product.fromJson(Map<String, dynamic> json){ 
        return Product(
            id: json["_id"],
            vendor: json["vendor"],
            title: json["title"],
            banner: json["banner"],
            inventoryType: json["inventoryType"],
            price: _toInt(json["price"]),
            discount: _toInt(json["discount"]),
            discountPrice: _toInt(json["discountPrice"]),
            isDiscounted: json["isDiscounted"],
        );
    }

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
