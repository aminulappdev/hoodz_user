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
        required this.description,
        required this.read,
        required this.date,
    });

    final String? id;
    final String? reference;
    final String? modelType;
    final String? message;
    final String? description;
    final bool? read;
    final DateTime? date;

    Datum copyWith({
        String? id,
        String? reference,
        String? modelType,
        String? message,
        String? description,
        bool? read,
        DateTime? date,
    }) {
        return Datum(
            id: id ?? this.id,
            reference: reference ?? this.reference,
            modelType: modelType ?? this.modelType,
            message: message ?? this.message,
            description: description ?? this.description,
            read: read ?? this.read,
            date: date ?? this.date,
        );
    }

    factory Datum.fromJson(Map<String, dynamic> json){ 
        return Datum(
            id: json["_id"],
            reference: json["reference"],
            modelType: json["modelType"],
            message: json["message"],
            description: json["description"],
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
