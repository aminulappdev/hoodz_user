class SaveAddressModel {
  SaveAddressModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  final bool? success;
  final int? statusCode;
  final String? message;
  final List<Datum> data;

  factory SaveAddressModel.fromJson(Map<String, dynamic> json) {
    return SaveAddressModel(
      success: json["success"],
      statusCode: _toInt(json["statusCode"]),
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }
}

class Datum {
  Datum({
    required this.id,
    required this.user,
    required this.name,
    required this.location,
    required this.buildingNo,
    required this.floorNo,
    required this.apartment,
    required this.city,
    required this.country,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? user;
  final String? name;
  final Location? location;
  final int? buildingNo;
  final int? floorNo;
  final int? apartment;
  final String? city;
  final String? country;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json["_id"]?.toString(),
      user: json["user"]?.toString(),
      name: json["name"]?.toString(),
      location: json["location"] == null ? null : Location.fromJson(json["location"]),
      buildingNo: _toInt(json["buildingNo"]),
      floorNo: _toInt(json["floorNo"]),
      apartment: _toInt(json["apartment"]),
      city: json["city"]?.toString(),
      country: json["country"]?.toString(),
      createdAt: DateTime.tryParse(json["createdAt"]?.toString() ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"]?.toString() ?? ""),
    );
  }
}

class Location {
  Location({
    required this.type,
    required this.coordinates,
  });

  final String? type;
  final List<double> coordinates;

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json["type"]?.toString(),
      coordinates: json["coordinates"] == null
          ? []
          : List<double>.from(
              (json["coordinates"] as List).map((x) => _toDouble(x) ?? 0),
            ),
    );
  }
}

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

double? _toDouble(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}
