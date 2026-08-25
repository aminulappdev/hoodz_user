class OrderDetailsModel {
    OrderDetailsModel({
        required this.success,
        required this.statusCode,
        required this.message,
        required this.data,
    });

    final bool? success;
    final int? statusCode;
    final String? message;
    final Data? data;

    factory OrderDetailsModel.fromJson(Map<String, dynamic> json){ 
        return OrderDetailsModel(
            success: json["success"],
            statusCode: json["statusCode"],
            message: json["message"],
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.id,
        required this.user,
        required this.author,
        required this.amount,
        required this.coinDiscount,
        required this.voucher,
        required this.voucherCode,
        required this.voucherDiscount,
        required this.giftDetails,
        required this.deliveryCharge,
        required this.totalAmount,
        required this.status,
        required this.paymentStatus,
        required this.transactionId,
        required this.billingDetails,
        required this.deliveryType,
        required this.cancelledAt,
        required this.confirmedAt,
        required this.processedAt,
        required this.riderAssignedAt,
        required this.pickedUpAt,
        required this.onTheWayAt,
        required this.deliveredAt,
        required this.isOtpVerified,
        required this.isStockDeducted,
        required this.isShopBalanceCredited,
        required this.isDeleted,
        required this.dataId,
        required this.createdAt,
        required this.updatedAt,
        required this.items,
        required this.totalOrderItems,
        required this.rider,
        required this.hasOrderSupports,
        required this.hasRiderChat,
        required this.orderSteper,
    });

    final String? id;
    final Author? user;
    final Author? author;
    final int? amount;
    final int? coinDiscount;
    final dynamic voucher;
    final dynamic voucherCode;
    final int? voucherDiscount;
    final dynamic giftDetails;
    final int? deliveryCharge;
    final int? totalAmount;
    final String? status;
    final String? paymentStatus;
    final String? transactionId;
    final BillingDetails? billingDetails;
    final String? deliveryType;
    final dynamic cancelledAt;
    final dynamic confirmedAt;
    final dynamic processedAt;
    final dynamic riderAssignedAt;
    final dynamic pickedUpAt;
    final dynamic onTheWayAt;
    final dynamic deliveredAt;
    final bool? isOtpVerified;
    final bool? isStockDeducted;
    final bool? isShopBalanceCredited;
    final bool? isDeleted;
    final String? dataId;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final List<Item> items;
    final int? totalOrderItems;
    final dynamic rider;
    final bool? hasOrderSupports;
    final bool? hasRiderChat;
    final int? orderSteper;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            id: json["_id"],
            user: json["user"] == null ? null : Author.fromJson(json["user"]),
            author: json["author"] == null ? null : Author.fromJson(json["author"]),
            amount: json["amount"],
            coinDiscount: json["coinDiscount"],
            voucher: json["voucher"],
            voucherCode: json["voucherCode"],
            voucherDiscount: json["voucherDiscount"],
            giftDetails: json["giftDetails"],
            deliveryCharge: json["deliveryCharge"],
            totalAmount: json["totalAmount"],
            status: json["status"],
            paymentStatus: json["paymentStatus"],
            transactionId: json["transactionId"],
            billingDetails: json["billingDetails"] == null ? null : BillingDetails.fromJson(json["billingDetails"]),
            deliveryType: json["deliveryType"],
            cancelledAt: json["cancelledAt"],
            confirmedAt: json["confirmedAt"],
            processedAt: json["processedAt"],
            riderAssignedAt: json["riderAssignedAt"],
            pickedUpAt: json["pickedUpAt"],
            onTheWayAt: json["onTheWayAt"],
            deliveredAt: json["deliveredAt"],
            isOtpVerified: json["isOtpVerified"],
            isStockDeducted: json["isStockDeducted"],
            isShopBalanceCredited: json["isShopBalanceCredited"],
            isDeleted: json["isDeleted"],
            dataId: json["id"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
            items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
            totalOrderItems: json["totalOrderItems"],
            rider: json["rider"],
            hasOrderSupports: json["hasOrderSupports"],
            hasRiderChat: json["hasRiderChat"],
            orderSteper: json["orderSteper"],
        );
    }

}

class Author {
    Author({
        required this.id,
        required this.name,
        required this.email,
        required this.profileAvatar,
        required this.phone,
        required this.coverPhoto,
    });

    final String? id;
    final String? name;
    final String? email;
    final String? profileAvatar;
    final String? phone;
    final String? coverPhoto;

    factory Author.fromJson(Map<String, dynamic> json){ 
        return Author(
            id: json["_id"],
            name: json["name"],
            email: json["email"],
            profileAvatar: json["profileAvatar"],
            phone: json["phone"],
            coverPhoto: json["coverPhoto"],
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
        required this.note,
        required this.deliveryLocation,
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
    final dynamic note;
    final DeliveryLocation? deliveryLocation;

    factory BillingDetails.fromJson(Map<String, dynamic> json){ 
        return BillingDetails(
            name: json["name"],
            address: json["address"],
            phoneNumber: json["phoneNumber"],
            email: json["email"],
            buildingNo: json["buildingNo"],
            floorNo: json["floorNo"],
            apartment: json["apartment"],
            city: json["city"],
            country: json["country"],
            note: json["note"],
            deliveryLocation: json["deliveryLocation"] == null ? null : DeliveryLocation.fromJson(json["deliveryLocation"]),
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
    final List<double> coordinates;
    final double? latitude;
    final double? longitude;

    factory DeliveryLocation.fromJson(Map<String, dynamic> json){ 
        return DeliveryLocation(
            type: json["type"],
            coordinates: json["coordinates"] == null
                ? []
                : List<double>.from(
                    (json["coordinates"] as List).map(
                      (x) => (x as num).toDouble(),
                    ),
                  ),
            latitude: (json["latitude"] as num?)?.toDouble(),
            longitude: (json["longitude"] as num?)?.toDouble(),
        );
    }

}

class Item {
    Item({
        required this.id,
        required this.order,
        required this.product,
        required this.author,
        required this.quantity,
        required this.price,
        required this.totalPrice,
        required this.size,
        required this.color,
        required this.createdAt,
        required this.updatedAt,
    });

    final String? id;
    final String? order;
    final Product? product;
    final String? author;
    final int? quantity;
    final int? price;
    final int? totalPrice;
    final dynamic size;
    final dynamic color;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    factory Item.fromJson(Map<String, dynamic> json){ 
        return Item(
            id: json["_id"],
            order: json["order"],
            product: json["product"] == null ? null : Product.fromJson(json["product"]),
            author: json["author"],
            quantity: json["quantity"],
            price: json["price"],
            totalPrice: json["totalPrice"],
            size: json["size"],
            color: json["color"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
        );
    }

}

class Product {
    Product({
        required this.id,
        required this.title,
        required this.banner,
        required this.price,
        required this.discountPrice,
    });

    final String? id;
    final String? title;
    final String? banner;
    final int? price;
    final int? discountPrice;

    factory Product.fromJson(Map<String, dynamic> json){ 
        return Product(
            id: json["_id"],
            title: json["title"],
            banner: json["banner"],
            price: json["price"],
            discountPrice: json["discountPrice"],
        );
    }

}
