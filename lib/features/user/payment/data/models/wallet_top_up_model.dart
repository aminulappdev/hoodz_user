class WalletTopUpModel {
  WalletTopUpModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  final bool? success;
  final int? statusCode;
  final String? message;
  final Data? data;

  factory WalletTopUpModel.fromJson(Map<String, dynamic> json) {
    return WalletTopUpModel(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] == null ? null : Data.fromJson(json['data']),
    );
  }
}

class Data {
  Data({
    required this.topUp,
    required this.paymentUrl,
    required this.returnUrl,
    required this.paymentIntentId,
  });

  final TopUp? topUp;
  final String? paymentUrl;
  final String? returnUrl;
  final String? paymentIntentId;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      topUp: json['topUp'] == null ? null : TopUp.fromJson(json['topUp']),
      paymentUrl: json['paymentUrl'],
      returnUrl: json['returnUrl'],
      paymentIntentId: json['paymentIntentId'],
    );
  }
}

class TopUp {
  TopUp({
    required this.id,
    required this.user,
    required this.savedCard,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    required this.transactionId,
    required this.paymentIntentId,
    required this.saveCardRequested,
    required this.isPaid,
    required this.balanceAppliedAt,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? user;
  final dynamic savedCard;
  final int? amount;
  final String? paymentMethod;
  final String? status;
  final String? transactionId;
  final String? paymentIntentId;
  final bool? saveCardRequested;
  final bool? isPaid;
  final DateTime? balanceAppliedAt;
  final bool? isDeleted;
  final String? createdAt;
  final String? updatedAt;

  factory TopUp.fromJson(Map<String, dynamic> json) {
    return TopUp(
      id: json['_id'],
      user: json['user']?.toString(),
      savedCard: json['savedCard'],
      amount: json['amount'],
      paymentMethod: json['paymentMethod'],
      status: json['status'],
      transactionId: json['transactionId'],
      paymentIntentId: json['paymentIntentId'],
      saveCardRequested: json['saveCardRequested'],
      isPaid: json['isPaid'],
      balanceAppliedAt: _parseDateTime(json['balanceAppliedAt']),
      isDeleted: json['isDeleted'],
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is DateTime) {
    return value;
  }

  return DateTime.tryParse(value.toString());
}
