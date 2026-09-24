import 'package:hoodz/app/translator/localization_service.dart';

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
            statusCode: _toInt(json["statusCode"]),
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
        required this.hasGrievance,
        required this.deliveryJob,
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
    final Rider? rider;
    final bool? hasOrderSupports;
    final bool? hasRiderChat;
    final bool? hasGrievance;
    final DeliveryJob? deliveryJob;
    final int? orderSteper;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            id: json["_id"],
            user: json["user"] == null ? null : Author.fromJson(json["user"]),
            author: json["author"] == null ? null : Author.fromJson(json["author"]),
            amount: _toInt(json["amount"]),
            coinDiscount: _toInt(json["coinDiscount"]),
            voucher: json["voucher"],
            voucherCode: json["voucherCode"],
            voucherDiscount: _toInt(json["voucherDiscount"]),
            giftDetails: json["giftDetails"],
            deliveryCharge: _toInt(json["deliveryCharge"]),
            totalAmount: _toInt(json["totalAmount"]),
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
            isOtpVerified: _toBool(json["isOtpVerified"]),
            isStockDeducted: _toBool(json["isStockDeducted"]),
            isShopBalanceCredited: _toBool(json["isShopBalanceCredited"]),
            isDeleted: _toBool(json["isDeleted"]),
            dataId: json["id"],
            createdAt: DateTime.tryParse(json["createdAt"]?.toString() ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"]?.toString() ?? ""),
            items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
            totalOrderItems: _toInt(json["totalOrderItems"]),
            rider: json["rider"] == null ? null : Rider.fromJson(json["rider"]),
            hasOrderSupports: _toBool(json["hasOrderSupports"]),
            hasRiderChat: _toBool(json["hasRiderChat"]),
            hasGrievance: _toBool(json["hasGrievance"]),
            deliveryJob: json["deliveryJob"] == null
                ? null
                : DeliveryJob.fromJson(json["deliveryJob"]),
            orderSteper: _toInt(json["orderSteper"]),
        );
    }

}

class Rider {
    Rider({
        required this.id,
        required this.name,
        required this.profileAvatar,
        required this.phone,
        required this.avgRating,
        required this.ratingCount,
        required this.vehicle,
    });

    final String? id;
    final String? name;
    final String? profileAvatar;
    final String? phone;
    final num? avgRating;
    final int? ratingCount;
    final String? vehicle;

    factory Rider.fromJson(Map<String, dynamic> json) {
        return Rider(
            id: json["_id"]?.toString(),
            name: json["name"]?.toString(),
            profileAvatar: json["profileAvatar"]?.toString(),
            phone: json["phone"]?.toString(),
            avgRating: json["avgRating"] as num?,
            ratingCount: _toInt(json["ratingCount"]),
            vehicle: json["vehicle"]?.toString(),
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
            buildingNo: _toInt(json["buildingNo"]),
            floorNo: _toInt(json["floorNo"]),
            apartment: _toInt(json["apartment"]),
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
            quantity: _toInt(json["quantity"]),
            price: _toInt(json["price"]),
            totalPrice: _toInt(json["totalPrice"]),
            size: json["size"],
            color: json["color"],
            createdAt: DateTime.tryParse(json["createdAt"]?.toString() ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"]?.toString() ?? ""),
        );
    }

}

class Product {
    Product({
        required this.id,
        required this.title,
        required this.titleArabic,
        required this.banner,
        required this.price,
        required this.discountPrice,
    });

    final String? id;
    final String? title;
    final String? titleArabic;
    final String? banner;
    final int? price;
    final int? discountPrice;

    String get displayTitle => LocalizationService.localizedValue(
      english: title,
      arabic: titleArabic,
    );

    factory Product.fromJson(Map<String, dynamic> json){ 
        return Product(
            id: json["_id"]?.toString(),
            title: json["title"]?.toString(),
            titleArabic: json["titleArabic"]?.toString(),
            banner: json["banner"]?.toString(),
            price: _toInt(json["price"]),
            discountPrice: _toInt(json["discountPrice"]),
        );
    }

}

class DeliveryJob {
    DeliveryJob({
        required this.id,
        required this.deliveryType,
        required this.destination,
        required this.distance,
        required this.jobNumber,
        required this.pickup,
        required this.createdAt,
    });

    final String? id;
    final String? deliveryType;
    final Destination? destination;
    final double? distance;
    final String? jobNumber;
    final Pickup? pickup;
    final DateTime? createdAt;

    factory DeliveryJob.fromJson(Map<String, dynamic> json) {
        return DeliveryJob(
            id: json["_id"]?.toString() ?? json["id"]?.toString(),
            deliveryType: json["deliveryType"]?.toString(),
            destination: json["destination"] == null
                ? null
                : Destination.fromJson(
                    Map<String, dynamic>.from(json["destination"]),
                  ),
            distance: (json["distance"] as num?)?.toDouble(),
            jobNumber: json["id"]?.toString(),
            pickup: json["pickup"] == null
                ? null
                : Pickup.fromJson(Map<String, dynamic>.from(json["pickup"])),
            createdAt: DateTime.tryParse(json["createdAt"]?.toString() ?? ""),
        );
    }
}

class Destination {
    Destination({
        required this.address,
        required this.coordinates,
    });

    final String? address;
    final List<double> coordinates;

    factory Destination.fromJson(Map<String, dynamic> json) {
        return Destination(
            address: json["address"]?.toString(),
            coordinates: json["coordinates"] == null
                ? []
                : List<double>.from(
                    (json["coordinates"] as List).map(
                      (x) => (x as num).toDouble(),
                    ),
                  ),
        );
    }
}

class Pickup {
    Pickup({
        required this.address,
        required this.coordinates,
    });

    final String? address;
    final List<double> coordinates;

    factory Pickup.fromJson(Map<String, dynamic> json) {
        return Pickup(
            address: json["address"]?.toString(),
            coordinates: json["coordinates"] == null
                ? []
                : List<double>.from(
                    (json["coordinates"] as List).map(
                      (x) => (x as num).toDouble(),
                    ),
            ),
        );
    }
}

bool? _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) {
        final normalized = value.trim().toLowerCase();
        if (normalized == 'true') return true;
        if (normalized == 'false') return false;
    }
    return null;
}

int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
}
