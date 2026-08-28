class GeneralMessageModel {
  GeneralMessageModel({
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

  factory GeneralMessageModel.fromJson(Map<String, dynamic> json) {
    return GeneralMessageModel(
      success: json["success"],
      statusCode: json["statusCode"],
      message: json["message"],
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }
}

class Datum {
  Datum({
    required this.id,
    required this.text,
    required this.files,
    required this.seen,
    required this.isEdited,
    required this.sender,
    required this.senderType,
    required this.createdAt,
  });

  final String? id;
  final String? text;
  final List<dynamic> files;
  final bool? seen;
  final bool? isEdited;
  final dynamic sender;
  final String? senderType;
  final DateTime? createdAt;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json["_id"],
      text: json["text"],
      files: json["files"] == null
          ? []
          : List<dynamic>.from(json["files"]!.map((x) => x)),
      seen: json["seen"],
      isEdited: json["isEdited"],
      sender: json["sender"],
      senderType: json["senderType"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
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

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json["page"],
      limit: json["limit"],
      total: json["total"],
      totalPage: json["totalPage"],
    );
  }
}
