// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hoodz/core/services/network_caller/error_message_model.dart';
import 'package:hoodz/core/services/network_caller/network_response.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:logger/web.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class NetworkCaller {
  final Logger _logger = Logger();

  // Compress single image and return compressed File (fallback to original if fails)
  Future<File?> _compressImage(File originalFile) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final fileName = 'comp_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final targetPath = path.join(tempDir.path, fileName);

      final XFile? compressedXFile =
          await FlutterImageCompress.compressAndGetFile(
            originalFile.absolute.path,
            targetPath,
            quality: 70,
            format: CompressFormat.jpeg,
          );

      if (compressedXFile == null) {
        print('Compression failed: XFile is null');
        return originalFile;
      }

      final File compressedFile = File(compressedXFile.path);

      if (await compressedFile.exists()) {
        final originalKb = originalFile.lengthSync() ~/ 1024;
        final compressedKb = compressedFile.lengthSync() ~/ 1024;
        print('Image compressed: $originalKb KB → $compressedKb KB');
        return compressedFile;
      }

      return originalFile;
    } catch (e) {
      print('Compression error: $e');
      return originalFile;
    }
  }

  // Optional: Clean old compressed temp files (call this on app start or logout)
  Future<void> clearTempCompressedFiles() async {
    try {
      final dir = await getTemporaryDirectory();
      final files = dir.listSync();
      for (var entity in files) {
        if (entity is File && entity.path.contains('comp_')) {
          await entity.delete();
        }
      }
    } catch (_) {}
  }

  // GET request
  Future<NetworkResponse> getRequest(
    String url, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    String? accessToken,
  }) async {
    return _handleRequest(
      method: 'GET',
      url: url,
      queryParams: queryParams,
      headers: headers,
      accessToken: accessToken,
    );
  }

  // POST request
  Future<NetworkResponse> postRequest(
    String url, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    File? image,
    List<File>? images,
    File? cover,
    String? keyNameImage,
    String? keyNameCover,
    String? accessToken,
  }) async {
    return _handleRequest(
      method: 'POST',
      url: url,
      queryParams: queryParams,
      headers: headers,
      body: body,
      image: image,
      images: images,
      cover: cover,
      keyNameImage: keyNameImage,
      keyNameCover: keyNameCover,
      accessToken: accessToken,
    );
  }

  // PATCH request
  Future<NetworkResponse> patchRequest(
    String url, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    File? image,
    List<File>? images,
    File? cover,
    String? keyNameImage,
    String? keyNameCover,
    String? accessToken,
  }) async {
    return _handleRequest(
      method: 'PATCH',
      url: url,
      queryParams: queryParams,
      headers: headers,
      body: body,
      image: image,
      images: images,
      cover: cover,
      keyNameImage: keyNameImage,
      keyNameCover: keyNameCover,
      accessToken: accessToken,
    );
  }

  // PUT request
  Future<NetworkResponse> putRequest(
    String url, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    File? image,
    List<File>? images,
    File? cover,
    String? keyNameImage,
    String? keyNameCover,
    String? accessToken,
  }) async {
    return _handleRequest(
      method: 'PUT',
      url: url,
      queryParams: queryParams,
      headers: headers,
      body: body,
      image: image,
      images: images,
      cover: cover,
      keyNameImage: keyNameImage,
      keyNameCover: keyNameCover,
      accessToken: accessToken,
    );
  }

  // DELETE request
  Future<NetworkResponse> deleteRequest(
    String url, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    String? accessToken,
  }) async {
    return _handleRequest(
      method: 'DELETE',
      url: url,
      queryParams: queryParams,
      headers: headers,
      body: body,
      accessToken: accessToken,
    );
  }

  void _logRequest(String url, Map<String, String> headers, [dynamic body]) {
    _logger.i('URL => $url\nHeaders => $headers\nBody => $body');
  }

  void _logResponse(
    String url,
    int statusCode,
    Map<String, String>? headers,
    String body, [
    String? errorMessage,
  ]) {
    if (errorMessage != null) {
      _logger.e('URL => $url\nError => $errorMessage');
    } else {
      _logger.i(
        'URL => $url\nStatusCode => $statusCode\nHeaders => $headers\nBody => $body',
      );
    }
  }

  Future<NetworkResponse> _handleRequest({
    required String method,
    required String url,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    dynamic body,
    File? image,
    List<File>? images,
    File? cover,
    String? keyNameImage,
    String? keyNameCover,
    String? accessToken,
  }) async {
    try {
      // Append query parameters
      String fullUrl = url;
      if (queryParams != null && queryParams.isNotEmpty) {
        fullUrl +=
            '?${queryParams.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}').join('&')}';
      }

      Uri uri = Uri.parse(fullUrl);

      Map<String, String> defaultHeaders = {
        'Accept': 'application/json',
        ...?headers,
      };

      if (accessToken != null && accessToken.isNotEmpty) {
        defaultHeaders['Authorization'] = accessToken;
      }

      http.Response? response;

      // Check if multipart needed
      if (image != null || images?.isNotEmpty == true || cover != null) {
        final request = http.MultipartRequest(method, uri);
        request.headers.addAll(defaultHeaders);

        // Add JSON payload
        if (body != null) {
          request.fields['payload'] = jsonEncode(body);
        }

        // Single image
        if (image != null) {
          final compressed = await _compressImage(image);
          final mime = lookupMimeType(compressed!.path) ?? 'image/jpeg';
          request.files.add(
            await http.MultipartFile.fromPath(
              keyNameImage ?? 'image',
              compressed.path,
              contentType: MediaType.parse(mime),
            ),
          );
        }

        // Multiple images
        if (images != null && images.isNotEmpty) {
          for (File img in images) {
            final compressed = await _compressImage(img);
            final mime = lookupMimeType(compressed!.path) ?? 'image/jpeg';
            request.files.add(
              await http.MultipartFile.fromPath(
                keyNameImage ?? 'images',
                compressed.path,
                contentType: MediaType.parse(mime),
              ),
            );
          }
        }

        // Cover image
        if (cover != null) {
          final compressed = await _compressImage(cover);
          final mime = lookupMimeType(compressed!.path) ?? 'image/jpeg';
          request.files.add(
            await http.MultipartFile.fromPath(
              keyNameCover ?? 'cover',
              compressed.path,
              contentType: MediaType.parse(mime),
            ),
          );
        }

        _logRequest(fullUrl, request.headers, request.fields);
        final streamedResponse = await request.send();
        response = await http.Response.fromStream(streamedResponse);
      } else {
        // Regular JSON request
        _logRequest(fullUrl, defaultHeaders, body);
        switch (method) {
          case 'GET':
            response = await http.get(uri, headers: defaultHeaders);
            break;
          case 'POST':
            response = await http.post(
              uri,
              headers: {...defaultHeaders, 'Content-Type': 'application/json'},
              body: body != null ? jsonEncode(body) : null,
            );
            break;
          case 'PATCH':
            response = await http.patch(
              uri,
              headers: {...defaultHeaders, 'Content-Type': 'application/json'},
              body: body != null ? jsonEncode(body) : null,
            );
            break;
          case 'PUT':
            response = await http.put(
              uri,
              headers: {...defaultHeaders, 'Content-Type': 'application/json'},
              body: body != null ? jsonEncode(body) : null,
            );
            break;
          case 'DELETE':
            response = await http.delete(
              uri,
              headers: {
                ...defaultHeaders,
                'Content-Type': 'application/json',
              },
              body: body != null ? jsonEncode(body) : null,
            );
            break;
        }
      }

      _logResponse(
        fullUrl,
        response!.statusCode,
        response.headers,
        response.body,
      );

      // Success
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final decodedResponse = jsonDecode(response.body);
          return NetworkResponse(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: decodedResponse,
          );
        } catch (e) {
          return NetworkResponse(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: response.body,
          );
        }
      } else {
        // Error
        String errorMsg = 'Something went wrong';
        try {
          final decodedResponse = jsonDecode(response.body);
          final errorModel = ErrorMessageModel.fromJson(decodedResponse);
          errorMsg = errorModel.message ?? errorMsg;
        } catch (_) {
          errorMsg = response.body.isNotEmpty ? response.body : errorMsg;
        }

        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: errorMsg,
        );
      }
    } catch (e) {
      _logResponse(url, -1, null, '', e.toString());
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }
}
