class WalletTransactionModel {
    WalletTransactionModel({
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

    factory WalletTransactionModel.fromJson(Map<String, dynamic> json){ 
        return WalletTransactionModel(
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
        required this.referenceType,
        required this.type,
        required this.reference,
        required this.amount,
        required this.createdAt,
        required this.direction,
        required this.transactionId,
        required this.note,
        required this.paymobTransactionId,
        required this.savedCard,
        required this.status,
    });

    final String? id;
    final String? referenceType;
    final String? type;
    final String? reference;
    final int? amount;
    final DateTime? createdAt;
    final String? direction;
    final String? transactionId;
    final String? note;
    final String? paymobTransactionId;
    final dynamic savedCard;
    final String? status;

    factory Transaction.fromJson(Map<String, dynamic> json){ 
        return Transaction(
            id: json["_id"],
            referenceType: json["referenceType"],
            type: json["type"],
            reference: json["reference"],
            amount: json["amount"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            direction: json["direction"],
            transactionId: json["id"],
            note: json["note"],
            paymobTransactionId: json["paymobTransactionId"],
            savedCard: json["savedCard"],
            status: json["status"],
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
