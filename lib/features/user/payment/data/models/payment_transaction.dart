class PaymentTransactionModel {
    PaymentTransactionModel({
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

    factory PaymentTransactionModel.fromJson(Map<String, dynamic> json){ 
        return PaymentTransactionModel(
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
        required this.walletBalance,
        required this.transactions,
    });

    final int? walletBalance;
    final List<Transaction> transactions;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            walletBalance: json["walletBalance"],
            transactions: json["transactions"] == null ? [] : List<Transaction>.from(json["transactions"]!.map((x) => Transaction.fromJson(x))),
        );
    }

}

class Transaction {
    Transaction({
        required this.id,
        required this.order,
        required this.transactionTransactionId,
        required this.paymentIntentId,
        required this.subtotalAmount,
        required this.coinDiscount,
        required this.deliveryCharge,
        required this.amount,
        required this.status,
        required this.paymentMethod,
        required this.isPaid,
        required this.transactionId,
        required this.createdAt,
    });

    final String? id;
    final Order? order;
    final dynamic transactionTransactionId;
    final String? paymentIntentId;
    final int? subtotalAmount;
    final int? coinDiscount;
    final int? deliveryCharge;
    final int? amount;
    final String? status;
    final String? paymentMethod;
    final bool? isPaid;
    final String? transactionId;
    final DateTime? createdAt;

    factory Transaction.fromJson(Map<String, dynamic> json){ 
        return Transaction(
            id: json["_id"],
            order: json["order"] == null ? null : Order.fromJson(json["order"]),
            transactionTransactionId: json["transactionId"],
            paymentIntentId: json["paymentIntentId"],
            subtotalAmount: json["subtotalAmount"],
            coinDiscount: json["coinDiscount"],
            deliveryCharge: json["deliveryCharge"],
            amount: json["amount"],
            status: json["status"],
            paymentMethod: json["paymentMethod"],
            isPaid: json["isPaid"],
            transactionId: json["id"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
        );
    }

}

class Order {
    Order({
        required this.id,
        required this.orderId,
    });

    final String? id;
    final String? orderId;

    factory Order.fromJson(Map<String, dynamic> json){ 
        return Order(
            id: json["_id"],
            orderId: json["id"],
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
