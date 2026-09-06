class UserProfileModel {
  UserProfileModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  final bool? success;
  final int? statusCode;
  final String? message;
  final Data? data;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      success: _toBool(json["success"]),
      statusCode: _toInt(json["statusCode"]),
      message: json["message"]?.toString(),
      data: json["data"] == null
          ? null
          : Data.fromJson(Map<String, dynamic>.from(json["data"])),
    );
  }
}

class Data {
  Data({
    required this.id,
    required this.referredBy,
    required this.referralCodeUsed,
    required this.name,
    required this.email,
    required this.fcmToken,
    required this.profileAvatar,
    required this.coverPhoto,
    required this.description,
    required this.gender,
    required this.dob,
    required this.countryCode,
    required this.phone,
    required this.location,
    required this.deliveryAddress,
    required this.deliveryLocation,
    required this.timeZone,
    required this.role,
    required this.registerWith,
    required this.avgRating,
    required this.ratingCount,
    required this.coins,
    required this.coinsPerEgp,
    required this.balance,
    required this.walletBalance,
    required this.followers,
    required this.status,
    required this.isProfileSetUp,
    required this.isOnline,
    required this.isDeleted,
    required this.needsPasswordChange,
    required this.hasCustomerSupport,
    required this.unreadChatCount,
    required this.dataId,
    required this.referralCode,
    required this.createdAt,
    required this.passwordChangedAt,
    required this.address,
  });

  final String? id;
  final dynamic referredBy;
  final dynamic referralCodeUsed;
  final String? name;
  final String? email;
  final String? fcmToken;
  final String? profileAvatar;
  final dynamic coverPhoto;
  final dynamic description;
  final String? gender;
  final DateTime? dob;
  final String? countryCode;
  final String? phone;
  final Location? location;
  final DeliveryAddress? deliveryAddress;
  final Location? deliveryLocation;
  final String? timeZone;
  final String? role;
  final String? registerWith;
  final num? avgRating;
  final int? ratingCount;
  final int? coins;
  final int? coinsPerEgp;
  final num? balance;
  final num? walletBalance;
  final int? followers;
  final String? status;
  final bool? isProfileSetUp;
  final bool? isOnline;
  final bool? isDeleted;
  final bool? needsPasswordChange;
  final bool? hasCustomerSupport;
  final int? unreadChatCount;
  final String? dataId;
  final String? referralCode;
  final DateTime? createdAt;
  final DateTime? passwordChangedAt;
  final String? address;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json["_id"]?.toString(),
      referredBy: json["referredBy"],
      referralCodeUsed: json["referralCodeUsed"],
      name: json["name"]?.toString(),
      email: json["email"]?.toString(),
      fcmToken: json["fcmToken"]?.toString(),
      profileAvatar: json["profileAvatar"]?.toString(),
      coverPhoto: json["coverPhoto"],
      description: json["description"],
      gender: json["gender"]?.toString(),
      dob: DateTime.tryParse(json["dob"]?.toString() ?? ""),
      countryCode: json["countryCode"]?.toString(),
      phone: json["phone"]?.toString(),
      location: json["location"] == null
          ? null
          : Location.fromJson(Map<String, dynamic>.from(json["location"])),
      deliveryAddress: json["deliveryAddress"] == null
          ? null
          : DeliveryAddress.fromJson(
              Map<String, dynamic>.from(json["deliveryAddress"]),
            ),
      deliveryLocation: json["deliveryLocation"] == null
          ? null
          : Location.fromJson(
              Map<String, dynamic>.from(json["deliveryLocation"]),
            ),
      timeZone: json["timeZone"]?.toString(),
      role: json["role"]?.toString(),
      registerWith: json["registerWith"]?.toString(),
      avgRating: _toNum(json["avgRating"]),
      ratingCount: _toInt(json["ratingCount"]),
      coins: _toInt(json["coins"] ?? json["balance"]),
      coinsPerEgp: _toInt(json["coinsPerEgp"]),
      balance: _toNum(json["balance"] ?? json["coins"]),
      walletBalance: _toNum(json["walletBalance"]),
      followers: _toInt(json["followers"]),
      status: json["status"]?.toString(),
      isProfileSetUp: _toBool(json["isProfileSetUp"]),
      isOnline: _toBool(json["isOnline"]),
      isDeleted: _toBool(json["isDeleted"]),
      needsPasswordChange: _toBool(json["needsPasswordChange"]),
      hasCustomerSupport: _toBool(json["hasCustomerSupport"]),
      unreadChatCount: _toInt(json["unreadChatCount"]),
      dataId: json["id"]?.toString(),
      referralCode: json["referralCode"]?.toString(),
      createdAt: DateTime.tryParse(json["createdAt"]?.toString() ?? ""),
      passwordChangedAt:
          DateTime.tryParse(json["passwordChangedAt"]?.toString() ?? ""),
      address: json["address"]?.toString(),
    );
  }
}

class Location {
  Location({
    required this.type,
    required this.coordinates,
  });

  final String? type;
  final List<num> coordinates;

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json["type"]?.toString(),
      coordinates: json["coordinates"] is List
          ? (json["coordinates"] as List)
              .map(_toNum)
              .whereType<num>()
              .toList()
          : [],
    );
  }
}

class DeliveryAddress {
  DeliveryAddress({
    required this.name,
    required this.location,
    required this.buildingNo,
    required this.floorNo,
    required this.apartment,
    required this.city,
    required this.country,
  });

  final String? name;
  final Location? location;
  final dynamic buildingNo;
  final dynamic floorNo;
  final dynamic apartment;
  final String? city;
  final String? country;

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      name: json["name"]?.toString(),
      location: json["location"] == null
          ? null
          : Location.fromJson(Map<String, dynamic>.from(json["location"])),
      buildingNo: json["buildingNo"],
      floorNo: json["floorNo"],
      apartment: json["apartment"],
      city: json["city"]?.toString(),
      country: json["country"]?.toString(),
    );
  }
}

num? _toNum(dynamic value) {
  if (value is num) {
    return value;
  }

  return num.tryParse(value?.toString() ?? '');
}

int? _toInt(dynamic value) {
  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value?.toString() ?? '');
}

bool? _toBool(dynamic value) {
  if (value is bool) {
    return value;
  }

  final normalizedValue = value?.toString().toLowerCase();
  if (normalizedValue == 'true') {
    return true;
  }
  if (normalizedValue == 'false') {
    return false;
  }

  return null;
}
