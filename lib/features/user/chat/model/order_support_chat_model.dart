class OrderSupportChatResponse {
  OrderSupportChatResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  final bool? success;
  final int? statusCode;
  final String? message;
  final OrderSupportChatData? data;

  factory OrderSupportChatResponse.fromJson(Map<String, dynamic> json) {
    final dataSource = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'])
        : json;

    return OrderSupportChatResponse(
      success: json['success'],
      statusCode: json['statusCode'] ?? json['status'],
      message: json['message']?.toString(),
      data: OrderSupportChatData.fromJson(dataSource),
    );
  }
}

class OrderSupportChatData {
  OrderSupportChatData({
    required this.id,
    required this.type,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
    required this.participants,
    required this.lastMessage,
  });

  final String? id;
  final String? type;
  final dynamic order;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<OrderSupportChatParticipant> participants;
  final OrderSupportLastMessage? lastMessage;

  factory OrderSupportChatData.fromJson(Map<String, dynamic> json) {
    return OrderSupportChatData(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      type: json['type']?.toString(),
      order: json['order'],
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
      participants: json['participants'] is List
          ? (json['participants'] as List)
              .whereType<Map>()
              .map(
                (item) => OrderSupportChatParticipant.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : <OrderSupportChatParticipant>[],
      lastMessage: json['lastMessage'] is Map
          ? OrderSupportLastMessage.fromJson(
              Map<String, dynamic>.from(json['lastMessage']),
            )
          : null,
    );
  }
}

class OrderSupportChatParticipant {
  OrderSupportChatParticipant({
    required this.user,
  });

  final OrderSupportChatUser? user;

  factory OrderSupportChatParticipant.fromJson(Map<String, dynamic> json) {
    return OrderSupportChatParticipant(
      user: json['user'] is Map
          ? OrderSupportChatUser.fromJson(
              Map<String, dynamic>.from(json['user']),
            )
          : null,
    );
  }
}

class OrderSupportChatUser {
  OrderSupportChatUser({
    required this.id,
    required this.name,
    required this.profileAvatar,
    required this.role,
  });

  final String? id;
  final String? name;
  final String? profileAvatar;
  final String? role;

  factory OrderSupportChatUser.fromJson(Map<String, dynamic> json) {
    return OrderSupportChatUser(
      id: json['_id']?.toString(),
      name: json['name']?.toString(),
      profileAvatar: json['profileAvatar']?.toString(),
      role: json['role']?.toString(),
    );
  }
}

class OrderSupportLastMessage {
  OrderSupportLastMessage({
    required this.id,
    required this.text,
    required this.files,
    required this.seen,
    required this.isEdited,
    required this.sender,
    required this.createdAt,
  });

  final String? id;
  final String? text;
  final List<dynamic> files;
  final bool? seen;
  final bool? isEdited;
  final dynamic sender;
  final DateTime? createdAt;

  factory OrderSupportLastMessage.fromJson(Map<String, dynamic> json) {
    return OrderSupportLastMessage(
      id: json['_id']?.toString(),
      text: json['text']?.toString(),
      files: json['files'] is List
          ? List<dynamic>.from(json['files'] as List)
          : <dynamic>[],
      seen: json['seen'] as bool?,
      isEdited: json['isEdited'] as bool?,
      sender: json['sender'],
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }
}
