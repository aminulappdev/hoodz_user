class CustomerSupportChatListResponse {
  CustomerSupportChatListResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.meta,
    required this.data,
  });

  final bool? success;
  final int? statusCode;
  final String? message;
  final CustomerSupportChatListMeta? meta;
  final CustomerSupportChatBuckets? data;

  factory CustomerSupportChatListResponse.fromJson(Map<String, dynamic> json) {
    final dataSource = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'])
        : json;

    return CustomerSupportChatListResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message']?.toString(),
      meta: json['meta'] is Map
          ? CustomerSupportChatListMeta.fromJson(
              Map<String, dynamic>.from(json['meta']),
            )
          : null,
      data: CustomerSupportChatBuckets.fromJson(dataSource),
    );
  }
}

class CustomerSupportChatBuckets {
  CustomerSupportChatBuckets({
    required this.customerSupport,
    required this.orderSupport,
  });

  final List<CustomerSupportChat> customerSupport;
  final List<CustomerSupportChat> orderSupport;

  factory CustomerSupportChatBuckets.fromJson(Map<String, dynamic> json) {
    return CustomerSupportChatBuckets(
      customerSupport: parseChats(json['customer_support']),
      orderSupport: parseChats(json['order_support']),
    );
  }

  static List<CustomerSupportChat> parseChats(dynamic value) {
    if (value is! List) {
      return <CustomerSupportChat>[];
    }

    return value
        .whereType<Map>()
        .map(
          (item) => CustomerSupportChat.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }
}

class CustomerSupportChat {
  CustomerSupportChat({
    required this.id,
    required this.type,
    required this.order,
    required this.createdAt,
    required this.participants,
    required this.lastMessage,
  });

  final String? id;
  final String? type;
  final dynamic order;
  final DateTime? createdAt;
  final List<CustomerSupportChatParticipant> participants;
  final CustomerSupportLastMessage? lastMessage;

  factory CustomerSupportChat.fromJson(Map<String, dynamic> json) {
    return CustomerSupportChat(
      id: json['_id']?.toString(),
      type: json['type']?.toString(),
      order: json['order'],
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      participants: json['participants'] is List
          ? (json['participants'] as List)
              .whereType<Map>()
              .map(
                (item) => CustomerSupportChatParticipant.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : <CustomerSupportChatParticipant>[],
      lastMessage: json['lastMessage'] is Map
          ? CustomerSupportLastMessage.fromJson(
              Map<String, dynamic>.from(json['lastMessage']),
            )
          : null,
    );
  }
}

class CustomerSupportChatParticipant {
  CustomerSupportChatParticipant({
    required this.user,
  });

  final CustomerSupportChatUser? user;

  factory CustomerSupportChatParticipant.fromJson(Map<String, dynamic> json) {
    return CustomerSupportChatParticipant(
      user: json['user'] is Map
          ? CustomerSupportChatUser.fromJson(
              Map<String, dynamic>.from(json['user']),
            )
          : null,
    );
  }
}

class CustomerSupportChatUser {
  CustomerSupportChatUser({
    required this.id,
    required this.name,
    required this.profileAvatar,
    required this.role,
  });

  final String? id;
  final String? name;
  final String? profileAvatar;
  final String? role;

  factory CustomerSupportChatUser.fromJson(Map<String, dynamic> json) {
    return CustomerSupportChatUser(
      id: json['_id']?.toString(),
      name: json['name']?.toString(),
      profileAvatar: json['profileAvatar']?.toString(),
      role: json['role']?.toString(),
    );
  }
}

class CustomerSupportLastMessage {
  CustomerSupportLastMessage({
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

  factory CustomerSupportLastMessage.fromJson(Map<String, dynamic> json) {
    return CustomerSupportLastMessage(
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

class CustomerSupportChatListMeta {
  CustomerSupportChatListMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPage,
  });

  final int? page;
  final int? limit;
  final int? total;
  final int? totalPage;

  factory CustomerSupportChatListMeta.fromJson(Map<String, dynamic> json) {
    return CustomerSupportChatListMeta(
      page: json['page'] as int?,
      limit: json['limit'] as int?,
      total: json['total'] as int?,
      totalPage: json['totalPage'] as int?,
    );
  }
}
