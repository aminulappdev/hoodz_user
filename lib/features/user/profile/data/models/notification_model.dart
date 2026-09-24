import 'package:hoodz/app/translator/localization_service.dart';

class MyNotificationModel {
    MyNotificationModel({
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
    final List<Datum> data;

    factory MyNotificationModel.fromJson(Map<String, dynamic> json){ 
        return MyNotificationModel(
            success: json["success"],
            statusCode: json["statusCode"],
            message: json["message"],
            meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
            data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        );
    }

}

class Datum {
    Datum({
        required this.id,
        required this.reference,
        required this.modelType,
        required this.message,
        required this.messageArabic,
        required this.description,
        required this.descriptionArabic,
        required this.read,
        required this.date,
    });

    final String? id;
    final String? reference;
    final String? modelType;
    final String? message;
    final String? messageArabic;
    final String? description;
    final String? descriptionArabic;
    final bool? read;
    final DateTime? date;

    String get displayMessage => LocalizationService.localizedValue(
      english: message,
      arabic: messageArabic,
    );

    String get displayDescription => LocalizationService.localizedValue(
      english: description,
      arabic: descriptionArabic,
    );

    Datum copyWith({
        String? id,
        String? reference,
        String? modelType,
        String? message,
        String? messageArabic,
        String? description,
        String? descriptionArabic,
        bool? read,
        DateTime? date,
    }) {
        return Datum(
            id: id ?? this.id,
            reference: reference ?? this.reference,
            modelType: modelType ?? this.modelType,
            message: message ?? this.message,
            messageArabic: messageArabic ?? this.messageArabic,
            description: description ?? this.description,
            descriptionArabic: descriptionArabic ?? this.descriptionArabic,
            read: read ?? this.read,
            date: date ?? this.date,
        );
    }

    factory Datum.fromJson(Map<String, dynamic> json){ 
        return Datum(
            id: json["_id"],
            reference: json["reference"],
            modelType: json["modelType"],
            message: json["message"]?.toString(),
            messageArabic: json["messageArabic"]?.toString(),
            description: json["description"]?.toString(),
            descriptionArabic: json["descriptionArabic"]?.toString(),
            read: json["read"],
            date: DateTime.tryParse(json["date"] ?? ""),
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
