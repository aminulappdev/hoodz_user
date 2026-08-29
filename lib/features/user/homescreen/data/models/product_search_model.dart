class ProductSearchModel {
    ProductSearchModel({
        required this.success,
        required this.statusCode,
        required this.message,
        required this.data,
    });

    final bool? success;
    final int? statusCode;
    final String? message;
    final Data? data;

    factory ProductSearchModel.fromJson(Map<String, dynamic> json){ 
        return ProductSearchModel(
            success: json["success"],
            statusCode: json["statusCode"],
            message: json["message"],
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.suggestions,
    });

    final List<Suggestion> suggestions;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            suggestions: json["suggestions"] == null ? [] : List<Suggestion>.from(json["suggestions"]!.map((x) => Suggestion.fromJson(x))),
        );
    }

}

class Suggestion {
    Suggestion({
        required this.query,
        required this.resultCount,
    });

    final String? query;
    final int? resultCount;

    factory Suggestion.fromJson(Map<String, dynamic> json){ 
        return Suggestion(
            query: json["query"],
            resultCount: json["resultCount"],
        );
    }

}
