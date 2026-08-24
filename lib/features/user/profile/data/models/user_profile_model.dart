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

    factory UserProfileModel.fromJson(Map<String, dynamic> json){ 
        return UserProfileModel(
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
        required this.balance,
        required this.walletBalance,
        required this.followers,
        required this.status,
        required this.isProfileSetUp,
        required this.isOnline,
        required this.isDeleted,
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
    final int? avgRating;
    final int? ratingCount;
    final int? coins;
    final int? balance;
    final int? walletBalance;
    final int? followers;
    final String? status;
    final bool? isProfileSetUp;
    final bool? isOnline;
    final bool? isDeleted;
    final String? dataId;
    final String? referralCode;
    final DateTime? createdAt;
    final DateTime? passwordChangedAt;
    final String? address;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            id: json["_id"],
            referredBy: json["referredBy"],
            referralCodeUsed: json["referralCodeUsed"],
            name: json["name"],
            email: json["email"],
            fcmToken: json["fcmToken"],
            profileAvatar: json["profileAvatar"],
            coverPhoto: json["coverPhoto"],
            description: json["description"],
            gender: json["gender"],
            dob: DateTime.tryParse(json["dob"] ?? ""),
            countryCode: json["countryCode"],
            phone: json["phone"],
            location: json["location"] == null ? null : Location.fromJson(json["location"]),
            deliveryAddress: json["deliveryAddress"] == null
                ? null
                : DeliveryAddress.fromJson(json["deliveryAddress"]),
            deliveryLocation: json["deliveryLocation"] == null ? null : Location.fromJson(json["deliveryLocation"]),
            timeZone: json["timeZone"],
            role: json["role"],
            registerWith: json["registerWith"],
            avgRating: json["avgRating"],
            ratingCount: json["ratingCount"],
            coins: json["coins"] ?? json["balance"],
            balance: json["balance"] ?? json["coins"],
            walletBalance: json["walletBalance"],
            followers: json["followers"],
            status: json["status"],
            isProfileSetUp: json["isProfileSetUp"],
            isOnline: json["isOnline"],
            isDeleted: json["isDeleted"],
            dataId: json["id"],
            referralCode: json["referralCode"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            passwordChangedAt: DateTime.tryParse(json["passwordChangedAt"] ?? ""),
            address: json["address"],
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

    factory Location.fromJson(Map<String, dynamic> json){ 
        return Location(
            type: json["type"],
            coordinates: json["coordinates"] == null ? [] : List<num>.from(json["coordinates"]!),
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
    final int? buildingNo;
    final int? floorNo;
    final int? apartment;
    final String? city;
    final String? country;

    factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
        return DeliveryAddress(
            name: json["name"],
            location: json["location"] == null
                ? null
                : Location.fromJson(json["location"]),
            buildingNo: json["buildingNo"],
            floorNo: json["floorNo"],
            apartment: json["apartment"],
            city: json["city"],
            country: json["country"],
        );
    }
}
