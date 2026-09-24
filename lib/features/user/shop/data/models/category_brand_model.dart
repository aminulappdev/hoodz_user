import 'package:hoodz/app/translator/localization_service.dart';

class CategoryBrandModel {
  CategoryBrandModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });  

  final bool? success;
  final int? statusCode;
  final String? message;
  final List<CategoryBrandItemModel> data;

  factory CategoryBrandModel.fromJson(Map<String, dynamic> json) {
    return CategoryBrandModel(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] == null
          ? []
          : List<CategoryBrandItemModel>.from(
              json['data'].map((x) => CategoryBrandItemModel.fromJson(x)),
            ),
    );
  }
}

class CategoryBrandItemModel {
  CategoryBrandItemModel({
    required this.id,
    required this.title,
    required this.titleArabic,
    required this.icon,
    required this.iconArabic,
    required this.name,
    required this.profileAvatar,
    required this.avgRating,
    required this.ratingCount,
    required this.followers,
    required this.distance,
    required this.eta,
  });

  final String? id;
  final String? title;
  final String? titleArabic;
  final String? icon;
  final String? iconArabic;
  final String? name;
  final String? profileAvatar;
  final double? avgRating;
  final int? ratingCount;
  final int? followers;
  final double? distance;
  final int? eta;

  String get displayTitle => LocalizationService.localizedValue(
    english: title ?? name,
    arabic: titleArabic,
  );

  String get displayImage => LocalizationService.localizedValue(
    english: icon ?? profileAvatar,
    arabic: iconArabic,
  );

  factory CategoryBrandItemModel.fromJson(Map<String, dynamic> json) {
    return CategoryBrandItemModel(
      id: json['_id']?.toString(),
      title: json['title']?.toString(),
      titleArabic: json['titleArabic']?.toString(),
      icon: json['icon']?.toString(),
      iconArabic: json['iconArabic']?.toString(),
      name: json['name']?.toString(),
      profileAvatar: json['profileAvatar']?.toString(),
      avgRating: _toDouble(json['avgRating']),
      ratingCount: _toInt(json['ratingCount']),
      followers: _toInt(json['followers']),
      distance: _toDouble(json['distance']),
      eta: _toInt(json['eta']),
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
  }

  static int? _toInt(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is double) {
      return value.toInt();
    }
    return int.tryParse(value.toString());
  }
}
