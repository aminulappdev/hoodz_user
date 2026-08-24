class CardPaymentSucessModel {
    CardPaymentSucessModel({
        required this.success,
        required this.statusCode,
        required this.message,
        required this.data,
    });

    final bool? success;
    final int? statusCode;
    final String? message;
    final Data? data;

    factory CardPaymentSucessModel.fromJson(Map<String, dynamic> json){ 
        return CardPaymentSucessModel(
            success: json["success"],
            statusCode: json["statusCode"],
            message: json["message"],
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.paymentMethod,
        required this.paymentIntentId,
        required this.paymentUrl,
        required this.returnUrl,
        required this.payments,
    });

    final String? paymentMethod;
    final String? paymentIntentId;
    final String? paymentUrl;
    final String? returnUrl;
    final List<Payment> payments;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            paymentMethod: json["paymentMethod"],
            paymentIntentId: json["paymentIntentId"],
            paymentUrl: json["paymentUrl"],
            returnUrl: json["returnUrl"],
            payments: json["payments"] == null ? [] : List<Payment>.from(json["payments"]!.map((x) => Payment.fromJson(x))),
        );
    }

}

class Payment {
    Payment({
        required this.id,
        required this.account,
        required this.order,
        required this.transactionId,
        required this.paymentIntentId,
        required this.savedCard,
        required this.saveCardRequested,
        required this.subtotalAmount,
        required this.coinDiscount,
        required this.deliveryCharge,
        required this.amount,
        required this.status,
        required this.paymentMethod,
        required this.isPaid,
        required this.isDeleted,
        required this.paymentId,
        required this.createdAt,
        required this.updatedAt,
    });

    final String? id;
    final Account? account;
    final Order? order;
    final dynamic transactionId;
    final String? paymentIntentId;
    final dynamic savedCard;
    final bool? saveCardRequested;
    final int? subtotalAmount;
    final int? coinDiscount;
    final int? deliveryCharge;
    final int? amount;
    final String? status;
    final String? paymentMethod;
    final bool? isPaid;
    final bool? isDeleted;
    final String? paymentId;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    factory Payment.fromJson(Map<String, dynamic> json){ 
        return Payment(
            id: json["_id"],
            account: json["account"] == null ? null : Account.fromJson(json["account"]),
            order: json["order"] == null ? null : Order.fromJson(json["order"]),
            transactionId: json["transactionId"],
            paymentIntentId: json["paymentIntentId"],
            savedCard: json["savedCard"],
            saveCardRequested: json["saveCardRequested"],
            subtotalAmount: json["subtotalAmount"],
            coinDiscount: json["coinDiscount"],
            deliveryCharge: json["deliveryCharge"],
            amount: json["amount"],
            status: json["status"],
            paymentMethod: json["paymentMethod"],
            isPaid: json["isPaid"],
            isDeleted: json["isDeleted"],
            paymentId: json["id"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
        );
    }

}

class Account {
    Account({
        required this.id,
        required this.name,
        required this.email,
        required this.profileAvatar,
        required this.phone,
    });

    final String? id;
    final String? name;
    final String? email;
    final String? profileAvatar;
    final String? phone;

    factory Account.fromJson(Map<String, dynamic> json){ 
        return Account(
            id: json["_id"],
            name: json["name"],
            email: json["email"],
            profileAvatar: json["profileAvatar"],
            phone: json["phone"],
        );
    }

}

class Order {
    Order({
        required this.id,
        required this.amount,
        required this.coinDiscount,
        required this.deliveryCharge,
        required this.totalAmount,
        required this.status,
        required this.paymentStatus,
        required this.billingDetails,
        required this.orderId,
    });

    final String? id;
    final int? amount;
    final int? coinDiscount;
    final int? deliveryCharge;
    final int? totalAmount;
    final String? status;
    final String? paymentStatus;
    final BillingDetails? billingDetails;
    final String? orderId;

    factory Order.fromJson(Map<String, dynamic> json){ 
        return Order(
            id: json["_id"],
            amount: json["amount"],
            coinDiscount: json["coinDiscount"],
            deliveryCharge: json["deliveryCharge"],
            totalAmount: json["totalAmount"],
            status: json["status"],
            paymentStatus: json["paymentStatus"],
            billingDetails: json["billingDetails"] == null ? null : BillingDetails.fromJson(json["billingDetails"]),
            orderId: json["id"],
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
            coordinates: json["coordinates"] == null ? [] : List<double>.from(json["coordinates"]!.map((x) => x)),
            latitude: json["latitude"],
            longitude: json["longitude"],
        );
    }

}
