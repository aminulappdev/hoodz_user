class AiAssistantMessagesModel {
  const AiAssistantMessagesModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.meta,
    required this.data,
  });

  final bool? success;
  final int? statusCode;
  final String? message;
  final AiAssistantMessagesMeta? meta;
  final AiAssistantMessagesData? data;

  factory AiAssistantMessagesModel.fromJson(Map<String, dynamic> json) {
    return AiAssistantMessagesModel(
      success: json['success'] as bool?,
      statusCode: json['statusCode'] as int?,
      message: json['message']?.toString(),
      meta: json['meta'] == null
          ? null
          : AiAssistantMessagesMeta.fromJson(
              Map<String, dynamic>.from(json['meta'] as Map),
            ),
      data: json['data'] == null
          ? null
          : AiAssistantMessagesData.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            ),
    );
  }
}

class AiAssistantMessagesData {
  const AiAssistantMessagesData({
    required this.chat,
    required this.messages,
  });

  final AiAssistantChat? chat;
  final List<AiAssistantMessage> messages;

  factory AiAssistantMessagesData.fromJson(Map<String, dynamic> json) {
    return AiAssistantMessagesData(
      chat: json['chat'] == null
          ? null
          : AiAssistantChat.fromJson(
              Map<String, dynamic>.from(json['chat'] as Map),
            ),
      messages: json['messages'] == null
          ? const <AiAssistantMessage>[]
          : List<AiAssistantMessage>.from(
              (json['messages'] as List).whereType<Map>().map(
                    (item) => AiAssistantMessage.fromJson(
                      Map<String, dynamic>.from(item),
                    ),
                  ),
            ),
    );
  }
}

class AiAssistantChat {
  const AiAssistantChat({
    required this.id,
    required this.type,
  });

  final String? id;
  final String? type;

  factory AiAssistantChat.fromJson(Map<String, dynamic> json) {
    return AiAssistantChat(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      type: json['type']?.toString(),
    );
  }
}

class AiAssistantMessage {
  const AiAssistantMessage({
    required this.id,
    required this.text,
    required this.files,
    required this.sender,
    required this.senderType,
    required this.createdAt,
    required this.metadata,
  });

  final String? id;
  final String? text;
  final List<String> files;
  final dynamic sender;
  final String? senderType;
  final DateTime? createdAt;
  final AiAssistantMessageMetadata? metadata;

  factory AiAssistantMessage.fromJson(Map<String, dynamic> json) {
    return AiAssistantMessage(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      text: json['text']?.toString(),
      files: json['files'] == null
          ? const <String>[]
          : List<String>.from((json['files'] as List).map((item) => '$item')),
      sender: json['sender'],
      senderType: json['senderType']?.toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      metadata: json['metadata'] == null
          ? null
          : AiAssistantMessageMetadata.fromJson(
              Map<String, dynamic>.from(json['metadata'] as Map),
            ),
    );
  }

  Map<String, dynamic> toMessageMap({String chatId = ''}) {
    final normalizedSenderType = senderType?.toLowerCase().trim() ?? '';

    return {
      'id': id ?? '',
      'chatId': chatId,
      'text': text ?? '',
      'files': files,
      'isMe': normalizedSenderType == 'user' ||
          normalizedSenderType == 'customer',
      'createdAt': createdAt?.toIso8601String() ??
          DateTime.now().toIso8601String(),
      'products': metadata?.products
              .map((product) => product.toJson())
              .toList(growable: false) ??
          const <Map<String, dynamic>>[],
    };
  }
}

class AiAssistantMessageMetadata {
  const AiAssistantMessageMetadata({
    required this.products,
  });

  final List<AiAssistantProduct> products;

  factory AiAssistantMessageMetadata.fromJson(Map<String, dynamic> json) {
    return AiAssistantMessageMetadata(
      products: json['products'] == null
          ? const <AiAssistantProduct>[]
          : List<AiAssistantProduct>.from(
              (json['products'] as List).whereType<Map>().map(
                    (item) => AiAssistantProduct.fromJson(
                      Map<String, dynamic>.from(item),
                    ),
                  ),
            ),
    );
  }
}

class AiAssistantProduct {
  const AiAssistantProduct({
    required this.id,
    required this.title,
    required this.brand,
    required this.banner,
    required this.price,
    required this.discountPrice,
    required this.avgRating,
    required this.ratingCount,
    required this.categoryTitle,
  });

  final String? id;
  final String? title;
  final String? brand;
  final String? banner;
  final num? price;
  final num? discountPrice;
  final num? avgRating;
  final num? ratingCount;
  final String? categoryTitle;

  factory AiAssistantProduct.fromJson(Map<String, dynamic> json) {
    final category = json['category'];

    return AiAssistantProduct(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      title: json['title']?.toString(),
      brand: json['brand']?.toString(),
      banner: json['banner']?.toString(),
      price: _numValue(json['price']),
      discountPrice: _numValue(json['discountPrice']),
      avgRating: _numValue(json['avgRating']),
      ratingCount: _numValue(json['ratingCount']),
      categoryTitle: category is Map
          ? category['title']?.toString()
          : json['categoryTitle']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'brand': brand,
      'banner': banner,
      'price': price,
      'discountPrice': discountPrice,
      'avgRating': avgRating,
      'ratingCount': ratingCount,
      'categoryTitle': categoryTitle,
    };
  }

  static num? _numValue(dynamic value) {
    if (value is num) return value;
    return num.tryParse(value?.toString() ?? '');
  }
}

class AiAssistantMessagesMeta {
  const AiAssistantMessagesMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPage,
  });

  final int? page;
  final int? limit;
  final int? total;
  final int? totalPage;

  factory AiAssistantMessagesMeta.fromJson(Map<String, dynamic> json) {
    return AiAssistantMessagesMeta(
      page: json['page'] as int?,
      limit: json['limit'] as int?,
      total: json['total'] as int?,
      totalPage: json['totalPage'] as int?,
    );
  }
}
