class ShopDetailsModel {
  ShopDetailsModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  final bool? success;
  final dynamic statusCode;
  final String? message;
  final Data? data;

  factory ShopDetailsModel.fromJson(Map<String, dynamic> json) {
    return ShopDetailsModel(
      success: json["success"],
      statusCode: json["statusCode"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }
}

class Data {
  Data({
    required this.shop,
    required this.distance,
    required this.categories,
    required this.policies,
  });

  final Shop? shop;
  final Distance? distance;
  final List<Category> categories;
  final Policies? policies;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      shop: json["shop"] == null ? null : Shop.fromJson(json["shop"]),
      distance: json["distance"] == null
          ? null
          : Distance.fromJson(json["distance"]),
      categories: json["categories"] == null
          ? []
          : List<Category>.from(
              json["categories"]!.map((x) => Category.fromJson(x)),
            ),
      policies: json["policies"] == null
          ? null
          : Policies.fromJson(json["policies"]),
    );
  }
}

class Category {
  Category({required this.id, required this.title});

  final String? id;
  final String? title;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json["_id"], title: json["title"]);
  }
}

class Distance {
  Distance({required this.distanceKm, required this.durationMinutes});

  final dynamic distanceKm;
  final dynamic durationMinutes;

  factory Distance.fromJson(Map<String, dynamic> json) {
    return Distance(
      distanceKm: json["distanceKm"],
      durationMinutes: json["durationMinutes"],
    );
  }
}

class Policies {
  Policies({
    required this.returnPolicyTime,
    required this.deliveryMinTime,
    required this.deliveryMaxTime,
    required this.instantDeliveryMinTime,
    required this.instantDeliveryMaxTime,
    required this.isInstantDeliveryAvailable,
    required this.openingTime,
    required this.closingTime,
    required this.weekends,
    required this.timezone,
  });

  final Time? returnPolicyTime;
  final Time? deliveryMinTime;
  final Time? deliveryMaxTime;
  final Time? instantDeliveryMinTime;
  final Time? instantDeliveryMaxTime;
  final bool? isInstantDeliveryAvailable;
  final String? openingTime;
  final String? closingTime;
  final List<String> weekends;
  final String? timezone;

  factory Policies.fromJson(Map<String, dynamic> json) {
    return Policies(
      returnPolicyTime: json["returnPolicyTime"] == null
          ? null
          : Time.fromJson(json["returnPolicyTime"]),
      deliveryMinTime: json["deliveryMinTime"] == null
          ? null
          : Time.fromJson(json["deliveryMinTime"]),
      deliveryMaxTime: json["deliveryMaxTime"] == null
          ? null
          : Time.fromJson(json["deliveryMaxTime"]),
      instantDeliveryMinTime: json["instantDeliveryMinTime"] == null
          ? null
          : Time.fromJson(json["instantDeliveryMinTime"]),
      instantDeliveryMaxTime: json["instantDeliveryMaxTime"] == null
          ? null
          : Time.fromJson(json["instantDeliveryMaxTime"]),
      isInstantDeliveryAvailable: json["isInstantDeliveryAvailable"],
      openingTime: json["openingTime"],
      closingTime: json["closingTime"],
      weekends: json["weekends"] == null
          ? []
          : List<String>.from(json["weekends"]!.map((x) => x)),
      timezone: json["timezone"],
    );
  }
}

class Time {
  Time({required this.time, required this.unit});

  final dynamic time;
  final String? unit;

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(time: json["time"], unit: json["unit"]);
  }
}

class Shop {
  Shop({
    required this.id,
    required this.name,
    required this.profileAvatar,
    required this.coverPhoto,
    required this.description,
    required this.phone,
    required this.location,
    required this.shopId,
    required this.createdAt,
    required this.followers,
    required this.address,
    required this.avgRating,
    required this.ratingCount,
    required this.isFollowing,
    required this.isWishlisted,
  });

  final String? id;
  final String? name;
  final String? profileAvatar;
  final String? coverPhoto;
  final String? description;
  final String? phone;
  final Location? location;
  final String? shopId;
  final DateTime? createdAt;
  final dynamic followers;
  final String? address;
  final dynamic avgRating;
  final dynamic ratingCount;
  final bool? isFollowing;
  final bool? isWishlisted;

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json["_id"],
      name: json["name"],
      profileAvatar: json["profileAvatar"],
      coverPhoto: json["coverPhoto"],
      description: json["description"],
      phone: json["phone"],
      location: json["location"] == null
          ? null
          : Location.fromJson(json["location"]),
      shopId: json["id"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      followers: json["followers"],
      address: json["address"],
      avgRating: json["avgRating"],
      ratingCount: json["ratingCount"],
      isFollowing: json["isFollowing"],
      isWishlisted: json["isWishlisted"],
    );
  }
}

class Location {
  Location({required this.type, required this.coordinates});

  final String? type;
  final List<dynamic> coordinates;

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json["type"],
      coordinates: json["coordinates"] == null
          ? []
          : List<dynamic>.from(json["coordinates"]!.map((x) => x)),
    );
  }
}
